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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12).r,
      child: Container(
        height: 40.r,
        width: 120.r,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            color: color,
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: batteryLevel / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                color: color,
              ),
            ),
            Positioned.fill(
              child: Align(
                child: Text(
                  '$batteryLevel%',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
