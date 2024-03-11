import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/constants/app_text_style.dart';
import '../../../shared/extension/context_extension.dart';

class ButtonPrimaryWidget extends StatelessWidget {
  const ButtonPrimaryWidget({
    super.key,
    required this.title,
    this.isLoading = false,
    this.onTap,
    this.backgroundColor,
    this.height,
    this.styleTitle,
    this.widthIndicator,
    this.heightIndicator,
    this.borderRadius,
  });
  final String title;
  final Function()? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final double? height;
  final TextStyle? styleTitle;
  final double? widthIndicator;
  final double? heightIndicator;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height ?? 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.primary,
          borderRadius: borderRadius ??
              BorderRadius.all(
                Radius.circular(5.r),
              ),
        ),
        child: isLoading
            ? SizedBox(
                width: widthIndicator ?? 20.w,
                height: widthIndicator ?? 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: styleTitle ?? AppTextStyle.s14w600,
              ),
      ),
    );
  }
}
