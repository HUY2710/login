import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.colorBg,
    this.alignment,
    this.radius,
  });
  final Widget child;
  final double? radius;
  final Color? colorBg;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorBg,
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 16.r),
        ),
      ),
      child: child,
    );
  }
}
