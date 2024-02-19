import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/models/store_user/store_user.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/containers/shadow_container.dart';
import '../../../../../shared/widgets/custom_circle_avatar.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../direction/direction_map.dart';
import '../../../../map/widgets/battery_bar.dart';
import '../show_bottom_sheet_home.dart';

class HistoryPlace extends StatelessWidget {
  const HistoryPlace({super.key, required this.idUser, required this.user});
  final String idUser;
  final StoreUser user;
  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xff19E04B);
    final int battery = user.batteryLevel;

    if (battery <= 20) {
      color = Colors.red;
    }
    if (battery > 20 && battery <= 30) {
      color = const Color(0xffFFDF57);
    }

    if (battery > 30) {
      color = const Color(0xff0FEC47);
    }
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 95.w),
                        child: Text(user.userName),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.popRoute().then(
                                (value) => showAppModalBottomSheet(
                                  context: context,
                                  builder: (context) => DirectionMap(
                                    user: user,
                                  ),
                                ),
                              );
                        },
                        child: ShadowContainer(
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          child: const Text('Get routes'),
                        ),
                      ),
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
                          batteryLevel: user.batteryLevel,
                          color: color,
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
                      Expanded(
                        child: Text(
                          user.location?.address ?? '',
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
                path: user.avatarUrl,
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
