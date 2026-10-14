import 'weather_snapshot.dart';

abstract class WeatherRepository {
  Future<WeatherSnapshot> fetch({
    required double latitude,
    required double longitude,
    required String timezoneId,
    required DateTime today,
    bool forceRefresh = false,
  });
}
