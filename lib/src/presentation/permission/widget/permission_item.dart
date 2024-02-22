import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/gens.dart';

class PermissionItem extends StatelessWidget {
  const PermissionItem(
      {super.key,
      required this.pathIc,
      required this.title,
      required this.subTitle,
      required this.colorDisable});
  final String pathIc;
  final String title;
  final String subTitle;
  final Color? colorDisable;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              pathIc,
              width: 20.r,
              height: 20.r,
            ),
            8.horizontalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: colorDisable ?? MyColors.black34,
              ),
            )
          ],
        ),
        5.verticalSpace,
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: colorDisable ?? MyColors.black34,
          ),
        )
      ],
    );
  }
}
