import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/custom_container.dart';
import '../../onboarding/widgets/app_button.dart';

class GuideFirstPermission extends StatelessWidget {
  const GuideFirstPermission({
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
      backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.75),
      elevation: 0.0,
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
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.color6C6C6C,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          36.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 213.w,
                    height: 166.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
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
                        Text(
                          context.l10n.allowGroupSharingLocation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyColors.black34,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        14.verticalSpace,
                        Text(
                          context.l10n.allow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff9F9F9F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        4.verticalSpace,
                        const Expanded(child: SizedBox.shrink()),
                        4.verticalSpace,
                        Text(
                          context.l10n.dontAllow,
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
                ),
                Positioned(
                  bottom: 40.h,
                  left: 0,
                  right: 0,
                  child: CustomContainer(
                    width: 270.w,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    colorBg: Colors.white,
                    child: Center(
                      child: Text(
                        context.l10n.allowUseApp,
                        style: const TextStyle(
                          color: Color(0xff8E52FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: AppButton(
              title: confirmText,
              onTap: confirmTap,
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
