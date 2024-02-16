import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';
import '../../onboarding/widgets/app_button.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    super.key,
    required this.title,
    required this.confirmTap,
    required this.confirmText,
    required this.subTitle,
    required this.child,
  });

  final String title;
  final String subTitle;
  final VoidCallback confirmTap;
  final Widget child;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.6),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.black34,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          12.verticalSpace,
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.color6C6C6C,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          child,
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: AppButton(
              title: confirmText,
              onTap: confirmTap,
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
