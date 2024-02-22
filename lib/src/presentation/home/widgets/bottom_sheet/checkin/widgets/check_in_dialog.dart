import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../gen/gens.dart';

class CheckInDialog extends StatelessWidget {
  const CheckInDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
            EdgeInsets.only(top: 25.h, bottom: 16.h, left: 17.w, right: 17.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r), color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 2.4.r,
              child: Assets.lottie.checkIn.lottie(
                width: 106.w,
                height: 101.h,
              ),
            ),
            Text(
              'Check in completed!',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
