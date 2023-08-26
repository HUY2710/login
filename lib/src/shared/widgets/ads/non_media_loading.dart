import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../my_placeholder.dart';

class NonMediaLoading extends StatelessWidget {
  const NonMediaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              height: 5,
            ),
            MyPlaceholder(
              width: 1.sw,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
