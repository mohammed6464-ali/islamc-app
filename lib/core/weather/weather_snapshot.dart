import '../data/models.dart';

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.latitude,
    required this.longitude,
    required this.timezoneId,
    required this.fetchedAt,
    required this.data,
    this.isFromCache = false,
  });

  final double latitude;
  final double longitude;
  final String timezoneId;
  final DateTime fetchedAt;
  final WeatherData data;
  final bool isFromCache;

  bool isStale(DateTime nowUtc, {Duration ttl = const Duration(minutes: 20)}) {
    return nowUtc.difference(fetchedAt.toUtc()) > ttl;
  }

  static String cacheKey(double latitude, double longitude) =>
      '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';

  Map<String, Object?> toJson() => <String, Object?>{
    'latitude': latitude,
    'longitude': longitude,
    'timezoneId': timezoneId,
    'fetchedAt': fetchedAt.toIso8601String(),
    'data': data.toJson(),
  };

  static WeatherSnapshot fromJson(Map<String, Object?> json) {
    return WeatherSnapshot(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezoneId: json['timezoneId'] as String? ?? 'Asia/Riyadh',
      fetchedAt:
          DateTime.tryParse(json['fetchedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      data: WeatherData.fromJson(
        Map<String, Object?>.from(json['data'] as Map),
      ),
      isFromCache: true,
    );
  }

  WeatherSnapshot asCached() => WeatherSnapshot(
    latitude: latitude,
    longitude: longitude,
    timezoneId: timezoneId,
    fetchedAt: fetchedAt,
    data: data.copyWith(isFromCache: true),
    isFromCache: true,
  );
}

enum WeatherFailureKind { offline, timeout, parse, unavailable }

class WeatherFailure implements Exception {
  const WeatherFailure(
    this.messageAr, {
    this.kind = WeatherFailureKind.unavailable,
  });

  final String messageAr;
  final WeatherFailureKind kind;

  static const WeatherFailure offline = WeatherFailure(
    'لا يوجد اتصال بالإنترنت. تُعرض آخر بيانات محفوظة إن وُجدت.',
    kind: WeatherFailureKind.offline,
  );
  static const WeatherFailure timeout = WeatherFailure(
    'انتهت مهلة طلب الطقس. حاول التحديث لاحقًا.',
    kind: WeatherFailureKind.timeout,
  );
  static const WeatherFailure parse = WeatherFailure(
    'تعذر قراءة بيانات الطقس المستلمة.',
    kind: WeatherFailureKind.parse,
  );
  static const WeatherFailure unavailable = WeatherFailure(
    'تعذر جلب بيانات الطقس حاليًا.',
    kind: WeatherFailureKind.unavailable,
  );

  @override
  String toString() => messageAr;
}
