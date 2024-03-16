import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../shared/helpers/time_helper.dart';

class VisibilityMemberMap extends StatelessWidget {
  const VisibilityMemberMap(
      {super.key, required this.users, required this.moveToUser});
  final List<StoreUser> users;
  final Function(LatLng location) moveToUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.r),
        ),
        color: Colors.white,
      ),
      child: ListView.separated(
        itemCount: users.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemBuilder: (context, index) {
          final user = users[index];
          return GestureDetector(
            onTap: () {
              moveToUser(LatLng(users[index].location?.lat ?? 0,
                  users[index].location?.lng ?? 0));
            },
            child: SizedBox(
              width: 62.r,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.sosStore != null &&
                      user.sosStore!.sos &&
                      !TimerHelper.checkTimeDifferenceCurrent(
                        user.sosStore?.sosTimeLimit ?? DateTime.now(),
                        argMinute: 10,
                      ))
                    RippleAnimation(
                      color: Colors.red,
                      delay: const Duration(milliseconds: 150),
                      repeat: true,
                      minRadius: 10,
                      ripplesCount: 16,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundImage:
                            Image.asset(users[index].avatarUrl).image,
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 16.r,
                      backgroundImage:
                          Image.asset(users[index].avatarUrl).image,
                    ),
                  6.verticalSpace,
                  Text(
                    users[index].userName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
      ),
    );
  }
}
