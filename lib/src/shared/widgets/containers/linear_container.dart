import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinearContainer extends StatelessWidget {
  const LinearContainer({
    super.key,
    required this.child,
    this.radius,
    this.alignment,
  });
  final Widget child;
  final double? radius;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffB67DFF),
            Color(0xff7B3EFF),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(radius?.r ?? 15.r),
        ),
      ),
      child: child,
    );
  }
}
