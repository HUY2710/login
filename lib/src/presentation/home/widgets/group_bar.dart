import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/containers/border_container.dart';
import '../../../shared/widgets/containers/linear_container.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import 'bottom_sheet/create_group_bottom_sheet.dart';
import 'group_item.dart';
import 'modal_bottom/join_group/join_group.dart';

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
        barrierColor: Colors.black.withOpacity(0.4),
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: const Alignment(0, -0.7),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            elevation: 0.0,
            content: SizedBox(
              width: MediaQuery.of(context).size.width - 32.w,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 50.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await context.popRoute();
                              if (context.mounted) {
                                await showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: const BottomSheetCreateGroup(),
                                      );
                                    });
                              }
                            },
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
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: CustomInkWell(
                            onTap: () async {
                              await context.popRoute();
                              if (context.mounted) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        const JoinGroupWidget());
                              }
                            },
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
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    SizedBox(
                      height: 1.sh * 0.26,
                      child: ListView.separated(
                        itemCount: 3,
                        separatorBuilder: (context, index) => const Divider(
                          color: Color(0xffEAEAEA),
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          return GroupItem(isAdmin: index == 0, members: 5);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
