import '../../l10n/app_localizations.dart';
import '../adhan/adhan_audio_catalog.dart';
import '../data/hijri_date.dart';
import '../data/models.dart';
import '../location/location_failure.dart';
import '../prayer/prayer_calc_method.dart';
import '../qibla/compass_sensor.dart';
import '../qibla/qibla_calculation_service.dart';
import '../weather/weather_snapshot.dart';
import 'app_language.dart';

/// Display-string lookups keyed by IDs and weather codes.
class AppCopy {
  const AppCopy(this.l10n);

  final AppLocalizations l10n;

  factory AppCopy.forCode(String languageCode) =>
      AppCopy(AppLanguage.l10nOf(languageCode));

  String prayerName(String id) => switch (id) {
    'fajr' => l10n.prayerFajr,
    'sunrise' => l10n.prayerSunrise,
    'dhuhr' => l10n.prayerDhuhr,
    'asr' => l10n.prayerAsr,
    'maghrib' => l10n.prayerMaghrib,
    'isha' => l10n.prayerIsha,
    _ => id,
  };

  String prayerLongName(String id) => switch (id) {
    'fajr' => l10n.prayerFajrLong,
    'sunrise' => l10n.prayerSunriseLong,
    'dhuhr' => l10n.prayerDhuhrLong,
    'asr' => l10n.prayerAsrLong,
    'maghrib' => l10n.prayerMaghribLong,
    'isha' => l10n.prayerIshaLong,
    _ => id,
  };

  String prayerNote(PrayerTime prayer) => switch (prayer.status) {
    PrayerStatus.next => l10n.nextPrayer,
    PrayerStatus.passed => l10n.passed,
    PrayerStatus.forbidden => l10n.sunriseForbidden,
    PrayerStatus.upcoming => switch (prayer.id) {
      'maghrib' => l10n.iftarTime,
      'isha' => l10n.ishaFollows,
      _ => l10n.nextAdhan,
    },
  };

  String period(int minutes) =>
      minutes < 12 * 60 ? l10n.periodAm : l10n.periodPm;

  String timeWithPeriod(PrayerTime prayer) =>
      '${prayer.time} ${period(prayer.minutes)}';

  String cityName(CityData city) => switch (city.id) {
    'riyadh' => l10n.cityRiyadh,
    'makkah' => l10n.cityMakkah,
    'madinah' => l10n.cityMadinah,
    'jeddah' => l10n.cityJeddah,
    'dammam' => l10n.cityDammam,
    'khobar' => l10n.cityKhobar,
    'taif' => l10n.cityTaif,
    'abha' => l10n.cityAbha,
    'tabuk' => l10n.cityTabuk,
    'buraydah' => l10n.cityBuraydah,
    _ => city.name,
  };

  String countryName(CityData city) {
    if (city.id == 'custom') {
      final String country = city.country.toLowerCase();
      if (country.contains('سعود') || country.contains('saudi')) {
        return l10n.countrySaudi;
      }
      return city.country;
    }
    return l10n.countrySaudi;
  }

  String cityFullName(CityData city) =>
      l10n.cityFullName(cityName(city), countryName(city));

  String cityNameFromId(String? catalogId, String fallback) {
    return switch (catalogId) {
      'riyadh' => l10n.cityRiyadh,
      'makkah' => l10n.cityMakkah,
      'madinah' => l10n.cityMadinah,
      'jeddah' => l10n.cityJeddah,
      'dammam' => l10n.cityDammam,
      'khobar' => l10n.cityKhobar,
      'taif' => l10n.cityTaif,
      'abha' => l10n.cityAbha,
      'tabuk' => l10n.cityTabuk,
      'buraydah' => l10n.cityBuraydah,
      _ => fallback,
    };
  }

  String calcMethod(PrayerCalcMethod method) => switch (method) {
    PrayerCalcMethod.ummAlQura => l10n.calcUmmAlQura,
    PrayerCalcMethod.muslimWorldLeague => l10n.calcMwl,
    PrayerCalcMethod.egyptian => l10n.calcEgyptian,
    PrayerCalcMethod.karachi => l10n.calcKarachi,
  };

  List<String> get calcMethodLabels => <String>[
    for (final PrayerCalcMethod method in PrayerCalcMethod.values)
      calcMethod(method),
  ];

  String mosque(AdhanMosque mosque) => switch (mosque) {
    AdhanMosque.makkah => l10n.mosqueMakkah,
    AdhanMosque.madinah => l10n.mosqueMadinah,
  };

  String mosqueShort(AdhanMosque mosque) => switch (mosque) {
    AdhanMosque.makkah => l10n.mosqueMakkahShort,
    AdhanMosque.madinah => l10n.mosqueMadinahShort,
  };

  String adhanType(AdhanAudioType type) => switch (type) {
    AdhanAudioType.fajr => l10n.adhanFajr,
    AdhanAudioType.regular => l10n.adhanRegular,
  };

