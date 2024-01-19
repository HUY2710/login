import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../src/shared/widgets/my_placeholder.dart';
import '../../enum/ad_button_position.dart';

class LargeAdLoading extends StatelessWidget {
  const LargeAdLoading({
    super.key,
    this.buttonPosition,
  });

  final AdButtonPosition? buttonPosition;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (buttonPosition == AdButtonPosition.top)
              MyPlaceholder(
                width: 1.sw,
                height: 48,
              ),
            if (buttonPosition == AdButtonPosition.top)
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
            const SizedBox(
              height: 10,
            ),
            MyPlaceholder(
              width: 0.7.sw,
              height: 120,
            ),
            if (buttonPosition == AdButtonPosition.bottom &&
                buttonPosition == null)
              const SizedBox(
                height: 5,
              ),
            if (buttonPosition == AdButtonPosition.bottom &&
                buttonPosition == null)
              MyPlaceholder(
                width: 1.sw,
                height: 48,
              ),
          ],
        ),
      ),
    );
  }
}
