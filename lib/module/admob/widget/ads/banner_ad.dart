import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../src/gen/colors.gen.dart';
import '../../../../src/shared/widgets/my_placeholder.dart';

class MyBannerAd extends StatelessWidget {
  const MyBannerAd({
    super.key,
    required this.id,
    this.isCollapsible = false,
  });

  final String id;
  final bool isCollapsible;

  @override
  Widget build(BuildContext context) {
    return EasyBannerAd(
      adId: id,
      isCollapsible: isCollapsible,
      loadingWidget: _buildLoadingAd(),
      borderBanner: const Border(
        top: BorderSide(
          width: 2,
          color: MyColors.primary,
        ),
      ),
    );
  }

  Widget _buildLoadingAd() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8).r,
        child: Row(
          children: [
            MyPlaceholder(
              width: 40.r,
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyPlaceholder(
                    height: 12.h,
                  ),
                  5.verticalSpace,
                  MyPlaceholder(
                    width: 100.w,
                    height: 12.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
