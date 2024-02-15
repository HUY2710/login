import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatteryBar extends StatelessWidget {
  const BatteryBar({
    super.key,
    required this.batteryLevel,
    required this.color,
    required this.online,
  });

  final int batteryLevel;
  final Color color;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20.r,
          width: 20.r,
          decoration: BoxDecoration(
            color: online ? const Color(0xff19E04B) : const Color(0xffFFDF57),
            shape: BoxShape.circle,
          ),
        ),
        10.horizontalSpace,
        Container(
          width: 50.h,
          height: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(width: 5, color: const Color(0xff343434)),
          ),
          padding: EdgeInsets.all(2.r),
          child: SizedBox(
            child: FractionallySizedBox(
              widthFactor: batteryLevel / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(Radius.circular(2.r)),
                ),
              ),
            ),
          ),
        ),
        2.horizontalSpace,
        Container(
          width: 4.w,
          height: 12.h,
          color: color,
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
