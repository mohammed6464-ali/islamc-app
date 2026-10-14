import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'weather_snapshot.dart';

typedef WeatherHttpGet = Future<http.Response> Function(Uri uri);

class WeatherApiService {
  WeatherApiService({
    http.Client? client,
    WeatherHttpGet? get,
    this.timeout = const Duration(seconds: 12),
  }) : _client = client ?? http.Client(),
       _get = get;

  static const String host = 'api.open-meteo.com';
  static const String attribution = 'Open-Meteo.com';

  final http.Client _client;
  final WeatherHttpGet? _get;
  final Duration timeout;

  Uri forecastUri({
    required double latitude,
    required double longitude,
    required String timezoneId,
  }) {
    return Uri.https(host, '/v1/forecast', <String, String>{
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,'
          'weather_code,cloud_cover,wind_speed_10m,wind_direction_10m,uv_index',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,uv_index_max',
      'timezone': timezoneId,
      'forecast_days': '5',
      'temperature_unit': 'celsius',
      'wind_speed_unit': 'kmh',
    });
  }

  Future<http.Response> _send(Uri uri) {
    final WeatherHttpGet? get = _get;
    if (get != null) {
      return get(uri);
    }
    return _client.get(
      uri,
      headers: const <String, String>{
        'User-Agent': 'TaqweemWaMawaqeet/1.0 (islmac_app; non-commercial)',
        'Accept': 'application/json',
      },
    );
  }

  Future<Map<String, Object?>> fetchForecast({
    required double latitude,
    required double longitude,
    required String timezoneId,
  }) async {
    final Uri uri = forecastUri(
      latitude: latitude,
      longitude: longitude,
      timezoneId: timezoneId,
    );
    try {
      final http.Response response = await (_send(uri)).timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw WeatherFailure.unavailable;
      }
      final Object? decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw WeatherFailure.parse;
      }
      return decoded.map(
        (Object? key, Object? value) =>
            MapEntry<String, Object?>(key.toString(), value),
      );
    } on WeatherFailure {
      rethrow;
    } on TimeoutException {
      throw WeatherFailure.timeout;
    } on SocketException {
      throw WeatherFailure.offline;
    } on FormatException {
      throw WeatherFailure.parse;
    } on http.ClientException {
      throw WeatherFailure.offline;
    } catch (_) {
      throw WeatherFailure.unavailable;
    }
  }
}
