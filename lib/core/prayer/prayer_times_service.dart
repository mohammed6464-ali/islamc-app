import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/hijri_date.dart';
import '../time/app_timezone.dart';
import 'daily_prayer_times.dart';
import 'prayer_calc_method.dart';

class PrayerTimesException implements Exception {
  const PrayerTimesException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Local astronomical engine. No network is required.
class PrayerTimesService {
  const PrayerTimesService();

  DailyPrayerTimes calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required String timezoneId,
    PrayerCalcMethod method = PrayerCalcMethod.defaultMethod,
  }) {
    AppTimezone.ensureInitialized();
    final DateTime civil = DateTime(date.year, date.month, date.day);
    final tz.Location zone = AppTimezone.locationOf(timezoneId);
    CalculationParameters params = method.parameters();

    final HijriDate hijri = HijriDate.fromGregorian(civil);
    if (method == PrayerCalcMethod.ummAlQura && hijri.month == 9) {
      params = params.copyWith(ishaInterval: 120);
    }

    final PrayerTimes times;
    try {
      times = PrayerTimes(
        date: DateTime.utc(civil.year, civil.month, civil.day),
        coordinates: Coordinates(latitude, longitude),
        calculationParameters: params,
      );
    } catch (error) {
      throw PrayerTimesException('تعذر حساب مواقيت الصلاة: $error');
    }

    tz.TZDateTime local(DateTime utc) =>
        tz.TZDateTime.from(utc.toUtc(), zone);

    final DailyPrayerTimes result = DailyPrayerTimes(
      date: civil,
      timezoneId: timezoneId,
      latitude: latitude,
      longitude: longitude,
      method: method,
      fajr: local(times.fajr),
      sunrise: local(times.sunrise),
      dhuhr: local(times.dhuhr),
      asr: local(times.asr),
      maghrib: local(times.maghrib),
      isha: local(times.isha),
      nextFajr: local(times.fajrAfter),
    );
    _assertOrdered(result);
    return result;
  }

  NextPrayer nextPrayer(DailyPrayerTimes today, DateTime nowUtc) {
    final tz.TZDateTime now = AppTimezone.convert(nowUtc, today.timezoneId);
    for (final ({String id, DateTime time}) entry
        in today.obligatoryWithNextFajr) {
      if (entry.time.isAfter(now)) {
        final bool tomorrow =
            entry.time.year != today.date.year ||
            entry.time.month != today.date.month ||
            entry.time.day != today.date.day;
        return NextPrayer(
          id: entry.id,
          occursAt: entry.time,
          isTomorrow: tomorrow,
        );
      }
    }
    return NextPrayer(id: 'fajr', occursAt: today.nextFajr, isTomorrow: true);
  }

  Duration remaining(DateTime occursAt, DateTime nowUtc) {
    final Duration delta = occursAt.toUtc().difference(nowUtc.toUtc());
    if (delta.isNegative) {
      return Duration.zero;
    }
    return delta;
  }

  static void _assertOrdered(DailyPrayerTimes times) {
    final List<DateTime> ordered = <DateTime>[
      times.fajr,
      times.sunrise,
      times.dhuhr,
      times.asr,
      times.maghrib,
      times.isha,
      times.nextFajr,
    ];
    for (int i = 1; i < ordered.length; i++) {
      if (!ordered[i].isAfter(ordered[i - 1])) {
        throw const PrayerTimesException(
          'نتائج المواقيت غير مرتبة زمنيًا. أعد المحاولة أو غيّر طريقة الحساب.',
        );
      }
    }
  }
}
