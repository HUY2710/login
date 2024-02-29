import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_constants.dart';

class ItemRightGuide extends StatelessWidget {
  const ItemRightGuide({super.key, required this.pathIc});
  final String pathIc;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff42474C).withOpacity(0.3),
            blurRadius: 17,
          )
        ],
      ),
      child: SvgPicture.asset(
        pathIc,
        height: 20.r,
        width: 20.r,
      ),
    );
  }
}
