import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../firebase_options.dart';
import '../../flavors.dart';
import 'di/di.dart';

class AppConfig {
  factory AppConfig.getInstance() {
    return _instance;
  }
  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await loadEnv();
    configureDependencies();
    _settingSystemUI();
  }

  Future<void> loadEnv() async {
    if (F.appFlavor == Flavor.dev) {
      await dotenv.load(fileName: '.env.dev');
    } else {
      await dotenv.load(fileName: '.env.prod');
    }
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
