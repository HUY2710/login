import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_circle_avatar.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../map/widgets/battery_bar.dart';

class HistoryPlace extends StatelessWidget {
  const HistoryPlace({super.key, required this.idUser});
  final String idUser;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 28.h),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                color: Colors.white.withOpacity(0.6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffABABAB).withOpacity(0.3),
                  )
                ]),
            child: Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Column(
                children: [
                  const Center(
                    child: MyDrag(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 95.w),
                        child: const Text('User Name'),
                      )
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 6.w),
                        child: BatteryBar(
                          batteryLevel: 60,
                          color: Colors.red,
                          online: true,
                          radiusActive: 8.r,
                          heightBattery: 16,
                          widthBattery: 24,
                          borderWidth: 2,
                          borderRadius: 4.r,
                          stylePercent: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      SvgPicture.asset(Assets.icons.icShareLocation.path),
                      2.horizontalSpace,
                      const Expanded(
                        child: Text(
                          'Address 1111111111111111111111111111sadfsdaf sadfgsdfsdfsd sssssssssssssssssssssssssssss 1',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 123.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BorderCircleAvatar(
                path: Assets.images.avatars.female.avatar1.path,
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
