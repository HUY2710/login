import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_button_position.dart';
import '../loading/large_ad_loading.dart';

class LargeNativeAd extends StatelessWidget {
  const LargeNativeAd({
    super.key,
    required this.unitId,
    this.buttonPosition = AdButtonPosition.bottom,
    this.unitIdHigh,
  });

  final String unitId;
  final String? unitIdHigh;
  final AdButtonPosition buttonPosition;

  @override
  Widget build(BuildContext context) {
    final factoryId = switch (buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topLargeNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomLargeNativeFactory,
    };
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        color: Colors.white,
        child: unitIdHigh != null
            ? EasyNativeAdHigh(
                factoryId: factoryId,
                adId: unitId,
                adIdHigh: unitIdHigh!,
                height: 270,
                loadingWidget: LargeAdLoading(
                  buttonPosition: buttonPosition,
                ),
              )
            : EasyNativeAd(
                factoryId: factoryId,
                adId: unitId,
                height: 260,
                loadingWidget: LargeAdLoading(
                  buttonPosition: buttonPosition,
                ),
              ),
      ),
    );
  }
}
