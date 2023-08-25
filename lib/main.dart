import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'src/config/app_config.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
    runApp(
      const MyApp(),
    );
  }, (error, stack) {
    debugPrint('error:$error');
    if (kDebugMode) {
      print(stack);
      print(error);
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  });
}
