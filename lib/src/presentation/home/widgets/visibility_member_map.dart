import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/store_user/store_user.dart';

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
                  CircleAvatar(
                    radius: 16.r,
                    backgroundImage: Image.asset(users[index].avatarUrl).image,
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
