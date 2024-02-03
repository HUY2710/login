// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomItemSetting extends StatelessWidget {
  const CustomItemSetting({
    super.key,
    this.child,
    this.multiChild,
    this.onTap,
    this.padding,
  }) : assert(child != null && multiChild == null ||
            child == null && multiChild != null);

  final Widget? child;
  final Widget? multiChild;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF42474C).withOpacity(0.15),
              blurRadius: 18,
            ),
          ],
        ),
        child: child ?? multiChild,
      ),
    );
  }
}
