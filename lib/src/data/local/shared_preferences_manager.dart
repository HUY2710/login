import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/enum/preference_keys.dart';

class SharedPreferencesManager {
  const SharedPreferencesManager._();

  static Future<bool?> isExistRated() async {
    return (await SharedPreferences.getInstance())
        .getBool(PreferenceKeys.rateApp.name);
  }

  static Future<void> saveExistRated() async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.rateApp.name, true);
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
        true;
  }
}
