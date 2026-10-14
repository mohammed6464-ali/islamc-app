import 'weather_api_service.dart';
import 'weather_cache_service.dart';
import 'open_meteo_parser.dart';
import 'weather_repository.dart';
import 'weather_snapshot.dart';

class OpenMeteoWeatherRepository implements WeatherRepository {
  OpenMeteoWeatherRepository({
    WeatherApiService? api,
    WeatherCacheService? cache,
    OpenMeteoParser? parser,
    this.ttl = const Duration(minutes: 20),
    DateTime Function()? nowUtc,
  }) : _api = api ?? WeatherApiService(),
       _cache = cache ?? MemoryWeatherCache(),
       _parser = parser ?? const OpenMeteoParser(),
       _nowUtc = nowUtc ?? DateTime.now;

  final WeatherApiService _api;
  final WeatherCacheService _cache;
  final OpenMeteoParser _parser;
  final Duration ttl;
  final DateTime Function() _nowUtc;

  @override
  Future<WeatherSnapshot> fetch({
    required double latitude,
    required double longitude,
    required String timezoneId,
    required DateTime today,
    bool forceRefresh = false,
  }) async {
    final String key = WeatherSnapshot.cacheKey(latitude, longitude);
    final WeatherSnapshot? cached = await _cache.read(key);
    final DateTime now = _nowUtc().toUtc();
    if (!forceRefresh && cached != null && !cached.isStale(now, ttl: ttl)) {
      return cached.asCached();
    }

    try {
      final Map<String, Object?> json = await _api.fetchForecast(
        latitude: latitude,
        longitude: longitude,
        timezoneId: timezoneId,
      );
      final WeatherSnapshot snapshot = _parser.parse(
        json,
        latitude: latitude,
        longitude: longitude,
        timezoneId: timezoneId,
        today: today,
        fetchedAt: now,
      );
      await _cache.write(key, snapshot);
      return snapshot;
    } on WeatherFailure {
      if (cached != null) {
        return cached.asCached();
      }
      rethrow;
    }
  }
}
