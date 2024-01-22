import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class FloatRightAppBar extends StatefulWidget {
  const FloatRightAppBar({super.key});

  @override
  State<FloatRightAppBar> createState() => _FloatRightAppBarState();
}

class _FloatRightAppBarState extends State<FloatRightAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildItem(() {}, Assets.icons.icSetting.path),
        16.verticalSpace,
        buildItem(() {}, Assets.icons.icLocation.path),
        16.verticalSpace,
        buildItem(() {}, Assets.icons.icMap.path),
      ],
    );
  }

  Widget buildItem(VoidCallback onTap, String pathIc) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.r),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff42474C).withOpacity(0.3),
              blurRadius: 17,
            )
          ]),
      child: SvgPicture.asset(
        pathIc,
        height: 20.r,
        width: 20.r,
      ),
    );
  }
}
