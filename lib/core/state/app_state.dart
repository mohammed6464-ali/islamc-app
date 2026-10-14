import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:timezone/timezone.dart' as tz;

import '../adhan/adhan_audio_catalog.dart';
import '../data/demo_data.dart';
import '../l10n/app_copy.dart';
import '../l10n/app_language.dart';
import '../data/hijri_date.dart';
import '../data/models.dart';
import '../events/event_repository.dart';
import '../location/app_geo.dart';
import '../location/app_location.dart';
import '../location/location_failure.dart';
import '../location/location_provider.dart';
import '../notifications/notification_gateway.dart';
import '../notifications/prayer_notification_scheduler.dart';
import '../persistence/settings_store.dart';
import '../prayer/daily_prayer_times.dart';
import '../prayer/prayer_calc_method.dart';
import '../prayer/prayer_times_service.dart';
import '../time/app_clock.dart';
import '../time/app_timezone.dart';
import '../weather/weather_repository.dart';
import '../weather/weather_snapshot.dart';

/// Shared app state: location, dates, prayer times and demo preferences.
class AppState extends ChangeNotifier {
  AppState({
    AppClock? clock,
    PrayerTimesService? prayerTimesService,
    LocationProvider? locationProvider,
    SettingsStore? store,
    WeatherRepository? weatherRepository,
    NotificationGateway? notificationGateway,
    this.enableTicker = false,
  }) : clock = clock ?? const SystemClock(),
       _prayerService = prayerTimesService ?? const PrayerTimesService(),
       _locationProvider = locationProvider,
       _store = store ?? MemorySettingsStore(),
       _weatherRepository = weatherRepository,
       _notificationGateway = notificationGateway,
       _eventRepository = const EventRepository() {
    _scheduler = notificationGateway == null
        ? null
        : PrayerNotificationScheduler(gateway: notificationGateway);
    _prayerAlerts = <String, bool>{
      for (final PrayerTemplate t in DemoData.prayerTemplates)
        t.id: t.supportsAlert,
    };
    _eventPreAlerts = <String, bool>{};
    _readNotifications = <String>{};
    _location = _locationFromCity(
      DemoData.riyadh,
      LocationSelectionMode.manual,
      DateTime.now().toUtc(),
    );
    _recompute(persist: false);
  }

  final AppClock clock;
  final PrayerTimesService _prayerService;
  final LocationProvider? _locationProvider;
  final SettingsStore _store;
  final WeatherRepository? _weatherRepository;
  final NotificationGateway? _notificationGateway;
  final EventRepository _eventRepository;
  PrayerNotificationScheduler? _scheduler;
  final bool enableTicker;

  Timer? _ticker;
  bool _hydrated = false;
  bool _onboardingComplete = false;
  bool _locating = false;
  LocationFailure? _locationError;
  String? _prayerError;

  late AppLocation _location;
  late DailyPrayerTimes _todayTimes;
  late NextPrayer _next;
  late DateTime _civilToday;
  DateTime? _lastCivilToday;

  // ------------------------------------------------------------- location
  AppLocation get location => _location;
  bool get autoDetectLocation =>
      _location.selectionMode == LocationSelectionMode.automatic;
  bool get onboardingComplete => _onboardingComplete;
  bool get locating => _locating;
  LocationFailure? get locationError => _locationError;
  String? get prayerError => _prayerError;

  String get cityId => _location.catalogId ?? 'custom';

  CityData get city {
    final String? id = _location.catalogId;
    if (id != null) {
      return DemoData.cityById(id).copyWith(
        name: _location.cityName,
        country: _location.countryName,
        latitude: _location.latitude,
        longitude: _location.longitude,
        timezoneId: _location.timezoneId,
      );
    }
    final CityData nearest = DemoData.nearestCity(
      _location.latitude,
      _location.longitude,
    );
    return nearest.copyWith(
      id: 'custom',
      name: _location.cityName,
      country: _location.countryName,
      latitude: _location.latitude,
      longitude: _location.longitude,
      timezoneId: _location.timezoneId,
    );
  }

