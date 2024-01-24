import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrag extends StatelessWidget {
  const MyDrag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        color: const Color(0xffE2E2E2),
      ),
    );
  }
}
