import 'dart:io';

enum RemoteKeys {
  forceUpdate,
  adOffVersion,
  showSkipIntroButton,
  multipleLoadIntroAd,
}

extension RemoteKeysExt on RemoteKeys {
  String get platformKey {
    final String prefix = Platform.isAndroid ? 'android_' : 'ios_';
    return '$prefix$name';
  }
}
