import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:upgrader/upgrader.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../../flavors.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/model/ad_unit_id/ad_unit_id_model.dart';
import '../../../module/admob/utils/inter_ad_util.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/observer/bloc_observer.dart';
import '../../config/remote_config.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/env_params.dart';
import 'update_dialog.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!kDebugMode) {
      initCrashlytics();
    }

    initDebugger();
    await loadEnv();
    await RemoteConfigManager.instance.initConfig();

    // TODO(son): Bỏ comment khi gắn ad
    // await initAppsflyer();
    // await AppLovinMAX.initialize(EnvParams.appLovinKey);
    await loadAdUnitId();
    await configureAd();

    if (EasyAds.instance.hasInternet) {
      await initUpgrader();
    } else {
      setInitScreen();
    }
  }

  Future<bool> showSplashInter() async {
    final Completer<bool> completer = Completer();
    final bool isShowAd = RemoteConfigManager.instance.globalShowAd();
    if (isShowAd) {
      await InterAdUtil.instance.showInterSplashAd(
        id: getIt<AppAdIdManager>().adUnitId.inter,
        onShowed: () {
          completer.complete(true);
        },
        onFailed: () {
          completer.complete(false);
        },
        onNoInternet: () {
          completer.complete(false);
        },
      );
    } else {
      completer.complete(false);
    }
    return completer.future;
  }

  void initAdOpen() {
    //check show ad using Remote Config
    const bool isOpenAppAd = true;
    //set up ad open
    if (isOpenAppAd) {
      EasyAds.instance.appLifecycleReactor?.setOnSplashScreen(false);
      EasyAds.instance.initAdmob(
        appOpenAdUnitId: getIt<AppAdIdManager>().adUnitId.adOpen,
      );
    }
  }

  Future<void> initUpgrader() async {
    final bool forceUpdate = RemoteConfigManager.instance.isForceUpdate();
    final Upgrader upgrader = Upgrader(
      showIgnore: false,
      showReleaseNotes: false,
      // TODO(all): uncomment to check upgrader
      // debugDisplayAlways: true,
      debugLogging: true,
      showLater: !forceUpdate,
      onLater: () {
        onInitializedConfig();
        return true;
      },
    );
    await upgrader.initialize();
    if (!upgrader.shouldDisplayUpgrade()) {
      onInitializedConfig();
    } else {
      showUpgradeDialog(upgrader, forceUpdate);
    }
  }

  Future<void> onInitializedConfig() async {
    // TODO(son): Bỏ comment khi gắn ad
    if (RemoteConfigManager.instance.globalShowAd()) {
      final result = await showSplashInter();

      if (!result) {
        initAdOpen();
      }
    }
    await setInitScreen();
  }

  void showUpgradeDialog(Upgrader upgrader, bool forceUpdate) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: UpdateDialog(
          upgrader: upgrader,
          context: context,
          forceUpdate: forceUpdate,
        ),
      ),
    );
  }

  Future<void> setInitScreen() async {
    final bool isFirstLaunch =
        await SharedPreferencesManager.getIsFirstLaunch();
    if (mounted) {
      if (isFirstLaunch) {
        AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
      } else {
        final language = context.read<LanguageCubit>().state;
        AutoRouter.of(context).replace(OnBoardingRoute(language: language));
      }
    }
  }

  Future<void> configureAd() async {
    final bool isShowAd = RemoteConfigManager.instance.globalShowAd();
    //init and show ad
    if (mounted && isShowAd) {
      await EasyAds.instance.initialize(
        getIt<AppAdIdManager>(),
        Assets.images.logo.logo.image(height: 120.r, width: 120.r),
        unityTestMode: true,
        adMobAdRequest: const AdRequest(httpTimeoutMillis: 30000),
        admobConfiguration: RequestConfiguration(),
        navigatorKey: getIt<AppRouter>().navigatorKey,
      );
    }
  }

  void initCrashlytics() {
    if (!kDebugMode) {
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
    if (kDebugMode) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.logo.roundedLogo.image(
                    width: 145.r,
                    height: 145.r,
                    fit: BoxFit.contain,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (frame != 0) {
                        return 145.verticalSpace;
                      }
                      return child;
                    },
                  ),
                  16.verticalSpace,
                  Text(
                    F.title,
                    style: TextStyle(
                      color: context.colorScheme.primary,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  MyColors.primary,
                  BlendMode.srcIn,
                ),
                child: Assets.lottie.loading.lottie(
                  width: 70.r,
                ),
              ),
              15.verticalSpace,
              Text(
                context.l10n.thisActionCanContainAds,
                style: const TextStyle(
                  color: MyColors.primary,
                ),
              ),
            ],
          ),
          40.verticalSpace,
        ],
      ),
    );
  }
}
