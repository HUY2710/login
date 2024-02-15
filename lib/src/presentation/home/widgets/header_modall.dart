import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/helpers/gradient_background.dart';
import '../../../shared/widgets/custom_inkwell.dart';

class HeaderModal extends StatelessWidget {
  const HeaderModal(
      {super.key,
      required this.title,
      this.icon,
      required this.onTap,
      required this.textIcon,
      required this.isAdmin});

  final String title;
  final SvgGenImage? icon;
  final Function onTap;
  final String textIcon;
  final bool isAdmin;
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
        if (isAdmin)
          CustomInkWell(
            onTap: () => onTap(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99.r),
                  gradient: gradientBackground),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon == null)
                    const SizedBox()
                  else
                    icon!.svg(width: 20.w),
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
