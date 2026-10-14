import 'package:flutter/material.dart';

import '../location/app_geo.dart';
import '../prayer/prayer_calc_method.dart';
import 'hijri_date.dart';
import 'models.dart';

/// Static demo content. Mirrors the reference screens — there is no backend,
/// no prayer/weather API and no GPS behind any of this yet.
class DemoData {
  const DemoData._();

  /// The app runs against a frozen clock so every screen agrees with the
  /// reference mockups.
  static final DateTime now = DateTime(2026, 9, 7, 10, 27, 24);

  static DateTime get today => DateTime(now.year, now.month, now.day);

  // ---------------------------------------------------------------- splash
  static const String splashLocation = 'المملكة العربية السعودية • الرياض';
  static const String hijriYear = '١٤٤٨';

  // ------------------------------------------------------------------ home
  static const String greetingSmall = 'مرحبًا بك';
  static const String greeting = 'تقويمك .. مواقيتك .. في مكان واحد';
  static const String prayerTimesHeader = 'مواقيت صلاة اليوم';

  static const String calendarName = 'تقويم أم القرى';
  static const String timezoneName = 'توقيت أم القرى';

  // -------------------------------------------------------------- prayers
  static const List<PrayerTemplate> prayerTemplates = <PrayerTemplate>[
    PrayerTemplate(
      id: 'fajr',
      name: 'الفجر',
      longName: 'صلاة الفجر',
      icon: Icons.dark_mode_outlined,
      baseMinutes: 4 * 60 + 32,
      passedNote: 'انقضت',
      upcomingNote: 'الأذان القادم',
    ),
    PrayerTemplate(
      id: 'sunrise',
      name: 'الشروق',
      longName: 'وقت الشروق',
      icon: Icons.wb_twilight,
      baseMinutes: 6 * 60 + 1,
      passedNote: 'وقت النهي عن الصلاة',
      upcomingNote: 'وقت النهي عن الصلاة',
      supportsAlert: false,
      forbidden: true,
    ),
    PrayerTemplate(
      id: 'dhuhr',
      name: 'الظهر',
      longName: 'صلاة الظهر',
      icon: Icons.wb_sunny_outlined,
      baseMinutes: 11 * 60 + 52,
      passedNote: 'انقضت',
      upcomingNote: 'الأذان القادم',
    ),
    PrayerTemplate(
      id: 'asr',
      name: 'العصر',
      longName: 'صلاة العصر',
      icon: Icons.cloud_outlined,
      baseMinutes: 15 * 60 + 22,
      passedNote: 'انقضت',
      upcomingNote: 'الأذان القادم',
    ),
    PrayerTemplate(
      id: 'maghrib',
      name: 'المغرب',
      longName: 'صلاة المغرب',
      icon: Icons.wb_twilight_outlined,
      baseMinutes: 18 * 60 + 9,
      passedNote: 'انقضت',
      upcomingNote: 'وقت الإفطار',
    ),
    PrayerTemplate(
      id: 'isha',
      name: 'العشاء',
      longName: 'صلاة العشاء',
      icon: Icons.nightlight_outlined,
      baseMinutes: 19 * 60 + 39,
      passedNote: 'انقضت',
      upcomingNote: 'يليها الشفع والوتر',
    ),
  ];

  /// Window (in minutes) used to turn the remaining time into a progress bar.
  static const int countdownWindow = 250;

