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
    this.buttonPosition = AdButtonPosition.top,
  });

  final String unitId;
  final AdButtonPosition buttonPosition;

  @override
  Widget build(BuildContext context) {
    final factoryId = switch (buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topLargeNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomLargeNativeFactory,
    };
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: EasyNativeAd(
        factoryId: factoryId,
        adId: unitId,
        height: 270,
        loadingWidget: const LargeAdLoading(),
      ),
    );
  }
}
