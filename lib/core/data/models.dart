import 'package:flutter/material.dart';

import '../location/app_geo.dart';
import '../weather/weather_condition_mapper.dart';

/// Where a prayer sits relative to the (fixed) demo clock.
enum PrayerStatus { passed, forbidden, next, upcoming }

/// One entry of the daily schedule, already resolved for a given city.
class PrayerTime {
  const PrayerTime({
    required this.id,
    required this.name,
    required this.longName,
    required this.note,
    required this.icon,
    required this.minutes,
    required this.status,
    required this.supportsAlert,
    required this.occursAt,
  });

  final String id;

  /// `الفجر`
  final String name;

  /// `صلاة الفجر`
  final String longName;

  /// Subtitle shown on the prayer-times list (`انقضت`, `وقت الإفطار`, ...).
  final String note;
  final IconData icon;

  /// Minutes since midnight in the city timezone.
  final int minutes;
  final PrayerStatus status;

  /// Instant of this adhan in the city timezone.
  final DateTime occursAt;

  /// الشروق is not a prayer, so it never carries an adhan alert.
  final bool supportsAlert;

  bool get isNext => status == PrayerStatus.next;

  /// `4:32`
  String get time {
    final int hour24 = minutes ~/ 60;
    final int hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final String minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// `ص` / `م`
  String get period => minutes < 12 * 60 ? 'ص' : 'م';

  /// `4:32 ص`
  String get timeWithPeriod => '$time $period';

  /// `04:32 ص` — the zero padded variant used inside sentences.
  String get paddedTimeWithPeriod {
    final int hour24 = minutes ~/ 60;
    final int hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final String minute = (minutes % 60).toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}

/// Template for a prayer before a city offset is applied.
class PrayerTemplate {
  const PrayerTemplate({
    required this.id,
    required this.name,
    required this.longName,
    required this.icon,
    required this.baseMinutes,
    required this.passedNote,
    required this.upcomingNote,
    this.supportsAlert = true,
    this.forbidden = false,
  });

  final String id;
  final String name;
  final String longName;
  final IconData icon;
  final int baseMinutes;
  final String passedNote;
  final String upcomingNote;
  final bool supportsAlert;
  final bool forbidden;
}

class DailyForecast {
  const DailyForecast({
    required this.day,
    required this.description,
    required this.high,
    required this.low,
    required this.icon,
    this.badge,
    this.badgeTone = BadgeTone.mint,
    this.isToday = false,
    this.date,
    this.weatherCode,
  });

  final String day;
  final String description;
  final int high;
  final int low;
  final IconData icon;
  final String? badge;
  final BadgeTone badgeTone;
  final bool isToday;
  final DateTime? date;
  final int? weatherCode;

  Map<String, Object?> toJson() => <String, Object?>{
    'day': day,
    'description': description,
    'high': high,
    'low': low,
    'badge': badge,
    'badgeTone': badgeTone.name,
    'isToday': isToday,
    'date': date?.toIso8601String(),
    'weatherCode': weatherCode,
  };

  IconData get displayIcon =>
      WeatherConditionMapper.iconFor(weatherCode ?? 2, isDay: true);

  static DailyForecast fromJson(Map<String, Object?> json) {
    final int? code = (json['weatherCode'] as num?)?.toInt();
    return DailyForecast(
      day: json['day'] as String? ?? '',
      description: json['description'] as String? ?? '',
      high: (json['high'] as num?)?.round() ?? 0,
      low: (json['low'] as num?)?.round() ?? 0,
      icon: Icons.wb_cloudy_outlined,
      badge: json['badge'] as String?,
      badgeTone: BadgeTone.values.firstWhere(
        (BadgeTone tone) => tone.name == json['badgeTone'],
        orElse: () => BadgeTone.mint,
      ),
      isToday: json['isToday'] == true,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      weatherCode: code,
    );
  }
}

enum BadgeTone { mint, amber, dark }

class WeatherMetric {
  const WeatherMetric({
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    required this.progress,
    required this.tone,
    this.valueAccent,
    this.unit,
  });

  final String label;
  final String value;

  /// Rendered in green right after [value] (`6` + `معتدل`).
  final String? valueAccent;

  /// Small grey suffix (`كم/س`).
  final String? unit;
  final String note;
  final IconData icon;
  final double progress;
  final MetricTone tone;
}

enum MetricTone { green, amber, orange }

class WeatherData {
  const WeatherData({
    required this.temperature,
    required this.high,
    required this.low,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.cloudCover,
    required this.uvIndex,
    required this.uvLabel,
    required this.station,
    required this.outdoorNote,
    required this.forecast,
    this.weatherCode = 0,
    this.isDay = true,
    this.fetchedAt,
    this.badge = 'أجواء مستقرة',
    this.isFromCache = false,
    this.isUnavailable = false,
  });

  final int temperature;
  final int high;
  final int low;
  final int feelsLike;
  final String condition;
  final int humidity;
  final int windSpeed;
  final String windDirection;
  final int cloudCover;
  final int uvIndex;
  final String uvLabel;
  final String station;
  final String outdoorNote;
  final List<DailyForecast> forecast;
  final int weatherCode;
  final bool isDay;
  final DateTime? fetchedAt;
  final String badge;
  final bool isFromCache;
  final bool isUnavailable;

  WeatherData copyWith({
    int? temperature,
    int? high,
    int? low,
    int? feelsLike,
    String? condition,
    int? humidity,
    int? windSpeed,
    String? windDirection,
    int? cloudCover,
    int? uvIndex,
    String? uvLabel,
    String? station,
    String? outdoorNote,
    List<DailyForecast>? forecast,
    int? weatherCode,
    bool? isDay,
    DateTime? fetchedAt,
    String? badge,
    bool? isFromCache,
    bool? isUnavailable,
  }) {
    return WeatherData(
      temperature: temperature ?? this.temperature,
      high: high ?? this.high,
      low: low ?? this.low,
      feelsLike: feelsLike ?? this.feelsLike,
      condition: condition ?? this.condition,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      cloudCover: cloudCover ?? this.cloudCover,
      uvIndex: uvIndex ?? this.uvIndex,
      uvLabel: uvLabel ?? this.uvLabel,
      station: station ?? this.station,
      outdoorNote: outdoorNote ?? this.outdoorNote,
      forecast: forecast ?? this.forecast,
      weatherCode: weatherCode ?? this.weatherCode,
      isDay: isDay ?? this.isDay,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      badge: badge ?? this.badge,
      isFromCache: isFromCache ?? this.isFromCache,
      isUnavailable: isUnavailable ?? this.isUnavailable,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'temperature': temperature,
    'high': high,
    'low': low,
    'feelsLike': feelsLike,
    'condition': condition,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'windDirection': windDirection,
    'cloudCover': cloudCover,
    'uvIndex': uvIndex,
    'uvLabel': uvLabel,
    'station': station,
    'outdoorNote': outdoorNote,
    'forecast': forecast.map((DailyForecast day) => day.toJson()).toList(),
    'weatherCode': weatherCode,
    'isDay': isDay,
    'fetchedAt': fetchedAt?.toIso8601String(),
    'badge': badge,
  };

  static WeatherData fromJson(Map<String, Object?> json) {
    final Object? forecastRaw = json['forecast'];
    return WeatherData(
      temperature: (json['temperature'] as num?)?.round() ?? 0,
      high: (json['high'] as num?)?.round() ?? 0,
      low: (json['low'] as num?)?.round() ?? 0,
      feelsLike: (json['feelsLike'] as num?)?.round() ?? 0,
      condition: json['condition'] as String? ?? '',
      humidity: (json['humidity'] as num?)?.round() ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.round() ?? 0,
      windDirection: json['windDirection'] as String? ?? '',
      cloudCover: (json['cloudCover'] as num?)?.round() ?? 0,
      uvIndex: (json['uvIndex'] as num?)?.round() ?? 0,
      uvLabel: json['uvLabel'] as String? ?? '',
      station: json['station'] as String? ?? '',
      outdoorNote: json['outdoorNote'] as String? ?? '',
      forecast: forecastRaw is List
          ? forecastRaw
                .whereType<Map>()
                .map(
                  (Map item) => DailyForecast.fromJson(
                    item.map(
                      (Object? key, Object? value) =>
                          MapEntry<String, Object?>(key.toString(), value),
                    ),
                  ),
                )
                .toList(growable: false)
          : const <DailyForecast>[],
      weatherCode: (json['weatherCode'] as num?)?.toInt() ?? 0,
      isDay: json['isDay'] != false,
      fetchedAt: DateTime.tryParse(json['fetchedAt'] as String? ?? ''),
      badge: json['badge'] as String? ?? 'أجواء مستقرة',
      isFromCache: true,
    );
  }
}

enum EventKind { national, islamic }

class IslamicEvent {
  const IslamicEvent({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.date,
    required this.kind,
    required this.icon,
    required this.badge,
    required this.badgeEn,
    required this.note,
    required this.noteEn,
    required this.actionLabel,
    required this.actionLabelEn,
    required this.tagline,
    required this.taglineEn,
    required this.ownerBadge,
    required this.ownerBadgeEn,
    required this.statusPills,
    required this.statusPillsEn,
    required this.description,
    required this.descriptionEn,
    required this.highlight,
    required this.highlightEn,
    this.officialHoliday = false,
    this.holidayVerified = false,
    this.dateSource = 'تقويم أم القرى / مناسبات ثابتة',
    this.dateSourceEn = 'Umm Al-Qura / fixed occasions',
  });

  final String id;
  final String title;
  final String titleEn;
  final DateTime date;
  final EventKind kind;
  final IconData icon;

  /// `مناسبة وطنية` / `مناسبة إسلامية`
  final String badge;
  final String badgeEn;

  /// Footer line of the calendar card.
  final String note;
  final String noteEn;

  /// Footer action of the calendar card.
  final String actionLabel;
  final String actionLabelEn;

  /// Secondary line inside the hero of the details screen.
  final String tagline;
  final String taglineEn;

  /// Gold pill at the top of the hero.
  final String ownerBadge;
  final String ownerBadgeEn;

  /// The two pills under the hero title.
  final List<String> statusPills;
  final List<String> statusPillsEn;
  final String description;
  final String descriptionEn;

  /// Grey callout inside the "عن المناسبة" card.
  final String highlight;
  final String highlightEn;
  final bool officialHoliday;
  final bool holidayVerified;
  final String dateSource;
  final String dateSourceEn;

  bool _english(String languageCode) =>
      languageCode.toLowerCase().startsWith('en');

  String titleFor(String languageCode) =>
      _english(languageCode) ? titleEn : title;
  String badgeFor(String languageCode) =>
      _english(languageCode) ? badgeEn : badge;
  String noteFor(String languageCode) =>
      _english(languageCode) ? noteEn : note;
  String actionLabelFor(String languageCode) =>
      _english(languageCode) ? actionLabelEn : actionLabel;
  String taglineFor(String languageCode) =>
      _english(languageCode) ? taglineEn : tagline;
  String ownerBadgeFor(String languageCode) =>
      _english(languageCode) ? ownerBadgeEn : ownerBadge;
  String descriptionFor(String languageCode) =>
      _english(languageCode) ? descriptionEn : description;
  String highlightFor(String languageCode) =>
      _english(languageCode) ? highlightEn : highlight;
  String dateSourceFor(String languageCode) =>
      _english(languageCode) ? dateSourceEn : dateSource;
  List<String> statusPillsFor(String languageCode) =>
      _english(languageCode) ? statusPillsEn : statusPills;
}

enum NotificationTone { mint, amber, neutral }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.bodyTemplate,
    required this.timeLabel,
    required this.icon,
    required this.tone,
    required this.group,
    this.createdAt,
    this.targetRoute,
    this.targetId,
  });

