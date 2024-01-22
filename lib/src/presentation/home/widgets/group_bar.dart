import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/containers/border_container.dart';
import '../../../shared/widgets/containers/linear_container.dart';

class GroupBar extends StatelessWidget {
  const GroupBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialogGroup(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14.r,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: const Text(
                'My Planet',
                style: TextStyle(color: Color(0xff8E52FF)),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded)
          ],
        ),
      ),
    );
  }

  void showDialogGroup(BuildContext context) {
    showDialog(
        barrierColor: Colors.white.withOpacity(0.1),
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width - 32.w,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    50.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: LinearContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                              ),
                              child: Text(
                                'New Group',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: BorderContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                              ),
                              child: Text(
                                'Join Group',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff8E52FF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    50.verticalSpace,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
