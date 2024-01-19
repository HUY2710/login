import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24).h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(icon),
            SizedBox(width: 12.w),
            Expanded(
                child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              // color: context.colorScheme.onBackground.withOpacity(0.85),
            ),
          ],
        ),
      ),
    );
  }
}
