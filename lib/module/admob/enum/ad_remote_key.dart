// ignore_for_file: constant_identifier_names

import 'dart:io';

enum AdRemoteKeys {
  show,
  inter_splash,
  app_open_on_resume,
  native_language,
  native_language2,
  native_language3,
  native_intro,
  inter_intro,
  native_permission,
  inter_item,
  native_share,
  native_find_friend,
  native_add,
  native_location,
  native_tracking_user_list,
  banner_collab_home,
  banner_all,
  inter_add_account,
  native_user,
}

extension AdKeyNames on AdRemoteKeys {
  String get keyName {
    final String prefix = Platform.isAndroid ? 'android_' : 'ios_';
    return '$prefix$name';
  }
}
