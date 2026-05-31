import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _preferences;

  const LocalStorageService(this._preferences);

  static Future<LocalStorageService> create() async {
    final preferences = await SharedPreferences.getInstance();
    return LocalStorageService(preferences);
  }

  bool? readBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> writeBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  Map<String, dynamic>? readJsonMap(String key) {
    final raw = _preferences.getString(key);
    if (raw == null) {
      return null;
    }

    final decoded = _decode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  List<Map<String, dynamic>> readJsonMapList(String key) {
    final raw = _preferences.getString(key);
    if (raw == null) {
      return const [];
    }

    final decoded = _decode(raw);
    if (decoded is! List) {
      return const [];
    }

    return [
      for (final item in decoded)
        if (item is Map<String, dynamic>) item,
    ];
  }

  Future<void> writeJson(String key, Object? value) async {
    await _preferences.setString(key, jsonEncode(value));
  }

  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  Future<void> clear() async {
    await _preferences.clear();
  }

  Object? _decode(String raw) {
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }
}
