import 'prayer_calc_method.dart';

/// Prayer times for one civil date in a specific timezone.
class DailyPrayerTimes {
  const DailyPrayerTimes({
    required this.date,
    required this.timezoneId,
    required this.latitude,
    required this.longitude,
    required this.method,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextFajr,
  });

  /// Date-only (local civil date of the location).
  final DateTime date;
  final String timezoneId;
  final double latitude;
  final double longitude;
  final PrayerCalcMethod method;

  /// Instants in the location timezone (TZDateTime under the hood).
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime nextFajr;

  DateTime timeOf(String id) {
    return switch (id) {
      'fajr' => fajr,
      'sunrise' => sunrise,
      'dhuhr' => dhuhr,
      'asr' => asr,
      'maghrib' => maghrib,
      'isha' => isha,
      _ => throw ArgumentError.value(id, 'id'),
    };
  }

  /// Ordered obligatory prayers including tomorrow's Fajr.
  List<({String id, DateTime time})> get obligatoryWithNextFajr =>
      <({String id, DateTime time})>[
        (id: 'fajr', time: fajr),
        (id: 'dhuhr', time: dhuhr),
        (id: 'asr', time: asr),
        (id: 'maghrib', time: maghrib),
        (id: 'isha', time: isha),
        (id: 'fajr', time: nextFajr),
      ];
}

class NextPrayer {
  const NextPrayer({
    required this.id,
    required this.occursAt,
    required this.isTomorrow,
  });

  final String id;
  final DateTime occursAt;
  final bool isTomorrow;
}
