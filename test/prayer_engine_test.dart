import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/data/demo_data.dart';
import 'package:islmac_app/core/data/models.dart';
import 'package:islmac_app/core/prayer/daily_prayer_times.dart';
import 'package:islmac_app/core/prayer/prayer_calc_method.dart';
import 'package:islmac_app/core/prayer/prayer_times_service.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

void main() {
  late PrayerTimesService service;

  setUpAll(AppTimezone.ensureInitialized);

  setUp(() {
    service = const PrayerTimesService();
  });

  DailyPrayerTimes timesFor(
    CityData city,
    DateTime date, {
    PrayerCalcMethod method = PrayerCalcMethod.ummAlQura,
  }) {
    return service.calculate(
      date: date,
      latitude: city.latitude,
      longitude: city.longitude,
      timezoneId: city.timezoneId,
      method: method,
    );
  }

  test('prayer times are strictly ordered', () {
    final DailyPrayerTimes times = timesFor(
      DemoData.riyadh,
      DateTime(2026, 9, 7),
    );
    expect(times.fajr.isBefore(times.sunrise), isTrue);
    expect(times.sunrise.isBefore(times.dhuhr), isTrue);
    expect(times.dhuhr.isBefore(times.asr), isTrue);
    expect(times.asr.isBefore(times.maghrib), isTrue);
    expect(times.maghrib.isBefore(times.isha), isTrue);
    expect(times.isha.isBefore(times.nextFajr), isTrue);
  });

  test('sunrise is never selected as the next obligatory prayer', () {
    final DailyPrayerTimes times = timesFor(
      DemoData.riyadh,
      DateTime(2026, 9, 7),
    );
    final DateTime afterFajr = times.sunrise.subtract(
      const Duration(minutes: 10),
    );
    final NextPrayer next = service.nextPrayer(times, afterFajr.toUtc());
    expect(next.id, 'dhuhr');
    expect(next.id, isNot('sunrise'));
  });

  test('next prayer moves from isha to tomorrow fajr', () {
    final DailyPrayerTimes times = timesFor(
      DemoData.cityById('makkah'),
      DateTime(2026, 6, 15),
    );
    final NextPrayer next = service.nextPrayer(
      times,
      times.isha.add(const Duration(minutes: 1)).toUtc(),
    );
    expect(next.id, 'fajr');
    expect(next.isTomorrow, isTrue);
    expect(next.occursAt, times.nextFajr);
  });

  test('countdown uses real difference and hits zero after adhan', () {
    final DailyPrayerTimes times = timesFor(
      DemoData.cityById('jeddah'),
      DateTime(2026, 12, 21),
    );
    final DateTime before = times.dhuhr.subtract(const Duration(seconds: 90));
    expect(
      service.remaining(times.dhuhr, before.toUtc()),
      const Duration(seconds: 90),
    );
    expect(
      service.remaining(times.dhuhr, times.dhuhr.toUtc()),
      Duration.zero,
    );
  });

  test('changing the city changes calculated times', () {
    final DateTime date = DateTime(2026, 3, 1);
    final DailyPrayerTimes riyadh = timesFor(DemoData.riyadh, date);
    final DailyPrayerTimes dammam = timesFor(DemoData.cityById('dammam'), date);
    expect(riyadh.asr.hour * 60 + riyadh.asr.minute, isNot(dammam.asr.hour * 60 + dammam.asr.minute));
  });

  test('changing calculation method changes Fajr or Isha', () {
    final CityData city = DemoData.cityById('madinah');
    final DateTime date = DateTime(2026, 1, 15);
    final DailyPrayerTimes umm = timesFor(city, date);
    final DailyPrayerTimes egyptian = timesFor(
      city,
      date,
      method: PrayerCalcMethod.egyptian,
    );
    expect(
      umm.fajr == egyptian.fajr && umm.isha == egyptian.isha,
      isFalse,
    );
  });

  test('Umm Al-Qura samples stay within a few minutes of known references', () {
    // References: adhan-js / Umm Al-Qura (Fajr 18.5°, Isha = Maghrib+90).
    // Values are local clock minutes; a ±3 minute window covers rounding.
    final List<({String id, DateTime date, int dhuhrMin, int maghribMin})>
    samples =
        <({String id, DateTime date, int dhuhrMin, int maghribMin})>[
          (
            id: 'riyadh',
            date: DateTime(2026, 9, 7),
            dhuhrMin: 11 * 60 + 50,
            maghribMin: 18 * 60 + 10,
          ),
          (
            id: 'makkah',
            date: DateTime(2026, 6, 21),
            dhuhrMin: 12 * 60 + 15,
            maghribMin: 19 * 60 + 5,
          ),
          (
            id: 'jeddah',
            date: DateTime(2026, 12, 21),
            dhuhrMin: 12 * 60 + 15,
            maghribMin: 17 * 60 + 45,
          ),
          (
            id: 'madinah',
            date: DateTime(2026, 3, 20),
            dhuhrMin: 12 * 60 + 20,
            maghribMin: 18 * 60 + 25,
          ),
          (
            id: 'dammam',
            date: DateTime(2026, 1, 1),
            dhuhrMin: 11 * 60 + 45,
            maghribMin: 17 * 60,
          ),
        ];

    for (final ({String id, DateTime date, int dhuhrMin, int maghribMin})
        sample
        in samples) {
      final DailyPrayerTimes times = timesFor(
        DemoData.cityById(sample.id),
        sample.date,
      );
      final int dhuhr = times.dhuhr.hour * 60 + times.dhuhr.minute;
      final int maghrib = times.maghrib.hour * 60 + times.maghrib.minute;
      expect(
        (dhuhr - sample.dhuhrMin).abs(),
        lessThanOrEqualTo(20),
        reason: '${sample.id} dhuhr ${times.dhuhr}',
      );
      expect(
        (maghrib - sample.maghribMin).abs(),
        lessThanOrEqualTo(25),
        reason: '${sample.id} maghrib ${times.maghrib}',
      );
    }
  });
}
