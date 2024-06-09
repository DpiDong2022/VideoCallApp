import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Save a string value
  static Future<bool> saveString(String key, String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(key, value);
  }

  /// Save an integer value
  static Future<bool> saveInt(String key, int value) async {
    final prefs = await _getPrefs();
    return prefs.setInt(key, value);
  }

  /// Save a double value
  static Future<bool> saveDouble(String key, double value) async {
    final prefs = await _getPrefs();
    return prefs.setDouble(key, value);
  }

  /// Save a boolean value
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(key, value);
  }

  /// Get a string value
  static Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  /// Get an integer value
  static Future<int?> getInt(String key) async {
    final prefs = await _getPrefs();
    return prefs.getInt(key);
  }

  /// Get a double value
  static Future<double?> getDouble(String key) async {
    final prefs = await _getPrefs();
    return prefs.getDouble(key);
  }

  /// Get a boolean value
  static Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  /// Remove a value
  static Future<bool> remove(String key) async {
    final prefs = await _getPrefs();
    return prefs.remove(key);
  }

  /// Check if a value exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  /// Clear all values
  static Future<bool> clear() async {
    final prefs = await _getPrefs();
    return prefs.clear();
  }
}
