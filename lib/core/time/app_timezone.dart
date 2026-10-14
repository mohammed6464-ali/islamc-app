import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'app_clock.dart';

/// IANA timezone helpers. The selected city's zone is the source of truth,
/// not the device zone.
class AppTimezone {
  const AppTimezone._();

  static const String riyadh = 'Asia/Riyadh';

  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) {
      return;
    }
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  static tz.Location locationOf(String timezoneId) {
    ensureInitialized();
    try {
      return tz.getLocation(timezoneId);
    } on Exception {
      return tz.getLocation(riyadh);
    }
  }

  static tz.TZDateTime nowIn(String timezoneId, AppClock clock) {
    return tz.TZDateTime.from(clock.nowUtc(), locationOf(timezoneId));
  }

  static tz.TZDateTime convert(DateTime instant, String timezoneId) {
    return tz.TZDateTime.from(instant.toUtc(), locationOf(timezoneId));
  }

  /// Calendar date (midnight) in the given zone.
  static DateTime calendarDate(String timezoneId, AppClock clock) {
    final tz.TZDateTime now = nowIn(timezoneId, clock);
    return DateTime(now.year, now.month, now.day);
  }
}
