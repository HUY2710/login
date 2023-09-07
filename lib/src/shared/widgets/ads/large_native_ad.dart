import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

import '../../../config/di/di.dart';
import '../../../service/app_ad_id_manager.dart';
import 'large_ad_loading.dart';

class LargeNativeAd extends StatelessWidget {
  const LargeNativeAd({super.key, required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: EasyNativeAd(
        factoryId: getIt<AppAdIdManager>().largeNativeFactory,
        adId: unitId,
        height: 272,
        loadingWidget: const LargeAdLoading(),
      ),
    );
  }
}