  // --------------------------------------------------------------- cities
  static const List<CityData> cities = <CityData>[
    CityData(
      id: 'riyadh',
      name: 'الرياض',
      nameEn: 'Riyadh',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'المنطقة الوسطى',
      latitude: 24.7136,
      longitude: 46.6753,
      station: 'محطة مطار الملك خالد الدولي',
      temperatureDelta: 0,
      condition: 'غائم جزئيًا',
      humidity: 45,
      windSpeed: 12,
      windDirection: 'شمالية شرقية',
      cloudCover: 35,
      uvIndex: 6,
    ),
    CityData(
      id: 'makkah',
      name: 'مكة المكرمة',
      nameEn: 'Makkah',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة مكة المكرمة',
      latitude: 21.4225,
      longitude: 39.8262,
      station: 'محطة مكة المكرمة',
      temperatureDelta: 7,
      condition: 'صحو وحار',
      humidity: 28,
      windSpeed: 9,
      windDirection: 'غربية',
      cloudCover: 10,
      uvIndex: 8,
      holy: true,
    ),
    CityData(
      id: 'madinah',
      name: 'المدينة المنورة',
      nameEn: 'Madinah',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة المدينة المنورة',
      latitude: 24.4672,
      longitude: 39.6024,
      station: 'محطة مطار الأمير محمد بن عبدالعزيز',
      temperatureDelta: 3,
      condition: 'صحو ومستقر',
      humidity: 22,
      windSpeed: 14,
      windDirection: 'شمالية غربية',
      cloudCover: 8,
      uvIndex: 7,
      holy: true,
    ),
    CityData(
      id: 'jeddah',
      name: 'جدة',
      nameEn: 'Jeddah',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'المنطقة الغربية',
      latitude: 21.5433,
      longitude: 39.1728,
      station: 'محطة مطار الملك عبدالعزيز الدولي',
      temperatureDelta: 4,
      condition: 'رطب ومائل للحرارة',
      humidity: 68,
      windSpeed: 16,
      windDirection: 'غربية',
      cloudCover: 20,
      uvIndex: 8,
    ),
    CityData(
      id: 'dammam',
      name: 'الدمام',
      nameEn: 'Dammam',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'المنطقة الشرقية',
      latitude: 26.4207,
      longitude: 50.0888,
      station: 'محطة مطار الملك فهد الدولي',
      temperatureDelta: 2,
      condition: 'رطب وغائم جزئيًا',
      humidity: 62,
      windSpeed: 18,
      windDirection: 'شمالية',
      cloudCover: 40,
      uvIndex: 6,
    ),
    CityData(
      id: 'khobar',
      name: 'الخبر',
      nameEn: 'Khobar',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'المنطقة الشرقية',
      latitude: 26.2172,
      longitude: 50.1971,
      station: 'محطة الخبر الساحلية',
      temperatureDelta: 2,
      condition: 'رطب مع نسيم بحري',
      humidity: 65,
      windSpeed: 20,
      windDirection: 'شمالية شرقية',
      cloudCover: 35,
      uvIndex: 6,
    ),
    CityData(
      id: 'taif',
      name: 'الطائف',
      nameEn: 'Taif',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة مكة المكرمة',
      latitude: 21.2703,
      longitude: 40.4158,
      station: 'محطة مطار الطائف الدولي',
      temperatureDelta: -4,
      condition: 'معتدل وصحو',
      humidity: 38,
      windSpeed: 10,
      windDirection: 'غربية',
      cloudCover: 15,
      uvIndex: 7,
    ),
    CityData(
      id: 'abha',
      name: 'أبها',
      nameEn: 'Abha',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة عسير',
      latitude: 18.2164,
      longitude: 42.5053,
      station: 'محطة مطار أبها الإقليمي',
      temperatureDelta: -10,
      condition: 'معتدل مع ضباب خفيف',
      humidity: 72,
      windSpeed: 11,
      windDirection: 'جنوبية غربية',
      cloudCover: 65,
      uvIndex: 5,
    ),
    CityData(
      id: 'tabuk',
      name: 'تبوك',
      nameEn: 'Tabuk',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة تبوك',
      latitude: 28.3838,
      longitude: 36.5550,
      station: 'محطة مطار الأمير سلطان بن عبدالعزيز',
      temperatureDelta: -5,
      condition: 'صحو مع رياح خفيفة',
      humidity: 30,
      windSpeed: 15,
      windDirection: 'شمالية',
      cloudCover: 12,
      uvIndex: 7,
    ),
    CityData(
      id: 'buraydah',
      name: 'بريدة',
      nameEn: 'Buraydah',
      country: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      region: 'منطقة القصيم',
      latitude: 26.3260,
      longitude: 43.9750,
      station: 'محطة القصيم',
      temperatureDelta: -1,
      condition: 'صحو ودافئ',
      humidity: 28,
      windSpeed: 13,
      windDirection: 'شمالية',
      cloudCover: 10,
      uvIndex: 7,
    ),
  ];

