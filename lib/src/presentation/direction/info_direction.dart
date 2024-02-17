import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/widgets/my_drag.dart';

class InfoDirection extends StatelessWidget {
  const InfoDirection(
      {super.key, required this.distance, required this.duration});
  final double distance;
  final double duration;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          20.verticalSpace,
          Text('Khoảng cách: $distance'),
          Text('Thời gian: $distance'),
        ],
      ),
    );
  }
}
