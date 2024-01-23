import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

class HeaderModal extends StatelessWidget {
  const HeaderModal(
      {super.key,
      required this.title,
      this.icon,
      required this.onTap,
      required this.textIcon});

  final String title;
  final SvgGenImage? icon;
  final Function onTap;
  final String textIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp,
              color: const Color(0xff343434),
              fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: () {
            print('asdassdasasdasdasdas');
            onTap();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFB67DFF), Color(0xFF7B3EFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                transform: GradientRotation(274 * (pi / 180)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon == null) const SizedBox() else icon!.svg(width: 20.w),
                8.horizontalSpace,
                Text(
                  textIcon,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
