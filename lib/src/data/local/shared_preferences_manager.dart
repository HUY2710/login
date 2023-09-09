import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/enum/preference_keys.dart';

@singleton
class SharedPreferencesManager {
  Future<SharedPreferences> get _preference => SharedPreferences.getInstance();

  Future<bool> getIsFirstLaunch() async {
    return (await _preference).getBool(PreferenceKeys.isFistTime.name) ?? true;
  }

  Future<void> saveIsFirstLaunch(bool isFirstLaunch) async {
    (await _preference).setBool(PreferenceKeys.isFistTime.name, isFirstLaunch);
  }

  /// Language code
  Future<void> saveCurrentLanguageCode(String languageCode) async {
    (await _preference)
        .setString(PreferenceKeys.currentLanguageCode.name, languageCode);
  }

  Future<String?> get getCurrentLanguageCode async {
    return (await _preference)
        .getString(PreferenceKeys.currentLanguageCode.name);
  }

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
}
