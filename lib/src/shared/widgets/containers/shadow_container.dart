import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.colorBg,
    this.colorShadow,
    this.blurRadius,
    this.maxWidth,
    this.width,
    this.height,
    this.margin,
    this.opacityColor,
  });
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  final Color? colorBg;
  final Color? colorShadow;
  final double? blurRadius;
  final double? maxWidth;
  final double? width;
  final double? height;
  final double? opacityColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      decoration: BoxDecoration(
        color: colorBg ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(40.r)),
        boxShadow: [
          BoxShadow(
            color: colorShadow ??
                const Color(0xff42474C).withOpacity(opacityColor ?? 0.3),
            blurRadius: blurRadius ?? 16,
          ),
        ],
      ),
      child: child,
    );
  }
}
