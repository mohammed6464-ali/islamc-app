import 'package:flutter/foundation.dart';

import '../data/demo_data.dart';
import '../data/hijri_date.dart';
import '../data/models.dart';

/// Single source of truth for every screen. Everything in here is demo state
/// held in memory — nothing is persisted and nothing talks to a service.
class AppState extends ChangeNotifier {
  AppState() {
    _prayerAlerts = <String, bool>{
      for (final PrayerTemplate t in DemoData.prayerTemplates)
        t.id: t.supportsAlert,
    };
    _eventPreAlerts = <String, bool>{
      for (final IslamicEvent e in DemoData.events) e.id: e.id == 'national-day',
    };
    _readNotifications = <String>{'national-day-soon', 'times-updated'};
    _selectedDate = DemoData.today;
    _visibleMonth = DateTime(DemoData.today.year, DemoData.today.month);
  }

  // ------------------------------------------------------------- location
  String _cityId = 'riyadh';
  bool _autoDetectLocation = true;

  CityData get city => DemoData.cityById(_cityId);
  String get cityId => _cityId;
  bool get autoDetectLocation => _autoDetectLocation;

  void selectCity(String id) {
    if (_cityId == id) return;
    _cityId = id;
    notifyListeners();
  }

  void setAutoDetectLocation(bool value) {
    if (_autoDetectLocation == value) return;
    _autoDetectLocation = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------- units
  bool _useFahrenheit = false;

  bool get useFahrenheit => _useFahrenheit;

  /// `مئوية C°` / `فهرنهايت F°`
  String get temperatureUnitLabel => _useFahrenheit ? 'فهرنهايت F°' : 'مئوية C°';
  String get temperatureUnitName => _useFahrenheit ? 'فهرنهايت' : 'مئوية';

  void setUseFahrenheit(bool value) {
    if (_useFahrenheit == value) return;
    _useFahrenheit = value;
    notifyListeners();
  }

  int convertTemperature(int celsius) =>
      _useFahrenheit ? (celsius * 9 / 5 + 32).round() : celsius;

  /// `28°`
  String formatTemperature(int celsius) => '${convertTemperature(celsius)}°';

  // ----------------------------------------------------- appearance / lang
  bool _darkMode = false;
  String _language = DemoData.languages.first;

  bool get darkMode => _darkMode;
  String get language => _language;

  void setDarkMode(bool value) {
    if (_darkMode == value) return;
    _darkMode = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }

  // ----------------------------------------------------------- calculation
  String _calculationMethod = DemoData.calculationMethods.first;

  String get calculationMethod => _calculationMethod;

  void setCalculationMethod(String value) {
    if (_calculationMethod == value) return;
    _calculationMethod = value;
    notifyListeners();
  }

  // --------------------------------------------------------- prayer alerts
  bool _masterPrayerAlerts = true;
  late Map<String, bool> _prayerAlerts;
  int _preAlertMinutes = 0;
  String _adhanSound = DemoData.adhanSounds.first;
  bool _eventAlerts = true;

  bool get masterPrayerAlerts => _masterPrayerAlerts;
  int get preAlertMinutes => _preAlertMinutes;
  String get adhanSound => _adhanSound;
  bool get eventAlerts => _eventAlerts;

  bool alertFor(String prayerId) =>
      _masterPrayerAlerts && (_prayerAlerts[prayerId] ?? false);

  bool rawAlertFor(String prayerId) => _prayerAlerts[prayerId] ?? false;

  int get enabledAlertCount =>
      _prayerAlerts.values.where((bool enabled) => enabled).length;

  void setMasterPrayerAlerts(bool value) {
    if (_masterPrayerAlerts == value) return;
    _masterPrayerAlerts = value;
    notifyListeners();
  }

  void setPrayerAlert(String prayerId, bool value) {
    if (_prayerAlerts[prayerId] == value) return;
    _prayerAlerts[prayerId] = value;
    notifyListeners();
  }

  void togglePrayerAlert(String prayerId) =>
      setPrayerAlert(prayerId, !rawAlertFor(prayerId));

  void setPreAlertMinutes(int value) {
    if (_preAlertMinutes == value) return;
    _preAlertMinutes = value;
    notifyListeners();
  }

  void setAdhanSound(String value) {
    if (_adhanSound == value) return;
    _adhanSound = value;
    notifyListeners();
  }

  void setEventAlerts(bool value) {
    if (_eventAlerts == value) return;
    _eventAlerts = value;
    notifyListeners();
  }

  // -------------------------------------------------------------- calendar
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  bool _hijriView = false;

  DateTime get selectedDate => _selectedDate;
  DateTime get visibleMonth => _visibleMonth;
  bool get hijriView => _hijriView;

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
    notifyListeners();
  }