  Future<void> hydrate() async {
    AppTimezone.ensureInitialized();
    final Map<String, Object?> data = await _store.load();
    _onboardingComplete = data['onboardingComplete'] == true;
    _useFahrenheit = data['useFahrenheit'] == true;
    _darkMode = data['darkMode'] == true;
    _language = AppLanguage.normalize(data['language'] as String?);
    _masterPrayerAlerts = data['masterPrayerAlerts'] as bool? ?? true;
    _preAlertMinutes = data['preAlertMinutes'] as int? ?? 0;
    _adhanMosque = AdhanAudioCatalog.fromStored(
      data['adhanMosque'] as String? ?? data['adhanSound'] as String?,
    );
    _eventAlerts = data['eventAlerts'] as bool? ?? true;
    _hijriView = data['hijriView'] == true;
    _prayerAlerts = _stringBoolMap(data['prayerAlerts'], _prayerAlerts);
    _eventPreAlerts = _stringBoolMap(data['eventPreAlerts'], _eventPreAlerts);
    _favoriteEvents.addAll(_stringList(data['favoriteEvents']));
    _readNotifications = _stringList(data['readNotifications']).toSet();
    _inbox = _notificationList(data['inbox']);
    final String? methodLabel = data['calculationMethod'] as String?;
    if (methodLabel != null) {
      _calculationMethod = PrayerCalcMethod.fromStored(methodLabel);
    }
    final Object? locationJson = data['location'];
    if (locationJson is Map<String, dynamic>) {
      _location = AppLocation.fromJson(Map<String, Object?>.from(locationJson));
    } else if (locationJson is Map) {
      _location = AppLocation.fromJson(
        locationJson.map(
          (Object? key, Object? value) =>
              MapEntry<String, Object?>(key.toString(), value),
        ),
      );
    }
    _hydrated = true;
    _recompute(persist: false);
    unawaited(_loadWeather());
    unawaited(resyncNotifications());
    _startTicker();
  }

  Future<void> completeOnboarding() async {
    if (_onboardingComplete) {
      return;
    }
    _onboardingComplete = true;
    await _persist();
    notifyListeners();
  }

  void selectCity(String id) {
    final CityData chosen = DemoData.cityById(id);
    _location = _locationFromCity(
      chosen,
      LocationSelectionMode.manual,
      clock.nowUtc(),
    );
    _locationError = null;
    _onboardingComplete = true;
    _recompute();
    unawaited(_loadWeather(force: true));
    unawaited(resyncNotifications());
  }

  Future<void> setAutoDetectLocation(bool value) async {
    if (value) {
      await requestCurrentLocation();
      return;
    }
    _location = _location.copyWith(
      selectionMode: LocationSelectionMode.manual,
      fromCache: false,
    );
    await _persist();
    notifyListeners();
  }

  /// Asks for permission if needed, reads GPS, and stores the result.
  Future<bool> requestCurrentLocation() async {
    final LocationProvider? provider = _locationProvider;
    if (provider == null) {
      _locationError = LocationFailure.unavailable;
      notifyListeners();
      return false;
    }

    _locating = true;
    _locationError = null;
    notifyListeners();

    try {
      final bool enabled = await provider.isServiceEnabled();
      if (!enabled) {
        throw LocationFailure.serviceDisabled;
      }

      AppPermissionStatus permission = await provider.checkPermission();
      if (!permission.isGranted) {
        permission = await provider.requestPermission();
      }
      if (permission == AppPermissionStatus.deniedForever) {
        throw LocationFailure.deniedForever;
      }
      if (!permission.isGranted) {
        throw LocationFailure.denied;
      }

      final GeoFix fix = await provider.getCurrentPosition();
      GeoPlace? place;
      try {
        place = await provider.reverseGeocode(fix.latitude, fix.longitude);
      } catch (_) {
        place = null;
      }

      final CityData? matched = DemoData.matchCity(
        latitude: fix.latitude,
        longitude: fix.longitude,
        name: place?.cityName,
      );
      final CityData nearest = DemoData.nearestCity(fix.latitude, fix.longitude);
      final bool inSaudi = _isSaudi(place);

      _location = AppLocation(
        latitude: fix.latitude,
        longitude: fix.longitude,
        cityName: place?.cityName ?? matched?.name ?? nearest.name,
        countryName:
            place?.countryName ??
            matched?.country ??
            'المملكة العربية السعودية',
        timezoneId: matched?.timezoneId ??
            (inSaudi ? 'Asia/Riyadh' : nearest.timezoneId),
        selectionMode: LocationSelectionMode.automatic,
        lastUpdated: clock.nowUtc(),
        catalogId: matched?.id,
      );
      if (place == null) {
        _locationError = LocationFailure.geocodingFailed;
      }
      _onboardingComplete = true;
      _locating = false;
      _recompute();
      unawaited(_loadWeather(force: true));
      unawaited(resyncNotifications());
      return true;
    } on LocationFailure catch (error) {
      _locating = false;
      _locationError = error;
      if (_location.catalogId != null || _hydrated) {
        _location = _location.copyWith(fromCache: true);
      }
      notifyListeners();
      return false;
    } catch (_) {
      _locating = false;
      _locationError = LocationFailure.unavailable;
      notifyListeners();
      return false;
    }
  }

