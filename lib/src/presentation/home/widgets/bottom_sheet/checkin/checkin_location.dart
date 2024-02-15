import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/widgets/my_drag.dart';

class CheckInLocation extends StatelessWidget {
  const CheckInLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDrag(),
          Row(),
        ],
      ),
    );
  }
}
