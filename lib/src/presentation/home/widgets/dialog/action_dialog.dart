import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/extension/context_extension.dart';

class ActionDialog extends StatelessWidget {
  const ActionDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.confirmTap,
    this.cancel,
    required this.confirmText,
    this.cancelText,
  });
  final String title;
  final String subTitle;
  final String confirmText;
  final String? cancelText;
  final VoidCallback confirmTap;
  final VoidCallback? cancel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff6C6C6C),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          24.verticalSpace,
          const Divider(
            color: Color(0xffEAEAEA),
          ),
          GestureDetector(
            onTap: confirmTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    confirmText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: Color(0xffEAEAEA),
          ),
          10.verticalSpace,
          GestureDetector(
            onTap: () {
              context.popRoute();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cancelText ?? context.l10n.cancel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffB67DFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
