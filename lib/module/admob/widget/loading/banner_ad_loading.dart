import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../src/shared/widgets/my_placeholder.dart';

class BannerAdLoading extends StatelessWidget {
  const BannerAdLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            MyPlaceholder(
              width: 36,
              height: 36,
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyPlaceholder(
                    height: 12,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  MyPlaceholder(
                    width: 100.w,
                    height: 12,
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
