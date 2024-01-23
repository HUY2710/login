import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderContainer extends StatelessWidget {
  const BorderContainer({
    super.key,
    required this.child,
    this.radius,
    this.alignment,
    this.colorBorder,
    this.colorBackGround,
  });

  final Widget child;
  final double? radius;
  final Alignment? alignment;
  final Color? colorBorder;
  final Color? colorBackGround;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        color: colorBackGround,
        border: Border.all(
          color: colorBorder ?? const Color(0xff7B3EFF),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(radius?.r ?? 15.r),
        ),
      ),
      child: child,
    );
  }
}