  final String id;
  final String title;

  /// `{city}` and `{time}` are substituted from the shared state.
  final String bodyTemplate;
  final String timeLabel;
  final IconData icon;
  final NotificationTone tone;

  /// `اليوم` / `أمس`
  final String group;
  final DateTime? createdAt;
  final String? targetRoute;
  final String? targetId;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'bodyTemplate': bodyTemplate,
    'timeLabel': timeLabel,
    'tone': tone.name,
    'group': group,
    'createdAt': createdAt?.toIso8601String(),
    'targetRoute': targetRoute,
    'targetId': targetId,
    'iconKey': tone == NotificationTone.amber
        ? 'flag'
        : (tone == NotificationTone.neutral ? 'location' : 'bell'),
  };

  static AppNotification fromJson(Map<String, Object?> json) {
    final String iconKey = json['iconKey'] as String? ?? 'bell';
    return AppNotification(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bodyTemplate: json['bodyTemplate'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      icon: iconKey == 'flag'
          ? Icons.flag_outlined
          : iconKey == 'location'
          ? Icons.location_on_outlined
          : Icons.notifications_active_outlined,
      tone: NotificationTone.values.firstWhere(
        (NotificationTone value) => value.name == json['tone'],
        orElse: () => NotificationTone.neutral,
      ),
      group: json['group'] as String? ?? 'اليوم',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      targetRoute: json['targetRoute'] as String?,
      targetId: json['targetId'] as String?,
    );
  }
}

