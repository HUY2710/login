import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../gen/assets.gen.dart';
import '../../global/global.dart';
import '../../service/app_ad_id_manager.dart';
import '../../service/shared_preferences/shared_preferences_manager.dart';
import '../../shared/enum/ads/ad_remote_key.dart';
import '../../shared/mixin/ads_mixin.dart';

@RoutePage()
class SplashScreen extends StatefulWidget with AdsMixin {
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
    if (mounted) {
      await showAd();
    }
    if (mounted) {
      await setInitScreen();
    }
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
    final bool isShowAd = Global.instance.showAd;
    //init and show ad
    if (mounted && isShowInterAd && isShowAd) {
      await initializeAd();
      if (mounted) {
        await widget.showInterAd(context,
            id: getIt<AppAdIdManager>().adUnitId.interSplash);
      }
    }
    //set up ad open
    if (mounted && isOpenAppAd && isShowAd) {
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
