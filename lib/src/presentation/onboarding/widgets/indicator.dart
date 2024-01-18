import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget indicator(BuildContext context, bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 8.r,
    width: isActive ? 24.r : 8.r,
    margin: EdgeInsets.only(right: 5.w),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5.r),
    ),
  );
}

//Create the indicator list
List<Widget> buildIndicator(
    BuildContext context, int length, int currentIndex) {
  final List<Widget> indicators = <Widget>[];

  for (int i = 0; i < length; i++) {
    if (currentIndex == i) {
      indicators.add(indicator(context, true));
    } else {
      indicators.add(indicator(context, false));
    }
  }
  return indicators;
}