  String weekday(int dartWeekday) => switch (dartWeekday) {
    DateTime.sunday => l10n.weekdaySun,
    DateTime.monday => l10n.weekdayMon,
    DateTime.tuesday => l10n.weekdayTue,
    DateTime.wednesday => l10n.weekdayWed,
    DateTime.thursday => l10n.weekdayThu,
    DateTime.friday => l10n.weekdayFri,
    DateTime.saturday => l10n.weekdaySat,
    _ => '',
  };

  /// Index 0 = Sunday, matching the calendar grid.
  List<String> get weekdaysSundayFirst => <String>[
    l10n.weekdaySun,
    l10n.weekdayMon,
    l10n.weekdayTue,
    l10n.weekdayWed,
    l10n.weekdayThu,
    l10n.weekdayFri,
    l10n.weekdaySat,
  ];

  String gregorianMonth(int month) => switch (month) {
    1 => l10n.monthJan,
    2 => l10n.monthFeb,
    3 => l10n.monthMar,
    4 => l10n.monthApr,
    5 => l10n.monthMay,
    6 => l10n.monthJun,
    7 => l10n.monthJul,
    8 => l10n.monthAug,
    9 => l10n.monthSep,
    10 => l10n.monthOct,
    11 => l10n.monthNov,
    _ => l10n.monthDec,
  };

  String hijriMonth(int month) => switch (month) {
    1 => l10n.hijriMuharram,
    2 => l10n.hijriSafar,
    3 => l10n.hijriRabi1,
    4 => l10n.hijriRabi2,
    5 => l10n.hijriJumada1,
    6 => l10n.hijriJumada2,
    7 => l10n.hijriRajab,
    8 => l10n.hijriShaban,
    9 => l10n.hijriRamadan,
    10 => l10n.hijriShawwal,
    11 => l10n.hijriDhulQadah,
    _ => l10n.hijriDhulHijjah,
  };

  String hijriDate(HijriDate date) =>
      l10n.hijriDate(date.day, hijriMonth(date.month), date.year);

  String hijriMonthYear(HijriDate date) =>
      l10n.hijriMonthYear(hijriMonth(date.month), date.year);

  String gregorianDate(DateTime date) =>
      l10n.gregorianDate(date.day, gregorianMonth(date.month), date.year);

  String gregorianMonthYear(DateTime date) =>
      l10n.gregorianMonthYear(gregorianMonth(date.month), date.year);

  String weekdayDate(DateTime date) =>
      l10n.weekdayCommaDate(weekday(date.weekday), gregorianDate(date));

  String forecastDay(DailyForecast day) {
    final DateTime? date = day.date;
    if (date == null) {
      return day.day;
    }
    if (day.isToday) {
      return l10n.forecastTodayWeekday(weekday(date.weekday));
    }
    return weekday(date.weekday);
  }

  String weatherCondition(int code, {required bool isDay}) {
    return switch (code) {
      0 => isDay ? l10n.weatherSunny : l10n.weatherClearNight,
      1 => isDay ? l10n.weatherFair : l10n.weatherPartlyCloudyNight,
      2 => l10n.weatherPartlyCloudy,
      3 => l10n.weatherCloudy,
      45 || 48 => l10n.weatherFog,
      51 || 53 || 55 || 56 || 57 => l10n.weatherDrizzle,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => l10n.weatherRain,
      71 || 73 || 75 || 77 || 85 || 86 => l10n.weatherSnow,
      95 || 96 || 99 => l10n.weatherThunder,
      _ => l10n.weatherPartlyCloudy,
    };
  }

  String weatherNote(int code) {
    return switch (code) {
      0 => l10n.noteClear,
      1 => l10n.noteFair,
      2 => l10n.noteBreeze,
      3 => l10n.noteOvercast,
      45 || 48 => l10n.noteFog,
      51 || 53 || 55 || 56 || 57 => l10n.noteDrizzle,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => l10n.noteRain,
      71 || 73 || 75 || 77 || 85 || 86 => l10n.noteSnow,
      95 || 96 || 99 => l10n.noteThunder,
      _ => l10n.noteBreeze,
    };
  }

  String weatherBadge(int code) {
    return switch (code) {
      0 || 1 || 2 => l10n.badgeStable,
      3 => l10n.badgeCloudy,
      45 || 48 => l10n.badgeFog,
      51 || 53 || 55 || 56 || 57 => l10n.badgeDrizzle,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => l10n.badgeRain,
      71 || 73 || 75 || 77 || 85 || 86 => l10n.badgeSnow,
      95 || 96 || 99 => l10n.badgeStorm,
      _ => l10n.badgeStable,
    };
  }

  String windDirection(int degrees) {
    final int index = (((degrees % 360) + 360) % 360 + 22) ~/ 45 % 8;
    return switch (index) {
      0 => l10n.dirN,
      1 => l10n.dirNE,
      2 => l10n.dirE,
      3 => l10n.dirSE,
      4 => l10n.dirS,
      5 => l10n.dirSW,
      6 => l10n.dirW,
      _ => l10n.dirNW,
    };
  }

