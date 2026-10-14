import '../data/demo_data.dart';
import '../data/models.dart';
import 'weather_repository.dart';
import 'weather_snapshot.dart';

class FakeWeatherRepository implements WeatherRepository {
  FakeWeatherRepository({
    this.delay = Duration.zero,
    this.failure,
    this.onFetch,
  });

  Duration delay;
  WeatherFailure? failure;
  void Function(double latitude, double longitude)? onFetch;
  int fetchCount = 0;
  final List<String> requestedKeys = <String>[];

  @override
  Future<WeatherSnapshot> fetch({
    required double latitude,
    required double longitude,
    required String timezoneId,
    required DateTime today,
    bool forceRefresh = false,
  }) async {
    fetchCount += 1;
    requestedKeys.add(WeatherSnapshot.cacheKey(latitude, longitude));
    onFetch?.call(latitude, longitude);
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failure != null) {
      throw failure!;
    }
    final CityData city = DemoData.nearestCity(latitude, longitude);
    final WeatherData data = DemoData.weatherFor(city);
    return WeatherSnapshot(
      latitude: latitude,
      longitude: longitude,
      timezoneId: timezoneId,
      fetchedAt: DateTime.utc(2026, 9, 7, 7, 27, 24),
      data: data,
    );
  }
}
