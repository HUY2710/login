import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/enum/preference_keys.dart';

@singleton
class SharedPreferencesManager {
  Future<SharedPreferences> get _preference => SharedPreferences.getInstance();

  Future<bool?> isExistRated() async {
    return (await _preference).getBool(PreferenceKeys.rateApp.name);
  }

  Future<void> saveExistRated() async {
    (await _preference).setBool(PreferenceKeys.rateApp.name, true);
  }

  Future<void> saveIsStarted(bool status) async {
    (await _preference).setBool(PreferenceKeys.isStarted.name, status);
  }

  Future<bool> getIsStarted() async {
    return (await _preference).getBool(PreferenceKeys.isStarted.name) ?? true;
  }

  Future<void> saveIsPermissionAllow(bool status) async {
    (await _preference).setBool(PreferenceKeys.permissionAllow.name, status);
  }

  Future<bool> getIsPermissionAllow() async {
    return (await _preference).getBool(PreferenceKeys.permissionAllow.name) ??
        true;
  }
}
