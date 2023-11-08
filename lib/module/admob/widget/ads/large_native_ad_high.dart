import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../loading/large_ad_loading.dart';


class LargeNativeAdHigh extends StatelessWidget {
  const LargeNativeAdHigh({
    super.key,
    required this.unitId,
    required this.unitIdHigh,
  });

  final String unitId;
  final String unitIdHigh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: EasyNativeAdHigh(
        factoryId: getIt<AppAdIdManager>().largeNativeFactory,
        adId: unitId,
        adIdHigh: unitIdHigh,
        height: 272,
        loadingWidget: const LargeAdLoading(),
      ),
    );
  }
}