  static bool _isSaudi(GeoPlace? place) {
    final String country = place?.countryName ?? '';
    final String code = place?.isoCountryCode ?? '';
    return code.toUpperCase() == 'SA' ||
        country.contains('السعودية') ||
        country.toLowerCase().contains('saudi');
  }

  static AppLocation _locationFromCity(
    CityData city,
    LocationSelectionMode mode,
    DateTime nowUtc,
  ) {
    return AppLocation(
      latitude: city.latitude,
      longitude: city.longitude,
      cityName: city.name,
      countryName: city.country,
      timezoneId: city.timezoneId,
      selectionMode: mode,
      lastUpdated: nowUtc,
      catalogId: city.id,
    );
  }

  // ---------------------------------------------------------------- units
  bool _useFahrenheit = false;

  bool get useFahrenheit => _useFahrenheit;

  String get temperatureUnitLabel => _useFahrenheit ? 'فهرنهايت F°' : 'مئوية C°';
  String get temperatureUnitName => _useFahrenheit ? 'فهرنهايت' : 'مئوية';

  String temperatureUnitLabelFor(AppCopy copy) =>
      _useFahrenheit ? copy.l10n.fahrenheitLabel : copy.l10n.celsiusLabel;

  String temperatureUnitNameFor(AppCopy copy) =>
      _useFahrenheit ? copy.l10n.fahrenheit : copy.l10n.celsius;

  void setUseFahrenheit(bool value) {
    if (_useFahrenheit == value) return;
    _useFahrenheit = value;
    _persist();
    notifyListeners();
  }

  int convertTemperature(int celsius) =>
      _useFahrenheit ? (celsius * 9 / 5 + 32).round() : celsius;

  String formatTemperature(int celsius) => '${convertTemperature(celsius)}°';

  // ----------------------------------------------------- appearance / lang
  bool _darkMode = false;
  String _language = AppLanguage.arabic;

  bool get darkMode => _darkMode;
  String get language => _language;
  String get languageCode => _language;
  Locale get locale => AppLanguage.localeOf(_language);
  bool get isEnglish => AppLanguage.isEnglish(_language);

  void setDarkMode(bool value) {
    if (_darkMode == value) return;
    _darkMode = value;
    _persist();
    notifyListeners();
  }

  void setLanguage(String value) {
    final String next = AppLanguage.normalize(value);
    if (_language == next) return;
    _language = next;
    _persist();
    notifyListeners();
    unawaited(resyncNotifications());
  }

  // ----------------------------------------------------------- calculation
  PrayerCalcMethod _calculationMethod = PrayerCalcMethod.defaultMethod;

  String get calculationMethod => _calculationMethod.label;
  PrayerCalcMethod get calculationMethodEnum => _calculationMethod;

  void setCalculationMethod(String value) {
    setCalculationMethodEnum(PrayerCalcMethod.fromStored(value));
  }

  void setCalculationMethodEnum(PrayerCalcMethod parsed) {
    if (_calculationMethod == parsed) return;
    _calculationMethod = parsed;
    _recompute();
    unawaited(resyncNotifications());
  }

  // --------------------------------------------------------- prayer alerts
  bool _masterPrayerAlerts = true;
  late Map<String, bool> _prayerAlerts;
  int _preAlertMinutes = 0;
  AdhanMosque _adhanMosque = AdhanMosque.makkah;
  bool _eventAlerts = true;

  bool get masterPrayerAlerts => _masterPrayerAlerts;
  int get preAlertMinutes => _preAlertMinutes;
  String get adhanSound => AdhanAudioCatalog.mosqueLabel(_adhanMosque);
  AdhanMosque get adhanMosque => _adhanMosque;
  bool get eventAlerts => _eventAlerts;
  NotificationGateway? get notificationGateway => _notificationGateway;

  bool alertFor(String prayerId) =>
      _masterPrayerAlerts && (_prayerAlerts[prayerId] ?? false);

  bool rawAlertFor(String prayerId) => _prayerAlerts[prayerId] ?? false;

  int get enabledAlertCount =>
      _prayerAlerts.values.where((bool enabled) => enabled).length;

