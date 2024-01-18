import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_button_position.dart';
import '../loading/large_ad_loading.dart';

class LargeNativeAd extends StatelessWidget {
  const LargeNativeAd({
    super.key,
    this.unitId,
    this.buttonPosition,
    this.unitIdHigh,
    this.controller,
  });

  final String? unitId;
  final String? unitIdHigh;
  final AdButtonPosition? buttonPosition;
  final NativeAdController? controller;

  @override
  Widget build(BuildContext context) {
    final factoryId = switch (buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topLargeNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomLargeNativeFactory,
      _ => null
    };
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        color: Colors.white,
        child: EasyNativeAd(
          factoryId: factoryId,
          adId: unitId,
          highId: unitIdHigh,
          height: 270,
          controller: controller,
          loadingWidget: LargeAdLoading(
            buttonPosition: buttonPosition,
          ),
        ),
      ),
    );
  }
}
