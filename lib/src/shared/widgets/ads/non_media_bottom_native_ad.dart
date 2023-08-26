import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../service/app_ad_id_manager.dart';
import 'non_media_loading.dart';

class NonMediaBottomNativeAd extends StatelessWidget {
  const NonMediaBottomNativeAd({super.key, required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10).h,
      child: EasyNativeAd(
        factoryId: getIt<AppAdIdManager>().nonMediaBottomNativeFactory,
        adId: unitId,
        height: 130,
        loadingWidget: const NonMediaLoading(),
      ),
    );
  }
}
