import '../data/hijri_date.dart';
import '../data/models.dart';
import 'weather_condition_mapper.dart';
import 'weather_snapshot.dart';

/// Parses Open-Meteo forecast JSON. Isolated for unit tests.
class OpenMeteoParser {
  const OpenMeteoParser({this.mapper = const WeatherConditionMapper()});

  final WeatherConditionMapper mapper;

  WeatherSnapshot parse(
    Map<String, Object?> json, {
    required double latitude,
    required double longitude,
    required String timezoneId,
    required DateTime today,
    required DateTime fetchedAt,
  }) {
    final Map<String, Object?> current = _map(json['current']);
    final Map<String, Object?> daily = _map(json['daily']);

    if (current.isEmpty) {
      throw WeatherFailure.parse;
    }

    final int code = _int(current['weather_code']);
    final bool isDay = _int(current['is_day']) == 1;
    final MappedWeatherCondition condition = mapper.map(code, isDay: isDay);
    final int temperature = _int(current['temperature_2m']);
    final int feelsLike = _int(
      current['apparent_temperature'],
      fallback: temperature,
    );
    final int humidity = _int(current['relative_humidity_2m']);
    final int windSpeed = _int(current['wind_speed_10m']);
    final int windDeg = _int(current['wind_direction_10m']);
    final int cloud = _int(current['cloud_cover']);
    final List<int> dailyMax = _intList(daily['temperature_2m_max']);
    final List<int> dailyMin = _intList(daily['temperature_2m_min']);
    final List<int> dailyCodes = _intList(daily['weather_code']);
    final List<int> dailyUv = _intList(daily['uv_index_max']);
    final List<String> dates = _stringList(daily['time']);
    final int uv = _int(current['uv_index'], fallback: dailyUv.firstOrNull ?? 0);

    final List<DailyForecast> forecast = <DailyForecast>[];
    final int count = dates.length.clamp(0, 5);
    for (int i = 0; i < count; i++) {
      final DateTime date = DateTime.tryParse(dates[i]) ?? today.add(Duration(days: i));
      final bool isToday =
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final MappedWeatherCondition dayCondition = mapper.map(
        i < dailyCodes.length ? dailyCodes[i] : code,
        isDay: true,
      );
      forecast.add(
        DailyForecast(
          day: isToday
              ? 'اليوم (${GregorianLabels.weekdayName(date)})'
              : GregorianLabels.weekdayName(date),
          description: dayCondition.labelAr,
          high: i < dailyMax.length ? dailyMax[i] : temperature,
          low: i < dailyMin.length ? dailyMin[i] : temperature,
          icon: dayCondition.icon,
          badge: isToday
              ? 'الحالي'
              : (date.weekday == DateTime.friday ? 'يوم مبارك' : null),
          badgeTone: date.weekday == DateTime.friday && !isToday
              ? BadgeTone.amber
              : BadgeTone.mint,
          isToday: isToday,
          date: date,
          weatherCode: i < dailyCodes.length ? dailyCodes[i] : code,
        ),
      );
    }

    return WeatherSnapshot(
      latitude: latitude,
      longitude: longitude,
      timezoneId: timezoneId,
      fetchedAt: fetchedAt,
      data: WeatherData(
        temperature: temperature,
        high: dailyMax.firstOrNull ?? temperature,
        low: dailyMin.firstOrNull ?? temperature,
        feelsLike: feelsLike,
        condition: condition.labelAr,
        humidity: humidity,
        windSpeed: windSpeed,
        windDirection: WeatherConditionMapper.windDirectionAr(windDeg),
        cloudCover: cloud,
        uvIndex: uv,
        uvLabel: WeatherConditionMapper.uvLabel(uv),
        station: 'Open-Meteo',
        outdoorNote: condition.outdoorNote,
        forecast: forecast,
        weatherCode: code,
        isDay: isDay,
        fetchedAt: fetchedAt,
        badge: condition.badge,
      ),
    );
  }

  static Map<String, Object?> _map(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (Object? key, Object? v) =>
            MapEntry<String, Object?>(key.toString(), v),
      );
    }
    return <String, Object?>{};
  }

  static int _int(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    return fallback;
  }

  static List<int> _intList(Object? value) {
    if (value is! List) {
      return const <int>[];
    }
    return value.map((Object? item) => _int(item)).toList(growable: false);
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    return value.map((Object? item) => item.toString()).toList(growable: false);
  }
}