  static CityData cityById(String id) =>
      cities.firstWhere((CityData c) => c.id == id, orElse: () => cities.first);

  static CityData get riyadh => cityById('riyadh');

  static CityData nearestCity(double latitude, double longitude) {
    CityData best = cities.first;
    double bestDistance = AppGeo.haversineKm(
      latitude,
      longitude,
      best.latitude,
      best.longitude,
    );
    for (final CityData city in cities.skip(1)) {
      final double distance = AppGeo.haversineKm(
        latitude,
        longitude,
        city.latitude,
        city.longitude,
      );
      if (distance < bestDistance) {
        best = city;
        bestDistance = distance;
      }
    }
    return best;
  }

  static CityData? matchCity({
    required double latitude,
    required double longitude,
    String? name,
  }) {
    if (name != null && name.trim().isNotEmpty) {
      final String needle = name.trim();
      for (final CityData city in cities) {
        if (city.name == needle ||
            needle.contains(city.name) ||
            city.name.contains(needle) ||
            (city.nameEn.isNotEmpty &&
                (city.nameEn.toLowerCase() == needle.toLowerCase() ||
                    needle.toLowerCase().contains(city.nameEn.toLowerCase()) ||
                    city.nameEn.toLowerCase().contains(needle.toLowerCase())))) {
          return city;
        }
      }
    }
    final CityData nearest = nearestCity(latitude, longitude);
    final double distance = AppGeo.haversineKm(
      latitude,
      longitude,
      nearest.latitude,
      nearest.longitude,
    );
    if (distance <= 35) {
      return nearest;
    }
    return null;
  }

  // -------------------------------------------------------------- weather
  static const int baseTemperature = 28;
  static const int baseHigh = 34;
  static const int baseLow = 22;
  static const int baseFeelsLike = 30;

  static const List<_ForecastTemplate> _forecastTemplates =
      <_ForecastTemplate>[
        _ForecastTemplate(
          'اليوم (الإثنين)',
          'مشمس وأجواء دافئة',
          34,
          22,
          Icons.wb_sunny_outlined,
          badge: 'الحالي',
          isToday: true,
        ),
        _ForecastTemplate(
          'الثلاثاء',
          'غائم جزئيًا',
          33,
          21,
          Icons.wb_cloudy_outlined,
        ),
        _ForecastTemplate(
          'الأربعاء',
          'صحو ومستقر',
          35,
          23,
          Icons.wb_sunny_outlined,
        ),
        _ForecastTemplate(
          'الخميس',
          'صحو مع رياح خفيفة',
          36,
          24,
          Icons.wb_sunny_outlined,
        ),
        _ForecastTemplate(
          'الجمعة',
          'مشمس وأجواء هادئة',
          35,
          23,
          Icons.wb_sunny_outlined,
          badge: 'يوم مبارك',
          badgeTone: BadgeTone.amber,
        ),
      ];

  static String uvLabel(int index) {
    if (index <= 2) return 'منخفض';
    if (index <= 5) return 'متوسط';
    if (index <= 7) return 'معتدل';
    if (index <= 10) return 'مرتفع';
    return 'شديد';
  }

  static String humidityNote(int humidity) {
    if (humidity < 30) return 'جافة نسبيًا';
    if (humidity <= 55) return 'مناسبة ومريحة';
    return 'مرتفعة وشعور بالرطوبة';
  }