  void setMasterPrayerAlerts(bool value) {
    if (_masterPrayerAlerts == value) return;
    _masterPrayerAlerts = value;
    _persist();
    notifyListeners();
    unawaited(resyncNotifications());
  }

  void setPrayerAlert(String prayerId, bool value) {
    if (_prayerAlerts[prayerId] == value) return;
    _prayerAlerts[prayerId] = value;
    _persist();
    notifyListeners();
    unawaited(resyncNotifications());
  }

  void togglePrayerAlert(String prayerId) =>
      setPrayerAlert(prayerId, !rawAlertFor(prayerId));

  void setPreAlertMinutes(int value) {
    if (_preAlertMinutes == value) return;
    _preAlertMinutes = value;
    _persist();
    notifyListeners();
    unawaited(resyncNotifications());
  }

  void setAdhanSound(String value) {
    setAdhanMosque(AdhanAudioCatalog.fromStored(value));
  }

  void setAdhanMosque(AdhanMosque mosque) {
    if (_adhanMosque == mosque) return;
    _adhanMosque = mosque;
    _persist();
    notifyListeners();
  }

  void setEventAlerts(bool value) {
    if (_eventAlerts == value) return;
    _eventAlerts = value;
    _persist();
    notifyListeners();
    unawaited(resyncNotifications());
  }

  // -------------------------------------------------------------- calendar
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  bool _hijriView = false;

  DateTime get selectedDate => _selectedDate;
  DateTime get visibleMonth => _visibleMonth;
  bool get hijriView => _hijriView;
  DateTime get today => _civilToday;

  void selectDate(DateTime date) {
    final DateTime normalized = DateTime(date.year, date.month, date.day);
    if (_selectedDate == normalized) return;
    _selectedDate = normalized;
    notifyListeners();
  }

  void showMonth(DateTime month) {
    final DateTime normalized = DateTime(month.year, month.month);
    if (_visibleMonth == normalized) return;
    _visibleMonth = normalized;
    notifyListeners();
  }

  void shiftMonth(int delta) =>
      showMonth(DateTime(_visibleMonth.year, _visibleMonth.month + delta));

  void setHijriView(bool value) {
    if (_hijriView == value) return;
    _hijriView = value;
    _persist();
    notifyListeners();
  }

  void shiftHijriMonth(int delta) {
    final HijriDate current = HijriDate.fromGregorian(
      DateTime(_visibleMonth.year, _visibleMonth.month, 15),
    );
    int month = current.month + delta;
    int year = current.year;
    while (month < 1) {
      month += 12;
      year -= 1;
    }
    while (month > 12) {
      month -= 12;
      year += 1;
    }
    showMonth(HijriDate(year, month, 1).toGregorian());
  }

  // --------------------------------------------------------- notifications
  late Set<String> _readNotifications;
  List<AppNotification> _inbox = <AppNotification>[];
  DateTime? lastTestNotificationAt;
  String? notificationPermissionMessage;

  List<AppNotification> get notifications => List<AppNotification>.unmodifiable(
    _inbox,
  );

  bool isNotificationRead(String id) => _readNotifications.contains(id);

  int get unreadNotificationCount => _inbox
      .where((AppNotification n) => !_readNotifications.contains(n.id))
      .length;

  bool get hasUnreadNotifications => unreadNotificationCount > 0;

  void markNotificationRead(String id) {
    if (!_readNotifications.add(id)) return;
    _persist();
    notifyListeners();
  }

  void markAllNotificationsRead() {
    if (!hasUnreadNotifications) return;
    _readNotifications = <String>{
      for (final AppNotification n in _inbox) n.id,
    };
    _persist();
    notifyListeners();
  }

  void recordDeliveredNotification(AppNotification notification) {
    if (_inbox.any((AppNotification item) => item.id == notification.id)) {
      return;
    }
    _inbox.insert(0, notification);
    _persist();
    notifyListeners();
  }

  // ------------------------------------------------------------ favourites
  final Set<String> _favoriteEvents = <String>{};
  late Map<String, bool> _eventPreAlerts;

  bool isFavoriteEvent(String id) => _favoriteEvents.contains(id);

  bool toggleFavoriteEvent(String id) {
    final bool added = _favoriteEvents.add(id);
    if (!added) _favoriteEvents.remove(id);
    _persist();
    notifyListeners();
    return added;
  }

  bool eventPreAlert(String id) => _eventPreAlerts[id] ?? false;

