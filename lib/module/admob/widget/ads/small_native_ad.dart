import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../src/config/di/di.dart';
import '../../app_ad_id_manager.dart';
import '../../../../src/shared/widgets/my_placeholder.dart';

class SmallNativeAd extends StatelessWidget {
  const SmallNativeAd({super.key, required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10).h,
      child: EasyNativeAd(
        factoryId: getIt<AppAdIdManager>().smallNativeFactory,
        adId: unitId,
        height: 130,
        loadingWidget: _buildLoadingWidget(),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MyPlaceholder(
              width: 1.sw,
              height: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                MyPlaceholder(
                  width: 42,
                  height: 42,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    children: [
                      MyPlaceholder(
                        width: double.infinity,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      MyPlaceholder(
                        width: double.infinity,
                        height: 18,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
