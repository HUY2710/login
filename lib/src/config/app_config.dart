import 'dart:convert';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../flavors.dart';
import '../data/model/ad_unit_id_model.dart';
import '../service/app_ad_id_manager.dart';
import '../shared/constants/app_constants.dart';
import '../shared/helpers/env_params.dart';
import '../shared/mixin/ads_mixin.dart';
import 'di/di.dart';
import 'observer/bloc_observer.dart';
import 'remote_config.dart';

class AppConfig with AdsMixin {
  factory AppConfig.getInstance() {
    return _instance;
  }

  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  Future<void> init() async {
    await Firebase.initializeApp();
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await loadEnv();
    configureDependencies();
    await _settingSystemUI();
    // await initAppsflyer();
    inItDebugger();
    await RemoteConfigManager.instance.initConfig();
    loadAdUnitId();
  }

  Future<void> loadAdUnitId() async {
    final String environment = F.appFlavor == Flavor.dev ? 'dev' : 'prod';
    final String platform = Platform.isAndroid ? 'android' : 'ios';
    final String filePath =
        'assets/ad_unit_id/$environment/ad_id_$platform.json';
    final String text = await rootBundle.loadString(filePath);
    final Map<String, dynamic> json = jsonDecode(text) as Map<String, dynamic>;

    getIt<AppAdIdManager>().adUnitId = AdUnitIdModel.fromJson(json);
  }

  //for dev
  void inItDebugger() {
    Bloc.observer = MainBlocObserver();
  }

  Future<void> initAppsflyer() async {
    final AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: EnvParams.appsflyerKey,
      appId: AppConstants.appIOSId,
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 50,
    );
    final AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    await appsflyerSdk.initSdk();
  }

  Future<void> loadEnv() async {
    await dotenv.load();
    final Map<String, String> generalKey = Map.from(dotenv.env);
    if (F.appFlavor == Flavor.prod) {
      await dotenv.load(fileName: '.env.prod', mergeWith: generalKey);
    } else {
      await dotenv.load(fileName: '.env.dev', mergeWith: generalKey);
    }
  }

  //show hide bottom navigation bar of device
  Future<void> _settingSystemUI() async {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ));

      void setBehavior(SystemUiMode mode) {
        SystemChrome.setEnabledSystemUIMode(mode, overlays: <SystemUiOverlay>[
          SystemUiOverlay.top,
        ]);

        SystemChrome.setSystemUIChangeCallback(
            (bool systemOverlaysAreVisible) async {
          if (systemOverlaysAreVisible) {
            Future<void>.delayed(
              const Duration(seconds: 3),
              () => SystemChrome.setEnabledSystemUIMode(mode,
                  overlays: <SystemUiOverlay>[
                    SystemUiOverlay.top,
                  ]),
            );
          }
        });
      }

      if ((await DeviceInfoPlugin().androidInfo).version.sdkInt > 30) {
        setBehavior(SystemUiMode.manual);
      } else {
        setBehavior(SystemUiMode.immersive);
      }
    }
  }
}
