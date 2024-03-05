import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../onboarding/widgets/app_button.dart';

class GuideFirstPermissionAndroid extends StatelessWidget {
  const GuideFirstPermissionAndroid({
    super.key,
    required this.title,
    required this.confirmTap,
    required this.confirmText,
    required this.subTitle,
    this.backgroundColor,
  });

  final String title;
  final String subTitle;
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
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.black34,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.color6C6C6C,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          16.verticalSpace,
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
                        context.l10n.allowGroupSharing,
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
                    14.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  child:
                                      Image.asset(Assets.images.precise.path),
                                ),
                                Text(
                                  context.l10n.precise,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundImage: Image.asset(
                                          Assets.images.approximate.path)
                                      .image,
                                ),
                                Text(
                                  context.l10n.approximate,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    Divider(color: Colors.black.withOpacity(0.05)),
                    64.verticalSpace,
                    Text(
                      context.l10n.onlyThisTime,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff9F9F9F),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.verticalSpace,
                    Divider(color: Colors.black.withOpacity(0.05)),
                    4.verticalSpace,
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
              ),
              Positioned(
                bottom: 80.h,
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
                  child: Center(
                    child: Text(
                      context.l10n.whileUseApp,
                      style: TextStyle(
                          color: const Color(0xff8E52FF),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp),
                    ),
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
              widthBtn: 200.w,
            ),
          ),
        ],
      ),
    );
  }
}
