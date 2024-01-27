import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    super.key,
    required this.child,
    this.radius,
    this.colorBackGround,
    this.alignment,
  });
  final Widget child;
  final double? radius;
  final Color? colorBackGround;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      width: radius ?? 28.r,
      height: radius ?? 28.r,
      decoration: BoxDecoration(color: colorBackGround, shape: BoxShape.circle),
      child: child,
    );
  }
}
