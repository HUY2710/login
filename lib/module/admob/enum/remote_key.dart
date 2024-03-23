import 'dart:io';

enum RemoteKeys {
  forceUpdate,
  adOffVersion,
  showSkipIntroButton,
  multipleLoadIntroAd,
  showFB
}

extension RemoteKeysExt on RemoteKeys {
  String get platformKey {
    final String prefix = Platform.isAndroid ? 'android_' : 'ios_';
    return '$prefix$name';
  }
}
