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

  static Future<void> saveIsLogin(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.isLogin.name, status);
  }

  static Future<bool> getIsLogin() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.isLogin.name) ??
        false;
  }

  static Future<void> saveIsLoginWithGoogle(bool status) async {
    (await SharedPreferences.getInstance())
        .setBool(PreferenceKeys.isLoginGoogle.name, status);
  }

  static Future<bool> getIsLoginWithGoogle() async {
    return (await SharedPreferences.getInstance())
            .getBool(PreferenceKeys.isLoginGoogle.name) ??
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

  static Future<void> saveTimeSeenChat(String idGroup) async {
    (await SharedPreferences.getInstance()).setString(
        PreferenceKeys.timeSeenChat.name + idGroup, DateTime.now().toString());
  }

  static Future<String?> getTimeSeenChat(String idGroup) async {
    return (await SharedPreferences.getInstance())
        .getString(PreferenceKeys.timeSeenChat.name + idGroup);
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

  static Future<void> setIsWeeklyPremium(bool status) async {
    (await _preference).setBool(PreferenceKeys.isWeeklyPremium.name, status);
  }

  static Future<bool> getIsWeeklyPremium() async {
    return (await _preference).getBool(PreferenceKeys.isWeeklyPremium.name) ??
        false;
  }

  static Future<void> setIsMonthlyPremium(bool status) async {
    (await _preference).setBool(PreferenceKeys.isMonthlyPremium.name, status);
  }

  static Future<bool> getIsMonthlyPremium() async {
    return (await _preference).getBool(PreferenceKeys.isMonthlyPremium.name) ??
        false;
  }

  static Future<void> setGuide(bool value) async {
    (await _preference).setBool(PreferenceKeys.showGuide.name, value);
  }

  static Future<bool> getGuide() async {
    return (await _preference).getBool(PreferenceKeys.showGuide.name) ?? true;
  }

  static Future<void> setFCMToken(String value) async {
    (await _preference).setString(PreferenceKeys.fcmToken.name, value);
  }

  static Future<String> getFCMToken() async {
    return (await _preference).getString(PreferenceKeys.fcmToken.name) ?? '';
  }
}
