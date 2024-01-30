import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../global/global.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/enum/preference_keys.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/helpers/env_params.dart';
import '../map/cubit/select_group_cubit.dart';
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
    // TODO(son): Bỏ comment khi gắn ad
    if (!kDebugMode) {
      initCrashlytics();
    }

    initDebugger();
    await loadEnv();
    await Future.wait([
      RemoteConfigManager.instance.initConfig(),
      // initAppsflyer(),
      // AppLovinMAX.initialize(EnvParams.appLovinKey),
    ]);
    await RemoteConfigManager.instance.initConfig();
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
          initAdOpen();
        },
        onNoInternet: () {
          completer.complete(false);
          initAdOpen();
        },
        adDismissed: () {
          initAdOpen();
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
    // if (RemoteConfigManager.instance.isShowAd(AdRemoteKeys.interSplash)) {
    //   await showSplashInter();
    // }
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
    // await getMe();
    // await checkInGroup();
    // AutoRouter.of(context).replace(const HomeRoute());
    // return;
    final bool isFirstLaunch =
        await SharedPreferencesManager.getIsFirstLaunch();
    if (mounted) {
      // if (isFirstLaunch) {
      //   AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
      // } else {
      final language = context.read<LanguageCubit>().state;
      AutoRouter.of(context).replace(OnBoardingRoute(language: language));
      // }
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

  //check user
  Future<void> getMe() async {
    final String? userCode =
        await SharedPreferencesManager.getString(PreferenceKeys.userCode.name);

    StoreUser? storeUser;
    if (userCode == null) {
      storeUser = await addNewUser(storeUser: storeUser);
    } else {
      storeUser = await FirestoreClient.instance.getUser(userCode);
    }
    Global.instance.user = storeUser;
    final location = await FirestoreClient.instance.getLocation();
    if (location != null) {
      Global.instance.location = LatLng(location.lat, location.lng);
    }
  }

  //kiểm tra xem mình còn trong group hay không
  Future<void> checkInGroup() async {
    //nếu mình đã ở trong nhóm và sau 1 time mở lại app thì check xem còn là member trong group đó hay không
    if (getIt<SelectGroupCubit>().state != null) {
      try {
        final result = await FirestoreClient.instance
            .isInGroup(getIt<SelectGroupCubit>().state!.idGroup!);
        //nếu không còn ở trong group thì nên reset lại data local của group
        if (!result) {
          getIt<SelectGroupCubit>().update(null);
        }
      } catch (error) {
        //xử lí lỗi
      }
    }
  }

  Future<StoreUser?> addNewUser({
    StoreUser? storeUser,
  }) async {
    final String newCode = 24.randomString();
    int battery = 0;
    try {
      battery = await Battery().batteryLevel;
    } catch (e) {
      battery = 100;
    }
    storeUser = StoreUser(
        code: newCode,
        userName: 'LiLi',
        batteryLevel: battery,
        avatarUrl: Assets.images.avatars.avatar1.path);
    await FirestoreClient.instance.createUser(storeUser).then((value) async {
      await SharedPreferencesManager.setString(
          PreferenceKeys.userCode.name, newCode);
    });
    return storeUser;
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
