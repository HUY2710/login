import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dependencies/dependencies.dart';

class AppConfig {
  factory AppConfig.getInstance() {
    return _instance;
  }
  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  Future<void> init() async {
    // await Firebase.initializeApp();
    await dotenv.load();
    configureDependencies();
    _settingSystemUI();
  }

  //show hide bottom navigation bar of device
  void _settingSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
    ]);
    SystemChrome.setSystemUIChangeCallback(
        (bool systemOverlaysAreVisible) async {
      if (systemOverlaysAreVisible) {
        Future<void>.delayed(
          const Duration(seconds: 3),
          () => SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: <SystemUiOverlay>[
              SystemUiOverlay.top,
            ],
          ),
        );
      }
    });

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
