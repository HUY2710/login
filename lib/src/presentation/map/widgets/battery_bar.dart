import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatteryBar extends StatelessWidget {
  const BatteryBar({
    super.key,
    required this.batteryLevel,
    required this.color,
    required this.online,
    this.stylePercent,
    this.radiusActive,
    this.heightBattery,
    this.widthBattery,
    this.borderWidth,
    this.borderRadius,
  });

  final int batteryLevel;
  final Color color;
  final bool online;
  final TextStyle? stylePercent;
  final double? radiusActive;
  final double? heightBattery;
  final double? widthBattery;
  final double? borderWidth;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: radiusActive ?? 20.r,
          width: radiusActive ?? 20.r,
          decoration: BoxDecoration(
            color: online ? const Color(0xff19E04B) : const Color(0xffFFDF57),
            shape: BoxShape.circle,
          ),
        ),
        4.horizontalSpace,
        Container(
          width: widthBattery?.w ?? 50.w,
          height: heightBattery?.h ?? 30.h,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 10.r)),
            border: Border.all(
                width: borderWidth ?? 5, color: const Color(0xff343434)),
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
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 10.r)),
          ),
        ),
        4.horizontalSpace,
        Text(
          '$batteryLevel%',
          style: stylePercent ??
              TextStyle(
                color: const Color(0xff343434),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
        )
      ],
    );
  }
}
