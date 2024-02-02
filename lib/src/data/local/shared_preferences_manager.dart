import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/enum/preference_keys.dart';

class SharedPreferencesManager {
  const SharedPreferencesManager._();
  static Future<SharedPreferences> get _preference =>
      SharedPreferences.getInstance();

  static Future<String?> getString(String key) async {
    return (await _preference).getString(key);
  }

  static Future<bool> setString(String key, String value) async {
    return (await _preference).setString(key, value);
  }

  static Future<void> saveIsFirstLaunch(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.isFirstLaunch.name, status);
  }

  static Future<bool> getIsFirstLaunch() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.isFirstLaunch.name) ??
        true;
  }

  static Future<void> saveIsStarted(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.isStarted.name, status);
  }

  static Future<bool> getIsStarted() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.isStarted.name) ??
        true;
  }

  static Future<void> saveIsPermissionAllow(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.permissionAllow.name, status);
  }

  static Future<bool> getIsPermissionAllow() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.permissionAllow.name) ??
        false;
  }

  static Future<void> saveIsCreateInfoFistTime(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.isCreateInfoFistTime.name, status);
  }

  static Future<bool> getIsCreateInfoFistTime() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.isCreateInfoFistTime.name) ??
        true;
  }
}