  void setEventPreAlert(String id, bool value) {
    if (_eventPreAlerts[id] == value) return;
    _eventPreAlerts[id] = value;
    _persist();
    notifyListeners();
    unawaited(_syncEventReminder(id, value));
  }

  List<IslamicEvent> get upcomingEvents =>
      _eventRepository.upcoming(_civilToday);

  IslamicEvent? get featuredEvent => _eventRepository.featured(_civilToday);

  IslamicEvent eventById(String id) =>
      _eventRepository.byId(id, _civilToday) ?? DemoData.eventById(id);

  IslamicEvent? eventOn(DateTime date) => _eventRepository.eventOn(date);

  int daysUntil(DateTime date) => DemoData.daysUntil(date, _civilToday);

  // ------------------------------------------------------- derived prayers
  DailyPrayerTimes get dailyTimes => _todayTimes;

  List<PrayerTime> get prayerTimes {
    return <PrayerTime>[
      for (final PrayerTemplate template in DemoData.prayerTemplates)
        _toPrayerTime(template, _todayTimes.timeOf(template.id)),
    ];
  }

  PrayerTime _toPrayerTime(PrayerTemplate template, DateTime occursAt) {
    final PrayerStatus status;
    if (template.forbidden) {
      status = PrayerStatus.forbidden;
    } else if (template.id == _next.id &&
        occursAt.year == _next.occursAt.year &&
        occursAt.month == _next.occursAt.month &&
        occursAt.day == _next.occursAt.day) {
      status = PrayerStatus.next;
    } else if (!occursAt.isAfter(AppTimezone.nowIn(_location.timezoneId, clock))) {
      status = PrayerStatus.passed;
    } else {
      status = PrayerStatus.upcoming;
    }

    final String note = switch (status) {
      PrayerStatus.next => 'الصلاة القادمة',
      PrayerStatus.passed => template.passedNote,
      PrayerStatus.forbidden => template.passedNote,
      PrayerStatus.upcoming => template.upcomingNote,
    };

    return PrayerTime(
      id: template.id,
      name: template.name,
      longName: template.longName,
      note: note,
      icon: template.icon,
      minutes: occursAt.hour * 60 + occursAt.minute,
      status: status,
      supportsAlert: template.supportsAlert,
      occursAt: occursAt,
    );
  }

  PrayerTime get nextPrayer {
    final PrayerTemplate template = DemoData.prayerTemplates.firstWhere(
      (PrayerTemplate t) => t.id == _next.id,
    );
    return PrayerTime(
      id: template.id,
      name: template.name,
      longName: template.longName,
      note: template.upcomingNote,
      icon: template.icon,
      minutes: _next.occursAt.hour * 60 + _next.occursAt.minute,
      status: PrayerStatus.next,
      supportsAlert: template.supportsAlert,
      occursAt: _next.occursAt,
    );
  }

  PrayerTime prayerById(String id) =>
      prayerTimes.firstWhere((PrayerTime p) => p.id == id);

  PrayerTime asrForCity(CityData city) {
    final DailyPrayerTimes times = _prayerService.calculate(
      date: _civilToday,
      latitude: city.latitude,
      longitude: city.longitude,
      timezoneId: city.timezoneId,
      method: _calculationMethod,
    );
    final PrayerTemplate template = DemoData.prayerTemplates.firstWhere(
      (PrayerTemplate t) => t.id == 'asr',
    );
    return PrayerTime(
      id: template.id,
      name: template.name,
      longName: template.longName,
      note: template.upcomingNote,
      icon: template.icon,
      minutes: times.asr.hour * 60 + times.asr.minute,
      status: PrayerStatus.upcoming,
      supportsAlert: true,
      occursAt: times.asr,
    );
  }

  int get remainingSeconds =>
      _prayerService.remaining(_next.occursAt, clock.nowUtc()).inSeconds;

