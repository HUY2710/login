import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/custom_container.dart';
import '../../onboarding/widgets/app_button.dart';

class PermissionHomeIOS extends StatelessWidget {
  const PermissionHomeIOS({
    super.key,
    required this.confirmTap,
    this.confirmText,
    this.backgroundColor,
  });

  final VoidCallback confirmTap;
  final String? confirmText;
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
              context.l10n.permissionsGreate,
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
            context.l10n.permissionsGreateSub,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.color6C6C6C,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          36.verticalSpace,
          Stack(
            children: [
              Center(
                child: Container(
                  width: 213.w,
                  height: 166.h,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
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
                    children: [
                      Text(
                        context.l10n.allowLocationPermission,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.black34,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      14.verticalSpace,
                      Text(
                        context.l10n.justKeepIt,
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
                bottom: 14.h,
                left: 0,
                right: 0,
                child: CustomContainer(
                  width: 260.w,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  colorBg: Colors.white,
                  child: Center(
                    child: Text(
                      context.l10n.changeToAlwaysAllow,
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
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: AppButton(
              title: confirmText ?? context.l10n.change,
              onTap: confirmTap,
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
