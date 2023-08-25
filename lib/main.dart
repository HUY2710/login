import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/config/app_config.dart';
import 'src/config/observer/bloc_observer.dart';
import 'src/presentation/presentation.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
    Bloc.observer = MainBlocObserver();
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
