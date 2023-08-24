import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
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
    runApp(
      const MyApp(),
    );
  }, (error, stack) {
    if (kDebugMode) {
      print(stack);
      print(error);
    }
  });
}