  static WeatherData weatherFor(CityData city) {
    final int delta = city.temperatureDelta;
    return WeatherData(
      temperature: baseTemperature + delta,
      high: baseHigh + delta,
      low: baseLow + delta,
      feelsLike: baseFeelsLike + delta,
      condition: city.condition,
      humidity: city.humidity,
      windSpeed: city.windSpeed,
      windDirection: city.windDirection,
      cloudCover: city.cloudCover,
      uvIndex: city.uvIndex,
      uvLabel: uvLabel(city.uvIndex),
      station: city.station,
      outdoorNote: 'نسيم عليل مناسب للأنشطة الخارجية',
      forecast: <DailyForecast>[
        for (final _ForecastTemplate t in _forecastTemplates)
          DailyForecast(
            day: t.day,
            description: t.description,
            high: t.high + delta,
            low: t.low + delta,
            icon: t.icon,
            badge: t.badge,
            badgeTone: t.badgeTone,
            isToday: t.isToday,
          ),
      ],
    );
  }

  // --------------------------------------------------------------- events
  static final List<IslamicEvent> events = <IslamicEvent>[
    IslamicEvent(
      id: 'national-day',
      title: 'اليوم الوطني السعودي 96',
      titleEn: 'Saudi National Day 96',
      date: DateTime(2026, 9, 23),
      kind: EventKind.national,
      icon: Icons.flag_outlined,
      badge: 'مناسبة وطنية',
      badgeEn: 'National occasion',
      note: 'إجازة رسمية لجميع القطاعات',
      noteEn: 'Official holiday for all sectors',
      actionLabel: 'التفاصيل',
      actionLabelEn: 'Details',
      tagline: 'نحلم ونحقق • مجد وعز وسؤدد يعانق السماء',
      taglineEn: 'We dream and we achieve • Glory and pride reaching the sky',
      ownerBadge: 'المملكة العربية السعودية',
      ownerBadgeEn: 'Saudi Arabia',
      statusPills: <String>['مناسبة وطنية رسمية', 'إجازة رسمية'],
      statusPillsEn: <String>['Official national occasion', 'Official holiday'],
      description:
          'يوم توحيد المملكة العربية السعودية على يد الملك عبد العزيز بن '
          'عبد الرحمن آل سعود رحمه الله. يحتفي به الوطن في 23 سبتمبر من كل '
          'عام بمشاعر الفخر والاعتزاز.',
      descriptionEn:
          'The day the Kingdom of Saudi Arabia was unified by King Abdulaziz '
          'bin Abdulrahman Al Saud, may God have mercy on him.',
      highlight:
          'تقام فيه الفعاليات الوطنية، العروض الجوية، والبرامج الثقافية في '
          'مختلف مناطق المملكة.',
      highlightEn:
          'National events, air shows, and cultural programs are held across '
          'the Kingdom.',
    ),
    IslamicEvent(
      id: 'mawlid',
      title: 'المولد النبوي الشريف',
      titleEn: "The Prophet's Birthday",
      date: DateTime(2026, 9, 4),
      kind: EventKind.islamic,
      icon: Icons.mosque_outlined,
      badge: 'مناسبة إسلامية',
      badgeEn: 'Islamic occasion',
      note: 'سيرة عطرة ومجالس ذكر',
      noteEn: 'Noble biography and gatherings of remembrance',
      actionLabel: 'الأدعية والأذكار',
      actionLabelEn: 'Supplications and remembrance',
      tagline: 'ذكرى مولد خير الأنام صلى الله عليه وسلم',
      taglineEn: 'The birth of the best of creation, peace be upon him',
      ownerBadge: 'التقويم الهجري',
      ownerBadgeEn: 'Hijri calendar',
      statusPills: <String>['مناسبة إسلامية', 'يوم عمل رسمي'],
      statusPillsEn: <String>['Islamic occasion', 'Working day'],
      description:
          'ذكرى مولد النبي محمد صلى الله عليه وسلم في الثاني عشر من ربيع '
          'الأول. يستحضر فيها المسلمون سيرته العطرة وأخلاقه الكريمة.',
      descriptionEn:
          'The birthday of Prophet Muhammad, peace be upon him, on 12 Rabi\' '
          'al-Awwal. It is not a general public holiday in the Kingdom.',
      highlight: 'تُعقد فيها مجالس الذكر وقراءة السيرة النبوية في المساجد.',
      highlightEn:
          'Gatherings of remembrance and readings of the Prophetic biography '
          'are held in mosques.',
    ),
  ];

