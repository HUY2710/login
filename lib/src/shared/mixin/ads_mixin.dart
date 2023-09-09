import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../enum/ads/ad_remote_key.dart';

mixin AdsMixin {
  bool checkVisibleStatus(AdRemoteKeys key) {
    return RemoteConfigManager.instance.isShowAd(key);
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
}
