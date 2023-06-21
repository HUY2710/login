import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../util/admob_key_constant.dart';

class InterstitialAdManager {
  InterstitialAd? interstitialAd;
  final String adUnitId = Platform.isAndroid
      ? AdmobKeyConstant.interstitialAndroid
      : AdmobKeyConstant.interstitialIos;

  Future<InterstitialAd> loadAd() {
    final Completer<InterstitialAd> completer = Completer<InterstitialAd>();
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            _onAdLoaded(ad);
            completer.complete(interstitialAd);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
    return completer.future;
  }

  void _onAdLoaded(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (InterstitialAd ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (InterstitialAd ad) {},
        // Called when the ad failed to show full screen content.
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError err) {
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          // Dispose the ad here to free resources.
          ad.dispose();
          interstitialAd = null;
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (InterstitialAd ad) {});
    debugPrint('$ad loaded.');
    // Keep a reference to the ad so you can show it later.
    interstitialAd = ad;
  }
}
