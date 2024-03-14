import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/gens.dart';
import '../../../shared/extension/context_extension.dart';

class ItemSignIn extends StatelessWidget {
  const ItemSignIn(
      {super.key, this.logo, this.title, this.onTap, this.haveShadow = false});
  final String? logo;
  final String? title;
  final Function()? onTap;
  final bool haveShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
            boxShadow: haveShadow
                ? [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 8.4,
                        color: const Color(0xff9C747D).withOpacity(0.17))
                  ]
                : [],
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(logo ?? Assets.icons.login.icFacebook.path),
              8.horizontalSpace,
              Flexible(
                child: Text(
                  title ?? context.l10n.continueWithFacebook,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff343434)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