class CityData {
  const CityData({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
    this.timezoneId = 'Asia/Riyadh',
    required this.station,
    required this.temperatureDelta,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.cloudCover,
    required this.uvIndex,
    this.nameEn = '',
    this.countryEn = '',
    this.holy = false,
  });

  final String id;
  final String name;
  final String nameEn;
  final String country;
  final String countryEn;
  final String region;
  final double latitude;
  final double longitude;
  final String timezoneId;
  final String station;
  final int temperatureDelta;
  final String condition;
  final int humidity;
  final int windSpeed;
  final String windDirection;
  final int cloudCover;
  final int uvIndex;
  final bool holy;

  /// `الرياض، المملكة العربية السعودية`
  String get fullName => '$name، $country';

  int get qiblaAngle => AppGeo.qiblaAngle(latitude, longitude);

  String get qiblaDirection => AppGeo.qiblaDirection(latitude, longitude);

  int get distanceToMakkah => AppGeo.distanceToMakkah(latitude, longitude);

  /// `244° جنوب غرب`
  String get qiblaLabel => AppGeo.qiblaLabel(latitude, longitude);

  CityData copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? country,
    String? countryEn,
    String? region,
    double? latitude,
    double? longitude,
    String? timezoneId,
    String? station,
    int? temperatureDelta,
    String? condition,
    int? humidity,
    int? windSpeed,
    String? windDirection,
    int? cloudCover,
    int? uvIndex,
    bool? holy,
  }) {
    return CityData(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      country: country ?? this.country,
      countryEn: countryEn ?? this.countryEn,
      region: region ?? this.region,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezoneId: timezoneId ?? this.timezoneId,
      station: station ?? this.station,
      temperatureDelta: temperatureDelta ?? this.temperatureDelta,
      condition: condition ?? this.condition,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      cloudCover: cloudCover ?? this.cloudCover,
      uvIndex: uvIndex ?? this.uvIndex,
      holy: holy ?? this.holy,
    );
  }
}
