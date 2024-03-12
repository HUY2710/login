import 'dart:async';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iabtcf_consent_info/iabtcf_consent_info.dart';

/// Usage: To show admob consent dialog
/// refer: https://developers.google.com/admob/flutter/eu-consent#using_the_sdk
/// note: use app example id: ca-app-pub-3940256099942544~3347511713 to test
mixin AdmobConsentMixin<T extends StatefulWidget> on State<T> {
  Future<void> checkAndShowConsent() async {
    final completer = Completer<void>();
    final params = ConsentRequestParameters(
      // for debug purpose
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        // Or DebugGeography.debugGeographyNotEea to simulate outside of the EEA
        testIdentifiers: [
          // add your device id to show dialog
          '2E1F7893C4AAD4873E555048CEB75E05',
        ],
      ),
    );
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // The consent information state was updated.
        // You are now ready to check if a form is available.
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          debugPrint('loading form');
          loadForm(completer);
        } else {
          debugPrint('no consent availableeee');
          completer.complete();
        }
      },
      (FormError error) {
        debugPrint(error.message);
        completer.complete();
      },
    );
    return completer.future;
  }

  Future<void> loadForm(Completer<void> completer) async {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        // Present the form
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (formError) {
              if (formError != null) {
                loadForm(completer);
              } else {
                completer.complete();
              }
            },
          );
        } else if (status == ConsentStatus.obtained) {
          // if use do not consent then show again
          final canShowAd = await checkUserAccept();
          if (!canShowAd) {
            consentForm.show(
              (formError) {
                if (formError != null) {
                  loadForm(completer);
                } else {
                  completer.complete();
                }
              },
            );
          } else {
            completer.complete();
          }
        } else {
          completer.complete();
        }
      },
      (FormError formError) {
        debugPrint(formError.message);
        completer.complete();
      },
    );
  }

  Future<bool> checkUserAccept() async {
    try {
      final info = (await IabtcfConsentInfo.instance.currentConsentInfo())!
          as ConsentInfo;
      if (info.purposeConsents
          .contains(DataUsagePurpose.storeAndAccessInformationOnADevice)) {
        if (info.purposeLegitimateInterests
                .contains(DataUsagePurpose.selectBasicAds) &&
            info.purposeLegitimateInterests
                .contains(DataUsagePurpose.measureAdPerformance) &&
            info.purposeLegitimateInterests.contains(DataUsagePurpose
                .applyMarketResearchToGenerateAudienceInsights) &&
            info.purposeLegitimateInterests
                .contains(DataUsagePurpose.developAndImproveProducts)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // if exception, assume that user consent...
      return true;
    }
  }
}
