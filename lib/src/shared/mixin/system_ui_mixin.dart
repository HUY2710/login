import 'package:flutter/services.dart';

import '../../global/global.dart';

mixin SystemUiMixin {
  void hideNavigationBar() {
    if (Global.instance.androidSdkVersion > 30) {
      setBehavior(SystemUiMode.manual);
    } else {
      setBehavior(SystemUiMode.immersive);
    }
  }

  void setBehavior(SystemUiMode mode) {
    SystemChrome.setEnabledSystemUIMode(mode, overlays: <SystemUiOverlay>[
      SystemUiOverlay.top,
    ]);
  }
}
