import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsStore {
  Future<Map<String, Object?>> load();

  Future<void> save(Map<String, Object?> data);

  Future<void> clear();
}

class MemorySettingsStore implements SettingsStore {
  MemorySettingsStore([Map<String, Object?>? seed])
    : _data = Map<String, Object?>.from(seed ?? const <String, Object?>{});

  Map<String, Object?> _data;

  @override
  Future<Map<String, Object?>> load() async =>
      Map<String, Object?>.from(_data);

  @override
  Future<void> save(Map<String, Object?> data) async {
    _data = Map<String, Object?>.from(data);
  }

  @override
  Future<void> clear() async => _data.clear();
}

class SharedPrefsSettingsStore implements SettingsStore {
  SharedPrefsSettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const String key = 'app_settings_v1';

  @override
  Future<Map<String, Object?>> load() async {
    final String? raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return <String, Object?>{};
    }
    final Object? decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return Map<String, Object?>.from(decoded);
    }
    return <String, Object?>{};
  }

  @override
  Future<void> save(Map<String, Object?> data) async {
    await _prefs.setString(key, jsonEncode(data));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(key);
  }
}
