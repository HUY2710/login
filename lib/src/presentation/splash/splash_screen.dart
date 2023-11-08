import 'dart:convert';
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../flavors.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/mixin/ads_mixin.dart';
import '../../../module/admob/model/ad_unit_id/ad_unit_id_model.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/observer/bloc_observer.dart';
import '../../config/remote_config.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/helpers/env_params.dart';

@RoutePage()
class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with AdsMixin {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!kDebugMode) {
      initCrashlytics();
    }
    await loadEnv();
    await initAppsflyer();
    await AppLovinMAX.initialize(EnvParams.appLovinKey);
    initDebugger();
    await RemoteConfigManager.instance.initConfig();
    await loadAdUnitId();
    await showAd();
    await setInitScreen();
  }

  Future<void> setInitScreen() async {
    final bool isFirstLaunch =
        await getIt<SharedPreferencesManager>().getIsFirstLaunch();
    if (isFirstLaunch && context.mounted) {
      AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
    } else {
      AutoRouter.of(context).replace(const MyHomeRoute());
    }
  }

  Future<void> showAd() async {
    final bool isShowInterAd =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.inter_splash);
    final bool isOpenAppAd =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.app_open_on_resume);
    //init and show ad
    if (mounted && isShowInterAd) {
      await initializeAd();
      if (mounted) {
        await showInterAd(context,
            id: getIt<AppAdIdManager>().adUnitId.interSplash);
      }
    }
    //set up ad open
    if (mounted && isOpenAppAd) {
      EasyAds.instance.initAdmob(
        appOpenAdUnitId: getIt<AppAdIdManager>().adUnitId.appOpenOnResume,
      );
    }
  }

  Future<void> initializeAd() async {
    await EasyAds.instance.initialize(
      getIt<AppAdIdManager>(),
      Assets.images.logo.image(height: 293.h, width: 259.w),
      unityTestMode: true,
      adMobAdRequest: const AdRequest(httpTimeoutMillis: 30000),
      admobConfiguration: RequestConfiguration(),
      navigatorKey: getIt<AppRouter>().navigatorKey,
    );
  }
  void initCrashlytics() {
    if(!kDebugMode){
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
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
  void initDebugger() {
    if(kDebugMode){
      Bloc.observer = MainBlocObserver();
    }
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
    await dotenv.load(); //Load file .env
    final Map<String, String> generalKey = Map.from(dotenv.env);
    if (F.appFlavor == Flavor.prod) {
      await dotenv.load(fileName: '.env.prod', mergeWith: generalKey);
    } else {
      await dotenv.load(fileName: '.env.dev', mergeWith: generalKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          //error render
          // ListView()
        ],
      ),
    );
  }
}
