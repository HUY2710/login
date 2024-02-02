import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

class ContentPageWidget extends StatelessWidget {
  const ContentPageWidget({
    super.key,
    required this.image,
    required this.title,
  });

  final AssetGenImage image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD2B0FF),
                  Color(0xFFAB7BFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: image.image(
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Assets.images.onboarding.onboardingBg.image(
                    height: 35.h,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 120.h,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF343434),
                  fontSize: 20.sp,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
