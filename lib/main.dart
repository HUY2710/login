import 'dart:async';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'src/config/app_config.dart';
import 'src/shared/helpers/logger_utils.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
    runApp(
      const MyApp(),
    );
  }, (error, stack) {
    logger.e('ERROR', error: error, stackTrace: stack);
  });
}
