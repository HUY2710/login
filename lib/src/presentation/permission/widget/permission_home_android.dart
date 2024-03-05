import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../onboarding/widgets/app_button.dart';

class PermissionHomeAndroid extends StatelessWidget {
  const PermissionHomeAndroid({
    super.key,
    required this.confirmTap,
    this.backgroundColor,
    required this.confirmText,
  });

  final VoidCallback confirmTap;
  final String confirmText;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.95),
      elevation: 0.0,
      contentPadding: EdgeInsets.symmetric(vertical: 20.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              context.l10n.titlePermissionHomeAndroid,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.black34,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              context.l10n.subLocation,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.black34,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          12.verticalSpace,
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 36.w),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffABABAB).withOpacity(0.3),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        context.l10n.locationPermission,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.black34,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Divider(color: Colors.black.withOpacity(0.05)),
                    70.verticalSpace,
                    Row(
                      children: [
                        16.horizontalSpace,
                        const Icon(
                          Icons.radio_button_checked,
                          color: Color(0xff9F9F9F),
                        ),
                        8.horizontalSpace,
                        Flexible(
                          child: Text(
                            context.l10n.allowUseApp,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xff9F9F9F),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Divider(color: Colors.black.withOpacity(0.05)),
                    4.verticalSpace,
                    Row(
                      children: [
                        16.horizontalSpace,
                        const Icon(
                          Icons.radio_button_checked,
                          color: Color(0xff9F9F9F),
                        ),
                        8.horizontalSpace,
                        Text(
                          context.l10n.askEveryTime,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff9F9F9F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Divider(color: Colors.black.withOpacity(0.05)),
                    4.verticalSpace,
                    Row(
                      children: [
                        16.horizontalSpace,
                        const Icon(
                          Icons.radio_button_checked,
                          color: Color(0xff9F9F9F),
                        ),
                        8.horizontalSpace,
                        Text(
                          context.l10n.deny,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff9F9F9F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 60.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.25))
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      16.horizontalSpace,
                      const Icon(
                        Icons.radio_button_checked,
                        color: Color(0xff7B3EFF),
                      ),
                      8.horizontalSpace,
                      Text(
                        context.l10n.allowAllTheTime,
                        style: TextStyle(
                            color: const Color(0xff8E52FF),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: AppButton(
              title: confirmText,
              onTap: confirmTap,
            ),
          ),
        ],
      ),
    );
  }
}
