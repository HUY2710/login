import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../util/admob_key_constant.dart';

class NativeAdManager {
  NativeAdManager(this.templateType);

  TemplateType templateType;

  NativeAd? nativeAd;
  final String _adUnitId = Platform.isAndroid
      ? AdmobKeyConstant.nativeAndroid
      : AdmobKeyConstant.nativeIos;

  Future<NativeAd> loadAd() async {
    final Completer<NativeAd> completer = Completer<NativeAd>();
    nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            completer.complete(nativeAd);
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (Ad ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (Ad ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision,
              String currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.white,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)));
    nativeAd!.load();

    return completer.future;
  }
}
