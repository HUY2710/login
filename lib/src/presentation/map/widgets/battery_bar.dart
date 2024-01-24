import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatteryBar extends StatelessWidget {
  const BatteryBar({
    super.key,
    required this.batteryLevel,
    required this.color,
  });

  final int batteryLevel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20.r,
          width: 20.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        10.horizontalSpace,
        Container(
          width: 50.h,
          height: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(width: 5, color: const Color(0xffBCB8FF)),
          ),
          padding: EdgeInsets.all(2.r),
          child: SizedBox(
            child: FractionallySizedBox(
              widthFactor: batteryLevel / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff343434),
                  borderRadius: BorderRadius.all(Radius.circular(2.r)),
                ),
              ),
            ),
          ),
        ),
        10.horizontalSpace,
        Text(
          '$batteryLevel%',
          style: TextStyle(
            color: const Color(0xff343434),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