  // --------------------------------------------------------- notifications
  late Set<String> _readNotifications;

  bool isNotificationRead(String id) => _readNotifications.contains(id);

  int get unreadNotificationCount => DemoData.notifications
      .where((AppNotification n) => !_readNotifications.contains(n.id))
      .length;

  bool get hasUnreadNotifications => unreadNotificationCount > 0;

  void markNotificationRead(String id) {
    if (!_readNotifications.add(id)) return;
    notifyListeners();
  }

  void markAllNotificationsRead() {
    if (!hasUnreadNotifications) return;
    _readNotifications = <String>{
      for (final AppNotification n in DemoData.notifications) n.id,
    };
    notifyListeners();
  }

  // ------------------------------------------------------------ favourites
  final Set<String> _favoriteEvents = <String>{};
  late Map<String, bool> _eventPreAlerts;

  bool isFavoriteEvent(String id) => _favoriteEvents.contains(id);

  bool toggleFavoriteEvent(String id) {
    final bool added = _favoriteEvents.add(id);
    if (!added) _favoriteEvents.remove(id);
    notifyListeners();
    return added;
  }

  bool eventPreAlert(String id) => _eventPreAlerts[id] ?? false;

  void setEventPreAlert(String id, bool value) {
    if (_eventPreAlerts[id] == value) return;
    _eventPreAlerts[id] = value;
    notifyListeners();
  }

  // ------------------------------------------------------- derived prayers
  /// Daily schedule for the selected city, with statuses resolved against the
  /// frozen demo clock.
  List<PrayerTime> get prayerTimes {
    final int offset = city.offsetMinutes;
    final int nowMinutes = DemoData.now.hour * 60 + DemoData.now.minute;

    int? nextIndex;
    for (int i = 0; i < DemoData.prayerTemplates.length; i++) {
      final PrayerTemplate t = DemoData.prayerTemplates[i];
      if (t.forbidden) continue;
      if (t.baseMinutes + offset > nowMinutes) {
        nextIndex = i;
        break;
      }
    }

    return <PrayerTime>[
      for (int i = 0; i < DemoData.prayerTemplates.length; i++)
        _resolve(DemoData.prayerTemplates[i], offset, nowMinutes, i == nextIndex),
    ];
  }

  PrayerTime _resolve(
    PrayerTemplate template,
    int offset,
    int nowMinutes,
    bool isNext,
  ) {
    final int minutes = template.baseMinutes + offset;
    final PrayerStatus status;
    if (template.forbidden) {
      status = PrayerStatus.forbidden;
    } else if (isNext) {
      status = PrayerStatus.next;
    } else if (minutes <= nowMinutes) {
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
      minutes: minutes,
      status: status,
      supportsAlert: template.supportsAlert,
    );
  }

  PrayerTime get nextPrayer => prayerTimes.firstWhere(
    (PrayerTime p) => p.isNext,
    orElse: () => prayerTimes.first,
  );

  PrayerTime prayerById(String id) =>
      prayerTimes.firstWhere((PrayerTime p) => p.id == id);

  /// Seconds left until the next adhan, measured from the frozen clock.
  int get remainingSeconds {
    final int nowSeconds =
        DemoData.now.hour * 3600 + DemoData.now.minute * 60 + DemoData.now.second;
    final int target = nextPrayer.minutes * 60;
    return (target - nowSeconds).clamp(0, 24 * 3600);
  }

  /// `01:24:36`
  String get countdown {
    final int total = remainingSeconds;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(total ~/ 3600)}:${two((total % 3600) ~/ 60)}:${two(total % 60)}';
  }

  double get countdownProgress =>
      (1 - (remainingSeconds / 60) / DemoData.countdownWindow).clamp(0.0, 1.0);

  // ------------------------------------------------------- derived weather
  WeatherData get weather => DemoData.weatherFor(city);

  // --------------------------------------------------------- derived dates
  HijriDate get hijriToday => HijriDate.fromGregorian(DemoData.today);

  String get hijriLabel => hijriToday.formatted;
  String get gregorianLabel => GregorianLabels.formatted(DemoData.today);

  /// `الرياض • توقيت أم القرى`
  String get prayerSourceLabel => '${city.name} • ${DemoData.timezoneName}';

  /// `توقيت الرياض`
  String get timezoneLabel => 'توقيت ${city.name}';

  /// Substitutes the placeholders inside a demo notification body.
  String notificationBody(AppNotification notification) => notification
      .bodyTemplate
      .replaceAll('{city}', city.name)
      .replaceAll('{time}', prayerById('dhuhr').timeWithPeriod)
      .replaceAll('{days}', '${DemoData.daysUntil(DemoData.featuredEvent.date)}');
}
