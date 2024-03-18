import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'app/app.dart';
import 'module/iap/my_purchase_manager.dart';
import 'src/config/app_config.dart';
import 'src/config/di/di.dart';
import 'src/shared/helpers/logger_utils.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfig.getInstance().init();
    await getIt<MyPurchaseManager>().init();
    runApp(
      const MyApp(),
    );
  }, (error, stack) {
    logger.e('ERROR', error: error, stackTrace: stack);
  });
}
