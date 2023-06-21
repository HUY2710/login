import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_key_constant.dart';

class BannerAdManager {
  BannerAdManager(this.context);

  BuildContext context;

  BannerAd? _bannerAd;
  final String adUnitId = Platform.isAndroid
      ? AdmobKeyConstant.bannerAndroid
      : AdmobKeyConstant.bannerIos;

  /// Loads a banner ad.
  Future<BannerAd?> loadAnchoredAdaptiveAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return null;
    }
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
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
    _bannerAd!.load();
    return _bannerAd!;
    // return completer.future;
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
