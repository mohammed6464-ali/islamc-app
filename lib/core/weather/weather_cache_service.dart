import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'weather_snapshot.dart';

abstract class WeatherCacheService {
  Future<WeatherSnapshot?> read(String key);

  Future<void> write(String key, WeatherSnapshot snapshot);
}

class MemoryWeatherCache implements WeatherCacheService {
  MemoryWeatherCache([Map<String, WeatherSnapshot>? seed])
    : _data = Map<String, WeatherSnapshot>.from(
        seed ?? const <String, WeatherSnapshot>{},
      );

  final Map<String, WeatherSnapshot> _data;

  @override
  Future<WeatherSnapshot?> read(String key) async => _data[key]?.asCached();

  @override
  Future<void> write(String key, WeatherSnapshot snapshot) async {
    _data[key] = snapshot;
  }
}

class SharedPrefsWeatherCache implements WeatherCacheService {
  SharedPrefsWeatherCache(this._prefs);

  final SharedPreferences _prefs;

  static const String _prefix = 'weather_cache_v1:';

  @override
  Future<WeatherSnapshot?> read(String key) async {
    final String? raw = _prefs.getString('$_prefix$key');
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return WeatherSnapshot.fromJson(
        decoded.map(
          (Object? k, Object? v) =>
              MapEntry<String, Object?>(k.toString(), v),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, WeatherSnapshot snapshot) async {
    await _prefs.setString('$_prefix$key', jsonEncode(snapshot.toJson()));
  }
}
