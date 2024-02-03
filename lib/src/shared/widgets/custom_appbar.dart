// ignore_for_file: public_member_api_docs, sort_constructors_first
//implement
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../extension/context_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.style,
    this.textColor,
    this.colorLeading,
  });
  final String? title;
  final TextStyle? style;
  final Color? textColor;
  final Color? colorLeading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 56.h),
      child: SizedBox(
        height: 30.h,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                context.popRoute();
              },
              child: Assets.icons.icBack.svg(
                height: 28.h,
                colorFilter: ColorFilter.mode(
                  colorLeading ?? context.colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (title != null)
              Align(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: textColor ?? Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
