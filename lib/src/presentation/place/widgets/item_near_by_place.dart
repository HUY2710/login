import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class ItemNearByPlace extends StatelessWidget {
  const ItemNearByPlace(
      {super.key, required this.namePlace, required this.isSelect});
  final String namePlace;
  final bool isSelect;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.icons.icLocation.path),
        12.horizontalSpace,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                namePlace,
                style: TextStyle(
                  color: const Color(0xff343434),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        if (isSelect) SvgPicture.asset(Assets.icons.icChecked.path),
      ],
    );
  }
}
