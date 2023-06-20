import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_key_constant.dart';

class BannerAdManager{
  BannerAd? bannerAd;

  final String adUnitId = Platform.isAndroid
      ? AdmobKeyConstant.bannerAndroid
      : AdmobKeyConstant.bannerIos;

  /// Loads a banner ad.
  Future<void> loadAd() async {
    // final Completer<void> completer = Completer<void>();
    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded.');
          // completer.complete();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    );
    return bannerAd!.load();
    // return completer.future;
  }
}
