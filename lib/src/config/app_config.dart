import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../global/global.dart';
import '../services/firebase_message_service.dart';
import '../shared/mixin/system_ui_mixin.dart';
import 'di/di.dart';

class AppConfig with SystemUiMixin {
  factory AppConfig.getInstance() {
    return _instance;
  }

  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  Future<void> init() async {
    await Future.wait([
      Firebase.initializeApp(),
      _initHydrateBlocStorage(),
      _initGlobalData(),
    ]);
    configureDependencies();
    await FirebaseMessageService().initNotification();
    if (await Permission.notification.isGranted) {
      await FirebaseMessageService().startService();
    }
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.transparent
      ..animationDuration = const Duration(milliseconds: 50)
      ..userInteractions = false
      ..dismissOnTap = false;

    await _settingSystemUI();
  }

  Future<HydratedStorage> _initHydrateBlocStorage() async {
    final Directory tempDir = await getApplicationDocumentsDirectory();
    return HydratedBloc.storage =
        await HydratedStorage.build(storageDirectory: tempDir);
  }

  Future<void> _initGlobalData() async {
    final result = await Future.wait([
      getApplicationDocumentsDirectory(),
      getTemporaryDirectory(),
    ]);
    Global.instance.documentPath = result[0].path;
    Global.instance.temporaryPath = result[1].path;
    if (Platform.isAndroid) {
      Global.instance.androidSdkVersion =
          (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    }
  }

  //show hide bottom navigation bar of device
  Future<void> _settingSystemUI() async {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ));

      hideNavigationBar();
      SystemChrome.setSystemUIChangeCallback(
          (bool systemOverlaysAreVisible) async {
        if (systemOverlaysAreVisible) {
          Future<void>.delayed(
            const Duration(seconds: 3),
            hideNavigationBar,
          );
        }
      });
    }
  }
}
