import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_circle_avatar.dart';
import '../../../../../shared/widgets/my_drag.dart';

class CheckInHistory extends StatelessWidget {
  const CheckInHistory({super.key, required this.idUser});
  final String idUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 28.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                color: Colors.red.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: BorderCircleAvatar(
              path: Assets.images.avatars.female.avatar1.path,
            ),
          ),
        ],
      ),
    );
  }
}
