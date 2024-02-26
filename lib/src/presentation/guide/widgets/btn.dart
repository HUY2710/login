import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BtnGuide extends StatelessWidget {
  const BtnGuide(
      {super.key,
      required this.title,
      this.backgroundColor,
      this.secondBackgroundColor,
      this.textColor,
      required this.onTap,
      this.heightBtn,
      this.widthBtn,
      this.paddingVertical});
  final String title;

  final LinearGradient? backgroundColor;
  final LinearGradient? secondBackgroundColor;

  final Color? textColor;

  final VoidCallback onTap;
  final double? heightBtn;
  final double? widthBtn;
  final double? paddingVertical;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: heightBtn,
        width: widthBtn,
        padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 6.h),
        decoration: BoxDecoration(
          gradient: backgroundColor ??
              const LinearGradient(
                colors: [
                  Color(0xFFB67DFF),
                  Color(0xFF7B3EFF),
                ],
              ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
