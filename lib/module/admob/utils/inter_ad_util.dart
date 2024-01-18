import 'dart:async';
import 'dart:ui';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';

import '../../../src/config/di/di.dart';
import '../../../src/config/navigation/app_router.dart';

class InterAdUtil {
  InterAdUtil._();

  static InterAdUtil instance = InterAdUtil._();
  bool _canShow = true;

  Future<void> showInterAd({
    required String id,
    VoidCallback? onShowed,
    VoidCallback? onFailed,
    VoidCallback? onNoInternet,
    VoidCallback? adDismissed,
  }) async {
    if (_canShow) {
      _canShow = false;
      await EasyAds.instance.showSplashInterstitialAd(
        getIt<AppRouter>().navigatorKey.currentContext!,
        adId: id,
        onShowed: () {
          onShowed?.call();
        },
        onFailed: () {
          onFailed?.call();
        },
        onNoInternet: () {
          onNoInternet?.call();
        },
        adDissmissed: () {
          adDismissed?.call();
        },
      );
      Timer(
        const Duration(seconds: 15),
        () {
          _canShow = true;
        },
      );
    }
  }

  Future<void> showInterSplashAd({
    required String id,
    VoidCallback? onShowed,
    VoidCallback? onFailed,
    VoidCallback? onNoInternet,
    VoidCallback? adDismissed,
  }) async {
    if (_canShow) {
      _canShow = false;
      await EasyAds.instance.showSplashInterstitialAd(
        getIt<AppRouter>().navigatorKey.currentContext!,
        adId: id,
        onShowed: () {
          onShowed?.call();
        },
        onFailed: () {
          onFailed?.call();
        },
        onNoInternet: () {
          onNoInternet?.call();
        },
        adDissmissed: () {
          adDismissed?.call();
        },
      );
      Timer(
        const Duration(seconds: 15),
        () {
          _canShow = true;
        },
      );
    }
  }
}
