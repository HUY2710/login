import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'src/config/app_config.dart';
import 'src/presentation/presentation.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // // Pass all uncaught "fatal" errors from the framework to Crashlytics
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // };
    // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
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
