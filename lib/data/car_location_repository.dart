import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/car_location.dart';

class CarLocationRepository {
  CarLocationRepository({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  static const _key = 'car_location';
  static const _historyKey = 'car_location_history';

  final SharedPreferencesAsync _prefs;

  Future<CarLocation?> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    return CarLocation.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(CarLocation location) =>
      _prefs.setString(_key, jsonEncode(location.toJson()));

  Future<List<CarLocation>> loadHistory() async {
    final raw = await _prefs.getString(_historyKey);
    if (raw == null) return [];
    return [
      for (final item in jsonDecode(raw) as List<dynamic>)
        CarLocation.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> saveHistory(List<CarLocation> history) => _prefs.setString(
    _historyKey,
    jsonEncode([for (final location in history) location.toJson()]),
  );
}
