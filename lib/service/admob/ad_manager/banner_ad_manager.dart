import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob_key_constant.dart';

class BannerAdManager {
  BannerAdManager({required this.context, this.insets = 16});

  BuildContext context;
  double insets;

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
    return _loadAd(size: size);
  }

  Future<BannerAd?> loadInlineAdaptiveAd() async {
    const AdSize size = AdSize.mediumRectangle;
    return _loadAd(size: size);
  }

  Future<BannerAd> _loadAd(
      {required AdSize size,
      Function(Ad ad)? onAdLoaded,
      Function(Ad ad, LoadAdError err)? onAdFailedToLoad}) async {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: onAdLoaded,
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          if (onAdFailedToLoad != null) {
            onAdFailedToLoad(ad, err);
          }
          ad.dispose();
        },
      ),
    );
    await _bannerAd!.load();
    return _bannerAd!;
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
