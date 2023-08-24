import 'package:shared_preferences/shared_preferences.dart';

import 'preference_keys.dart';

class SharedPreferencesManager {
  /// First time app launch
  static Future<void> saveFirstTime(bool isFirstTime) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setBool(
        PreferenceKeys.isFistTime.name, isFirstTime);
  }

  static Future<bool?> get isFirstTime async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PreferenceKeys.isFistTime.name);
  }

  /// Permission allow
  static Future<void> savePermissionAllow(bool isAllow) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setBool(
        PreferenceKeys.permissionAllow.name, isAllow);
  }

  static Future<bool?> get isPermissionAllow async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getBool(PreferenceKeys.permissionAllow.name);
  }

  /// Language code
  static Future<void> saveCurrentLanguageCode(String languageCode) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setString(
        PreferenceKeys.currentLanguageCode.name, languageCode);
  }

  static Future<String?> get getCurrentLanguageCode async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(PreferenceKeys.currentLanguageCode.name);
  }
}
