import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/gens.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/widgets/containers/shadow_container.dart';

class ProGuide extends StatelessWidget {
  const ProGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      width: 90.r,
      height: 40.r,
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
      child: Row(
        children: [
          Assets.icons.premium.icPremiumSvg.svg(),
          8.horizontalSpace,
          Expanded(
            child: Text(
              'PRO',
              style: TextStyle(
                  color: const Color(0xff8E52FF),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