  String get countdown {
    final int total = remainingSeconds;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(total ~/ 3600)}:${two((total % 3600) ~/ 60)}:${two(total % 60)}';
  }

  double get countdownProgress {
    final DateTime now = AppTimezone.nowIn(_location.timezoneId, clock);
    DateTime previous = _todayTimes.isha;
    for (final ({String id, DateTime time}) entry
        in _todayTimes.obligatoryWithNextFajr) {
      if (entry.time == _next.occursAt) {
        break;
      }
      previous = entry.time;
    }
    if (!_next.isTomorrow && _next.id == 'fajr') {
      previous = _todayTimes.isha.subtract(const Duration(hours: 8));
    }
    final int window = _next.occursAt.difference(previous).inSeconds;
    if (window <= 0) {
      return 0;
    }
    final int remaining = _next.occursAt.difference(now).inSeconds;
    return (1 - remaining / window).clamp(0.0, 1.0);
  }

  // ------------------------------------------------------- derived weather
  WeatherSnapshot? _weatherSnapshot;
  String? _weatherError;
  bool _weatherRefreshing = false;
  int _weatherGeneration = 0;
  int _selectedForecastIndex = 0;

  WeatherSnapshot? get weatherSnapshot => _weatherSnapshot;
  String? get weatherError => _weatherError;
  bool get weatherRefreshing => _weatherRefreshing;
  int get selectedForecastIndex => _selectedForecastIndex;
  bool get hasLiveWeather =>
      _weatherRepository != null && _weatherSnapshot != null;

  WeatherData get weather {
    if (_weatherSnapshot != null) {
      return _weatherSnapshot!.data.copyWith(
        isFromCache: _weatherSnapshot!.isFromCache,
      );
    }
    final WeatherData demo = DemoData.weatherFor(_weatherCity);
    if (_weatherRepository == null) {
      return demo;
    }
    return demo.copyWith(
      isUnavailable: true,
      station: 'بيانات غير متاحة',
      badge: 'غير متاح',
    );
  }

  CityData get _weatherCity {
    final String? id = _location.catalogId;
    return id != null
        ? DemoData.cityById(id)
        : DemoData.nearestCity(_location.latitude, _location.longitude);
  }

  String get weatherStatusLabel {
    if (_weatherRefreshing && _weatherSnapshot == null) {
      return 'جاري تحديث بيانات الطقس...';
    }
    if (_weatherSnapshot == null) {
      if (_weatherError != null) {
        return _weatherError!;
      }
      if (_weatherRepository == null) {
        return 'تحديث مباشر لـ${weather.station}';
      }
      return 'بيانات الطقس غير متاحة لهذه المدينة.';
    }
    if (_weatherSnapshot!.isFromCache ||
        _weatherSnapshot!.isStale(clock.nowUtc())) {
      return 'بيانات محفوظة لـ${_weatherSnapshot!.data.station}';
    }
    return 'تحديث مباشر لـ${_weatherSnapshot!.data.station}';
  }

  String get weatherUpdatedLabel {
    final DateTime? fetched = _weatherSnapshot?.fetchedAt;
    if (fetched == null) {
      return '';
    }
    final Duration age = clock.nowUtc().difference(fetched.toUtc());
    if (age.inMinutes < 1) {
      return 'آخر تحديث الآن';
    }
    if (age.inMinutes < 60) {
      return 'آخر تحديث قبل ${age.inMinutes} د';
    }
    final DateTime local = AppTimezone.convert(fetched, _location.timezoneId);
    return 'آخر تحديث ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  void selectForecastIndex(int index) {
    if (_selectedForecastIndex == index) {
      return;
    }
    if (index < 0 || index >= weather.forecast.length) {
      return;
    }
    _selectedForecastIndex = index;
    notifyListeners();
  }

  /// Returns false if a refresh was ignored because one is already running.
  Future<bool> refreshWeather({bool force = true}) async {
    if (_weatherRefreshing) {
      return false;
    }
    await _loadWeather(force: force);
    return _weatherError == null;
  }

  Future<void> _loadWeather({bool force = false}) async {
    final WeatherRepository? repository = _weatherRepository;
    if (repository == null) {
      return;
    }
    final int generation = ++_weatherGeneration;
    final AppLocation requested = _location;
    _weatherRefreshing = true;
    _weatherError = null;
    notifyListeners();
    try {
      final WeatherSnapshot snapshot = await repository.fetch(
        latitude: requested.latitude,
        longitude: requested.longitude,
        timezoneId: requested.timezoneId,
        today: _civilToday,
        forceRefresh: force,
      );
      if (generation != _weatherGeneration) {
        return;
      }
      if (requested.latitude != _location.latitude ||
          requested.longitude != _location.longitude) {
        return;
      }
      _weatherSnapshot = snapshot;
      _weatherError = null;
      final int todayIndex = snapshot.data.forecast.indexWhere(
        (DailyForecast day) => day.isToday,
      );
      _selectedForecastIndex = todayIndex >= 0 ? todayIndex : 0;
    } on WeatherFailure catch (error) {
      if (generation != _weatherGeneration) {
        return;
      }
      _weatherError = error.messageAr;
    } catch (_) {
      if (generation != _weatherGeneration) {
        return;
      }
      _weatherError = WeatherFailure.unavailable.messageAr;
    } finally {
      if (generation == _weatherGeneration) {
        _weatherRefreshing = false;
        notifyListeners();
      }
    }
  }

  // --------------------------------------------------------- derived dates
  HijriDate get hijriToday => HijriDate.fromGregorian(_civilToday);

  String get hijriLabel => hijriToday.formatted;
  String get gregorianLabel => GregorianLabels.formatted(_civilToday);

  String get prayerSourceLabel => '${_location.cityName} • ${DemoData.calendarName}';

  String get timezoneLabel => 'توقيت ${_location.cityName}';

  String get coordinatesLabel =>
      AppGeo.coordinatesLabel(_location.latitude, _location.longitude);

  String get gpsStatusLabel {
    if (_location.fromCache) {
      return 'آخر موقع معروف';
    }
    if (_location.isAutomatic) {
      return 'إشارة GPS قوية دقيقة';
    }
    return 'موقع يدوي';
  }

  String notificationBody(AppNotification notification) => notification
      .bodyTemplate
      .replaceAll('{city}', _location.cityName)
      .replaceAll('{time}', prayerById('dhuhr').timeWithPeriod)
      .replaceAll(
        '{days}',
        '${daysUntil(featuredEvent?.date ?? _civilToday)}',
      );

  void onAppResumed() {
    _recompute(persist: false);
    if (autoDetectLocation) {
      unawaited(requestCurrentLocation());
    }
    final WeatherSnapshot? snapshot = _weatherSnapshot;
    if (snapshot == null || snapshot.isStale(clock.nowUtc())) {
      unawaited(_loadWeather());
    }
    unawaited(resyncNotifications());
  }

  Future<bool> requestNotificationPermission() async {
    final NotificationGateway? gateway = _notificationGateway;
    if (gateway == null) {
      return true;
    }
    final bool allowed = await gateway.requestPermission();
    if (!allowed) {
      notificationPermissionMessage = AppCopy.forCode(
        _language,
      ).l10n.notificationsDisabled;
    } else {
      notificationPermissionMessage = null;
    }
    notifyListeners();
    return allowed;
  }

  Future<void> openNotificationSettings() async {
    await _notificationGateway?.openSystemSettings();
  }

  Future<void> resyncNotifications() async {
    final PrayerNotificationScheduler? scheduler = _scheduler;
    if (scheduler == null) {
      return;
    }
    final AppCopy copy = AppCopy.forCode(_language);
    await scheduler.reschedulePrayers(
      nowUtc: clock.nowUtc(),
      today: _civilToday,
      latitude: _location.latitude,
      longitude: _location.longitude,
      timezoneId: _location.timezoneId,
      method: _calculationMethod,
      prefs: PrayerSchedulePrefs(
        masterEnabled: _masterPrayerAlerts,
        enabledPrayerIds: <String>{
          for (final MapEntry<String, bool> entry in _prayerAlerts.entries)
            if (entry.value) entry.key,
        },
        preAlertMinutes: _preAlertMinutes,
        eventAlerts: _eventAlerts,
        eventReminderIds: <String>{
          for (final MapEntry<String, bool> entry in _eventPreAlerts.entries)
            if (entry.value) entry.key,
        },
        cityName: copy.cityNameFromId(_location.catalogId, _location.cityName),
        languageCode: _language,
      ),
    );
    if (_eventAlerts) {
      for (final MapEntry<String, bool> entry in _eventPreAlerts.entries) {
        if (entry.value) {
          await _syncEventReminder(entry.key, true);
        }
      }
    }
  }

  Future<DateTime?> scheduleTestNotification() async {
    final PrayerNotificationScheduler? scheduler = _scheduler;
    if (scheduler == null) {
      notificationPermissionMessage = AppCopy.forCode(
        _language,
      ).l10n.testUnavailable;
      notifyListeners();
      return null;
    }
    final bool allowed = await requestNotificationPermission();
    if (!allowed) {
      return null;
    }
    final bool exact =
        await _notificationGateway?.exactAlarmsAllowed() ?? true;
    if (!exact) {
      notificationPermissionMessage = AppCopy.forCode(
        _language,
      ).l10n.exactAlarmNeeded;
      notifyListeners();
    }
    try {
      final DateTime fireAt = await scheduler.scheduleTestNotification(
        nowUtc: clock.nowUtc(),
        languageCode: _language,
      );
      lastTestNotificationAt = fireAt;
      notifyListeners();
      return fireAt;
    } catch (_) {
      notificationPermissionMessage = AppCopy.forCode(_language).l10n.testFailed;
      notifyListeners();
      return null;
    }
  }

  Future<void> _syncEventReminder(String id, bool enabled) async {
    final PrayerNotificationScheduler? scheduler = _scheduler;
    if (scheduler == null) {
      return;
    }
    if (!enabled || !_eventAlerts) {
      await scheduler.cancelEventReminder(id);
      return;
    }
    final IslamicEvent? event = _eventRepository.byId(id, _civilToday);
    if (event == null) {
      return;
    }
    final tz.TZDateTime localMorning = tz.TZDateTime(
      AppTimezone.locationOf(_location.timezoneId),
      event.date.year,
      event.date.month,
      event.date.day,
      9,
    );
    await scheduler.scheduleEventReminder(
      eventId: event.id,
      title: event.titleFor(_language),
      fireAtUtc: localMorning.subtract(const Duration(days: 3)).toUtc(),
      nowUtc: clock.nowUtc(),
      languageCode: _language,
    );
  }

  void tick() => _recompute(persist: false);

  void _startTicker() {
    _ticker?.cancel();
    if (!enableTicker) {
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _recompute(persist: false);
    });
  }

  void _recompute({bool persist = true}) {
    AppTimezone.ensureInitialized();
    final DateTime civil = AppTimezone.calendarDate(
      _location.timezoneId,
      clock,
    );
    final bool dayChanged =
        _lastCivilToday == null ||
        civil.year != _lastCivilToday!.year ||
        civil.month != _lastCivilToday!.month ||
        civil.day != _lastCivilToday!.day;
    _civilToday = civil;
    if (dayChanged) {
      _selectedDate = civil;
      _visibleMonth = DateTime(civil.year, civil.month);
      _lastCivilToday = civil;
      if (_hydrated) {
        unawaited(resyncNotifications());
      }
    }

    try {
      _todayTimes = _prayerService.calculate(
        date: civil,
        latitude: _location.latitude,
        longitude: _location.longitude,
        timezoneId: _location.timezoneId,
        method: _calculationMethod,
      );
      _next = _prayerService.nextPrayer(_todayTimes, clock.nowUtc());
      _prayerError = null;
    } on PrayerTimesException catch (error) {
      _prayerError = error.message;
    }

    if (persist) {
      unawaited(_persist());
    }
    notifyListeners();
  }

  @visibleForTesting
  Future<void> flushPersistence() => _persist();

  Future<void> _persist() async {
    await _store.save(<String, Object?>{
      'onboardingComplete': _onboardingComplete,
      'calculationMethod': _calculationMethod.name,
      'useFahrenheit': _useFahrenheit,
      'darkMode': _darkMode,
      'language': _language,
      'masterPrayerAlerts': _masterPrayerAlerts,
      'preAlertMinutes': _preAlertMinutes,
      'adhanSound': AdhanAudioCatalog.mosqueLabel(_adhanMosque),
      'adhanMosque': _adhanMosque.name,
      'eventAlerts': _eventAlerts,
      'hijriView': _hijriView,
      'prayerAlerts': _prayerAlerts,
      'eventPreAlerts': _eventPreAlerts,
      'favoriteEvents': _favoriteEvents.toList(),
      'readNotifications': _readNotifications.toList(),
      'inbox': _inbox.map((AppNotification n) => n.toJson()).toList(),
      'location': _location.toJson(),
    });
  }

  static Map<String, bool> _stringBoolMap(
    Object? raw,
    Map<String, bool> fallback,
  ) {
    if (raw is! Map) {
      return fallback;
    }
    final Map<String, bool> result = Map<String, bool>.from(fallback);
    raw.forEach((Object? key, Object? value) {
      result[key.toString()] = value == true;
    });
    return result;
  }

  static List<String> _stringList(Object? raw) {
    if (raw is! List) {
      return const <String>[];
    }
    return raw.map((Object? item) => item.toString()).toList();
  }

  static List<AppNotification> _notificationList(Object? raw) {
    if (raw is! List) {
      return <AppNotification>[];
    }
    return raw
        .whereType<Map>()
        .map(
          (Map item) => AppNotification.fromJson(
            item.map(
              (Object? key, Object? value) =>
                  MapEntry<String, Object?>(key.toString(), value),
            ),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
