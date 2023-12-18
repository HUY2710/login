import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_button_position.dart';
import '../loading/small_ad_loading.dart';

class SmallNativeAd extends StatelessWidget {
  const SmallNativeAd({
    super.key,
    required this.unitId,
    this.buttonPosition = AdButtonPosition.bottom,
  });

  final String unitId;
  final AdButtonPosition buttonPosition;

  @override
  Widget build(BuildContext context) {
    final factoryId = switch (buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topSmallNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomSmallNativeFactory,
    };
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: EasyNativeAd(
        factoryId: factoryId,
        adId: unitId,
        height: 140,
        loadingWidget: SmallAdLoading(
          buttonPosition: buttonPosition,
        ),
      ),
    );
  }
}