  String windDirectionFromLabel(String stored) {
    return switch (stored) {
      'شمالية' => l10n.dirN,
      'شمالية شرقية' => l10n.dirNE,
      'شرقية' => l10n.dirE,
      'جنوبية شرقية' => l10n.dirSE,
      'جنوبية' => l10n.dirS,
      'جنوبية غربية' => l10n.dirSW,
      'غربية' => l10n.dirW,
      'شمالية غربية' => l10n.dirNW,
      _ => stored,
    };
  }

  String uvLabel(int index) {
    if (index <= 2) return l10n.uvLow;
    if (index <= 5) return l10n.uvModerate;
    if (index <= 7) return l10n.uvHigh;
    if (index <= 10) return l10n.uvVeryHigh;
    return l10n.uvExtreme;
  }

  String humidityNote(int humidity) {
    if (humidity < 30) return l10n.humidityDry;
    if (humidity <= 55) return l10n.humidityComfort;
    return l10n.humidityHigh;
  }

  String forecastBadge(DailyForecast day) {
    if (day.isToday) {
      return l10n.current;
    }
    final DateTime? date = day.date;
    if (date != null && date.weekday == DateTime.friday) {
      return l10n.blessedDay;
    }
    return day.badge ?? '';
  }

  String locationFailure(LocationFailure failure) => switch (failure.kind) {
    LocationFailureKind.serviceDisabled => l10n.locServiceDisabled,
    LocationFailureKind.denied => l10n.locDenied,
    LocationFailureKind.deniedForever => l10n.locDeniedForever,
    LocationFailureKind.timeout => l10n.locTimeout,
    LocationFailureKind.unavailable => l10n.locUnavailable,
    LocationFailureKind.geocodingFailed => l10n.locGeocodingFailed,
  };

  String weatherFailure(WeatherFailure failure) => switch (failure.kind) {
    WeatherFailureKind.offline => l10n.weatherOffline,
    WeatherFailureKind.timeout => l10n.weatherTimeout,
    WeatherFailureKind.parse => l10n.weatherParse,
    WeatherFailureKind.unavailable => l10n.weatherUnavailable,
  };

  String compassAccuracy(CompassAccuracy accuracy) => switch (accuracy) {
    CompassAccuracy.unavailable => l10n.compassUnavailableShort,
    CompassAccuracy.uncalibrated => l10n.compassNeedsCalShort,
    CompassAccuracy.low => l10n.compassLow,
    CompassAccuracy.medium => l10n.compassMedium,
    CompassAccuracy.high => l10n.compassHigh,
    CompassAccuracy.unknown => l10n.compassUnavailableShort,
  };

  String? compassMessage(CompassAccuracy accuracy) => switch (accuracy) {
    CompassAccuracy.unavailable => l10n.compassUnavailable,
    CompassAccuracy.uncalibrated || CompassAccuracy.low =>
      l10n.compassNeedsCalibration,
    CompassAccuracy.unknown => l10n.compassAccuracyUnknown,
    CompassAccuracy.medium || CompassAccuracy.high => null,
  };

  String qiblaDirection(double bearing) {
    final int index =
        ((QiblaCalculationService.normalize(bearing) + 22.5) % 360 / 45)
            .floor();
    return switch (index) {
      0 => l10n.qiblaDirN,
      1 => l10n.qiblaDirNE,
      2 => l10n.qiblaDirE,
      3 => l10n.qiblaDirSE,
      4 => l10n.qiblaDirS,
      5 => l10n.qiblaDirSW,
      6 => l10n.qiblaDirW,
      _ => l10n.qiblaDirNW,
    };
  }

  String qiblaLabel(double bearing, {required bool atKaaba}) {
    if (atKaaba) {
      return l10n.qiblaKaaba;
    }
    return '${bearing.round()}° ${qiblaDirection(bearing)}';
  }

  String remainingDays(int days) {
    if (days <= 0) {
      return l10n.eventToday;
    }
    return l10n.remainingDays(days);
  }

  String preAlertLabel(int minutes) {
    if (minutes <= 0) {
      return l10n.preAlertExact;
    }
    return l10n.preAlertMinutes(minutes);
  }

  String get _lang => AppLanguage.normalize(l10n.localeName);

  String eventTitle(IslamicEvent event) => event.titleFor(_lang);
  String eventBadge(IslamicEvent event) => event.badgeFor(_lang);
  String eventNote(IslamicEvent event) => event.noteFor(_lang);
  String eventTagline(IslamicEvent event) => event.taglineFor(_lang);
  String eventOwner(IslamicEvent event) => event.ownerBadgeFor(_lang);
  String eventDescription(IslamicEvent event) =>
      event.descriptionFor(_lang);
  String eventHighlight(IslamicEvent event) => event.highlightFor(_lang);
  String eventAction(IslamicEvent event) => event.actionLabelFor(_lang);
  List<String> eventPills(IslamicEvent event) => event.statusPillsFor(_lang);
  String eventDateSource(IslamicEvent event) => event.dateSourceFor(_lang);
}
