import 'package:shared_preferences/shared_preferences.dart';

class MushafLocalStorage {
  MushafLocalStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<int?> getInt(String key) => _preferences.getInt(key);

  Future<void> setInt(String key, int value) => _preferences.setInt(key, value);

  Future<bool?> getBool(String key) => _preferences.getBool(key);

  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  Future<List<String>?> getStringList(String key) =>
      _preferences.getStringList(key);

  Future<void> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);
}
