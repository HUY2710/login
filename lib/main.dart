import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/config/app_config.dart';
import 'src/presentation/presentation.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
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