  static IslamicEvent eventById(String id) =>
      events.firstWhere((IslamicEvent e) => e.id == id);

  static IslamicEvent? eventOn(DateTime date) {
    for (final IslamicEvent event in events) {
      if (event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day) {
        return event;
      }
    }
    return null;
  }

  /// `اليوم الوطني السعودي 96` is the card promoted on the home screen.
  static IslamicEvent get featuredEvent => events.first;

  static int daysUntil(DateTime date, [DateTime? from]) {
    final DateTime origin = from ?? today;
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(origin.year, origin.month, origin.day))
        .inDays;
  }

  // -------------------------------------------------------- notifications
  static const List<AppNotification> notifications = <AppNotification>[
    AppNotification(
      id: 'dhuhr-adhan',
      title: 'حان وقت صلاة الظهر',
      bodyTemplate: '{time} — موعد الأذان حسب توقيت أم القرى بـ{city}',
      timeLabel: 'منذ 10 دقائق',
      icon: Icons.notifications_active_outlined,
      tone: NotificationTone.mint,
      group: 'اليوم',
    ),
    AppNotification(
      id: 'national-day-soon',
      title: 'اقتراب اليوم الوطني السعودي...',
      bodyTemplate:
          'متبقي {days} يومًا على موعد الإجازة الرسمية للقطاعين العام والخاص',
      timeLabel: 'منذ 3 ساعات',
      icon: Icons.flag_outlined,
      tone: NotificationTone.amber,
      group: 'اليوم',
    ),
    AppNotification(
      id: 'times-updated',
      title: 'تم تحديث مواقيت الصلاة تلقائيًا',
      bodyTemplate: 'تم ضبط المواقيت بحسب إحداثيات موقعك الحالي في {city}',
      timeLabel: 'أمس',
      icon: Icons.location_on_outlined,
      tone: NotificationTone.neutral,
      group: 'أمس',
    ),
  ];

  // ------------------------------------------------------------- settings
  static const List<String> calculationMethods = PrayerCalcMethod.labels;

  static const List<String> adhanSounds = <String>[
    'أذان الحرم المكي',
    'أذان المسجد النبوي',
  ];

  static const List<String> languages = <String>['العربية', 'English'];

  static const List<int> preAlertOptions = <int>[0, 5, 10, 15];

  static String preAlertLabel(int minutes) => switch (minutes) {
    0 => 'عند دخول وقت الصلاة تمامًا',
    >= 11 => 'قبل $minutes دقيقة',
    _ => 'قبل $minutes دقائق',
  };

  static const String appVersion = 'تقويم ومواقيت — الإصدار 1.0.0';
  static const String appTagline = 'تقويمك .. مواقيتك .. في مكان واحد';

  // ------------------------------------------------------------ utilities
  static String hijriLabel(DateTime date) =>
      HijriDate.fromGregorian(date).formatted;

  static String gregorianLabel(DateTime date) =>
      GregorianLabels.formatted(date);
}

class _ForecastTemplate {
  const _ForecastTemplate(
    this.day,
    this.description,
    this.high,
    this.low,
    this.icon, {
    this.badge,
    this.badgeTone = BadgeTone.mint,
    this.isToday = false,
  });

  final String day;
  final String description;
  final int high;
  final int low;
  final IconData icon;
  final String? badge;
  final BadgeTone badgeTone;
  final bool isToday;
}
