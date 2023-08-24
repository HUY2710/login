import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preference_keys.dart';

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
}
