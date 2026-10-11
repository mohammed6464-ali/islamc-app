import 'package:flutter/material.dart';

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
  });

  final String id;

  /// `الفجر`
  final String name;

  /// `صلاة الفجر`
  final String longName;

  /// Subtitle shown on the prayer-times list (`انقضت`, `وقت الإفطار`, ...).
  final String note;
  final IconData icon;

  /// Minutes since midnight.
  final int minutes;
  final PrayerStatus status;

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
}

enum EventKind { national, islamic }

class IslamicEvent {
  const IslamicEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.kind,
    required this.icon,
    required this.badge,
    required this.note,
    required this.actionLabel,
    required this.tagline,
    required this.ownerBadge,
    required this.statusPills,
    required this.description,
    required this.highlight,
  });

  final String id;
  final String title;
  final DateTime date;
  final EventKind kind;
  final IconData icon;

  /// `مناسبة وطنية` / `مناسبة إسلامية`
  final String badge;

  /// Footer line of the calendar card.
  final String note;

  /// Footer action of the calendar card.
  final String actionLabel;

  /// Secondary line inside the hero of the details screen.
  final String tagline;

  /// Gold pill at the top of the hero.
  final String ownerBadge;

  /// The two pills under the hero title.
  final List<String> statusPills;
  final String description;

  /// Grey callout inside the "عن المناسبة" card.
  final String highlight;
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
}

class CityData {
  const CityData({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.offsetMinutes,
    required this.qiblaAngle,
    required this.qiblaDirection,
    required this.distanceToMakkah,
    required this.station,
    required this.temperatureDelta,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.cloudCover,
    required this.uvIndex,
    this.holy = false,
  });

  final String id;
  final String name;
  final String country;
  final String region;

  /// Applied to the base (Riyadh) schedule.
  final int offsetMinutes;
  final int qiblaAngle;
  final String qiblaDirection;
  final int distanceToMakkah;
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

  /// `244° جنوب غرب`
  String get qiblaLabel => '$qiblaAngle° $qiblaDirection';
}
