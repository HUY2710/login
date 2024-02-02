// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    this.isEnable = true,
    this.isShowIcon = false,
    this.backgroundColor,
    this.secondBackgroundColor,
    this.textColor,
    this.textSecondColor,
    this.iconColor,
    this.iconSecondColor,
    required this.onTap,
  });

  final String title;

  final bool isEnable;
  final bool isShowIcon;

  final LinearGradient? backgroundColor;
  final LinearGradient? secondBackgroundColor;

  final Color? textColor;
  final Color? textSecondColor;

  final Color? iconColor;
  final Color? iconSecondColor;

  final VoidCallback onTap;

  Color? _getTextColor() {
    return isEnable ? textColor : textSecondColor;
  }

  Color? _getIconColor() {
    return isEnable ? textColor : textSecondColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onTap : null,
      child: Container(
        height: 56.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: isEnable
              ? (backgroundColor ??
                  const LinearGradient(
                    colors: [
                      Color(0xFFB67DFF),
                      Color(0xFF7B3EFF),
                    ],
                  ))
              : (secondBackgroundColor ??
                  const LinearGradient(
                    colors: [
                      Color(0xFFD9C0FF),
                      Color(0xFFD9C0FF),
                    ],
                  )),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  title,
                  style: TextStyle(
                    color: _getTextColor() ?? Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            if (isShowIcon)
              Positioned(
                right: 16.w,
                child: Assets.icons.icForward.svg(
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    _getIconColor() ?? Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
