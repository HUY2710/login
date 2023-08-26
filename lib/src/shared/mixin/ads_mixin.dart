import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../flavors.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../data/model/ad_unit_id_model.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../service/app_ad_id_manager.dart';
import '../enum/ads/ad_remote_key.dart';

mixin AdsMixin {
  bool checkVisibleAd(AdRemoteKeys key) {
    final bool isShowAd = Global.instance.showAd;
    final bool isShowItemAd = RemoteConfigManager.instance.isShowAd(key);
    return isShowAd && isShowItemAd;
  }

  Future<bool> showInterAd(
    BuildContext context, {
    required String id,
  }) async {
    final Completer<bool> completer = Completer();
    EasyAds.instance.showInterstitialAd(
      getIt<AppRouter>().navigatorKey.currentContext!,
      adId: id,
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
    return completer.future;
  }

  Future<void> showAd(BuildContext context) async {
    final bool isShowInterAd =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.inter_splash);
    final bool isOpenAppAd =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.app_open_on_resume);
    final bool isShowAd = Global.instance.showAd;
    if (context.mounted && isShowInterAd && isShowAd) {
      await initializeAd();
      if (context.mounted) {
        await showInterAd(context,
            id: getIt<AppAdIdManager>().adUnitId.interSplash);
      }
    }
    if (context.mounted && isOpenAppAd && isShowAd) {
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

  Future<void> loadAdUnitId() async {
    final String environment = F.appFlavor == Flavor.dev ? 'dev' : 'prod';
    final String platform = Platform.isAndroid ? 'android' : 'ios';
    final String filePath =
        'assets/ad_unit_id/$environment/ad_id_$platform.json';
    final String text = await rootBundle.loadString(filePath);
    final Map<String, dynamic> json = jsonDecode(text) as Map<String, dynamic>;

    getIt<AppAdIdManager>().adUnitId = AdUnitIdModel.fromJson(json);
  }
}
