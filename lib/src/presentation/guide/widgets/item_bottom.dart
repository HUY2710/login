import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constants/app_constants.dart';

class ItemBottomGuide extends StatelessWidget {
  const ItemBottomGuide({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.r,
      width: 48.r,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
        gradient: const LinearGradient(colors: [
          Color(0xffB67DFF),
          Color(0xff7B3EFF),
        ]),
      ),
      child: SvgPicture.asset(
        path,
        height: 22.r,
        width: 22.r,
      ),
    );
  }
}
