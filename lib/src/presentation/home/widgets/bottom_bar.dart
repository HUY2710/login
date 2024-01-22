import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildItem(Assets.icons.icPeople.path),
        23.horizontalSpace,
        //avatar
        23.horizontalSpace,
        buildItem(Assets.icons.icMessage.path)
      ],
    );
  }

  Widget buildItem(String path, {bool? avatar}) {
    return Container(
      height: 48.r,
      width: 48.r,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
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
