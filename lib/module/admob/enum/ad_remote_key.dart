import 'dart:io';

enum AdRemoteKeys {
  show,
  interSplash,
}

extension AdKeyNames on AdRemoteKeys {
  String get platformKey {
    final String prefix = Platform.isAndroid ? 'android_' : 'ios_';
    return '$prefix$name';
  }
}
