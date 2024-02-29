import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/gens.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/shadow_container.dart';

class CheckInGuide extends StatelessWidget {
  const CheckInGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      // maxWidth: MediaQuery.sizeOf(context).width - 80.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.icons.icCheckin.path),
          12.horizontalSpace,
          Text(
            context.l10n.checkIn,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: const Color(0xff8E52FF),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
