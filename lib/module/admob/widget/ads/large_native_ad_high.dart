import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_button_position.dart';
import '../loading/large_ad_loading.dart';

class LargeNativeAdHigh extends StatelessWidget {
  const LargeNativeAdHigh({
    super.key,
    required this.unitId,
    required this.unitIdHigh,
    this.buttonPosition = AdButtonPosition.top,
  });

  final String unitId;
  final String unitIdHigh;
  final AdButtonPosition buttonPosition;

  @override
  Widget build(BuildContext context) {
    final factoryId = switch (buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topSmallNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomSmallNativeFactory,
    };
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: Colors.white,
      child: EasyNativeAdHigh(
        factoryId: factoryId,
        adId: unitId,
        adIdHigh: unitIdHigh,
        height: 270,
        loadingWidget: const LargeAdLoading(),
      ),
    );
  }
}
