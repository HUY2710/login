import 'dart:io';

enum AdRemoteKeys {
  show,
  inter_splash,
  app_open_resume,
  native_language,
  native_language_setting,
  inter_intro,
  banner_collapse_home,
  banner_all,
  inter_message,
  inter_add_place,
  native_map,
  inter_edit_profile,
  native_edit,
  show_rate,
}

extension AdKeyNames on AdRemoteKeys {
  String get platformKey {
    final String prefix = Platform.isAndroid ? 'android_' : 'ios_';
    return '$prefix$name';
  }
}
