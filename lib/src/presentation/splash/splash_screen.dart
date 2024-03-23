import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:camera/camera.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../../../flavors.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/model/ad_unit_id/ad_unit_id_model.dart';
import '../../../module/admob/utils/inter_ad_util.dart';
import '../../../module/iap/my_purchase_manager.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/observer/bloc_observer.dart';
import '../../config/remote_config.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/assets.gen.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../services/my_background_service.dart';
import '../../services/tracking_history_place_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/enum/preference_keys.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/helpers/env_params.dart';
import '../../shared/mixin/admob_consent_mixi.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../../shared/widgets/loading/loading_indicator.dart';
import '../chat/widgets/chat_detail/camera_screen.dart';
import '../map/cubit/select_group_cubit.dart';
import 'update_dialog.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with PermissionMixin, AdmobConsentMixin {
  late final StreamSubscription internetListener;
  @override
  void initState() {
    super.initState();
    internetListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          _init();
          break;
        case InternetStatus.disconnected:
          break;
      }
      await Future.delayed(const Duration(seconds: 3));
    });
  }

  Future<void> _init() async {
    // TODO(son): Bỏ comment khi gắn ad
    if (!kDebugMode) {
      initCrashlytics();
    }
    await checkAndShowConsent();
    initDebugger();
    initCamera();
    await loadEnv();
    await Future.wait([
      RemoteConfigManager.instance.initConfig(),
      initAppsflyer(),
      AppLovinMAX.initialize(EnvParams.appLovinKey),
    ]);
    await RemoteConfigManager.instance.initConfig();
    await loadAdUnitId();
    await configureAd();
    Global.instance.packageInfo = await PackageInfo.fromPlatform();
    await getMe();
    await checkInGroup();
    await getIt<TrackingHistoryPlaceService>().initGroups();
    if (EasyAds.instance.hasInternet) {
      await initUpgrader();
    } else {
      setInitScreen();
    }
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
  }

  Future<bool> showSplashInter() async {
    final Completer<bool> completer = Completer();

    final bool isShowInter =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.inter_splash);
    if (isShowInter) {
      await InterAdUtil.instance.showInterSplashAd(
        id: getIt<AppAdIdManager>().adUnitId.interSplash,
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
    final bool isOpenAppAd =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.app_open_resume);
    //set up ad open
    if (isOpenAppAd) {
      EasyAds.instance.appLifecycleReactor?.setOnSplashScreen(false);
      EasyAds.instance.initAdmob(
        appOpenAdUnitId: getIt<AppAdIdManager>().adUnitId.appopenResume,
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
    if (RemoteConfigManager.instance.isShowAd(AdRemoteKeys.inter_splash)) {
      await showSplashInter();
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
    final bool isPermissionAllow = await checkAllPermission();
    final isPremium = getIt<MyPurchaseManager>().state.isPremium();

    final isLogin = await SharedPreferencesManager.isLogin();
    if (mounted) {
      if (isFirstLaunch) {
        AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
        return;
      }

      if (isPremium) {
        if (!isPermissionAllow) {
          AutoRouter.of(context).replace(PermissionRoute(fromMapScreen: false));
          return;
        }
        if (isLogin) {
          AutoRouter.of(context).replace(HomeRoute());
          return;
        }
        AutoRouter.of(context).replace(const SignInRoute());
        return;
      }
      AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
      return;
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
    getIt<MyBackgroundService>().initSubAndUnSubTopic();
    final location = await FirestoreClient.instance.getLocation();

    if (location != null) {
      Global.instance.user = Global.instance.user?.copyWith(location: location);
      Global.instance.serverLocation = LatLng(location.lat, location.lng);
      Global.instance.currentLocation = LatLng(location.lat, location.lng);
    } else {
      final currentLocation =
          await getIt<LocationService>().getCurrentLocation();
      Global.instance.user = Global.instance.user?.copyWith(location: location);
      Global.instance.serverLocation = currentLocation;
      Global.instance.currentLocation = currentLocation;
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
        } else {
          //get lại data của group
          final group = await FirestoreClient.instance
              .getDetailGroup(getIt<SelectGroupCubit>().state!.idGroup!);
          getIt<SelectGroupCubit>().update(group);
        }
      } catch (error) {
        //xử lí lỗi
      }
    }
  }

  Future<StoreUser?> addNewUser({StoreUser? storeUser}) async {
    final String newCode = 24.randomString();

    int battery = 0;
    try {
      battery = await Battery().batteryLevel;
    } catch (e) {
      battery = 100;
    }
    storeUser = StoreUser(
        code: newCode,
        userName: '',
        batteryLevel: battery,
        avatarUrl: Assets.images.avatars.male.avatar1.path);

    await FirestoreClient.instance.createUser(storeUser).then((value) async {
      await SharedPreferencesManager.setString(
          PreferenceKeys.userCode.name, newCode);
    });

    return storeUser;
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffD2B0FF),
              Color(0xff8B4FFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Assets.images.splash.image(
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame != 0) {
                              return 145.verticalSpace;
                            }
                            return child;
                          },
                        ),
                        Positioned(
                          left: 70.w,
                          top: 110.h,
                          child: Assets.lottie.loadingSplash.lottie(
                            width: 60.r,
                          ),
                        ),
                        Positioned(
                          right: 90.w,
                          top: 100.h,
                          child: Assets.lottie.loadingSplash.lottie(
                            width: 100.r,
                          ),
                        )
                      ],
                    ),
                    Text(
                      context.l10n.app_title,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 30.r,
                  width: 50.r,
                  child: const LoadingIndicator(
                    colors: [
                      Color.fromARGB(255, 113, 63, 207),
                      Color(0xffB78CFF),
                      Color(0xffD2B0FF)
                    ],
                    indicatorType: Indicator.ballPulse,
                  ),
                ),
                20.verticalSpace,
                if (Platform.isAndroid)
                  Text(
                    context.l10n.thisActionCanContainAds,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
