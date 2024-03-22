import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extension/context_extension.dart';

class SigninSettingDialog extends StatelessWidget {
  const SigninSettingDialog({
    super.key,
    required this.titleDialog,
    required this.subTitleDialog,
    required this.titleButton1,
    required this.titleButton2,
    this.onTapButton1,
    this.onTapButton2,
  });
  final String titleDialog;
  final String subTitleDialog;

  final String titleButton1;
  final String titleButton2;
  final Function()? onTapButton1;
  final Function()? onTapButton2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.verticalSpace,
          Text(
            context.l10n.signIn,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff343434)),
          ),
          4.verticalSpace,
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: context.l10n.subtitleSignInBlack1,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff6C6C6C)),
            ),
            TextSpan(
              text: context.l10n.existingAccount,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff8E52FF)),
            ),
            TextSpan(
              text: context.l10n.subtitleSignInBlack2,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff6C6C6C)),
            ),
            TextSpan(
              text: context.l10n.createNew,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff8E52FF)),
            ),
          ])),
          24.verticalSpace,
          Container(
            height: 1.h,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xffEAEAEA),
          ),
          GestureDetector(
            onTap: onTapButton1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                context.l10n.continueText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8E52FF)),
              ),
            ),
          ),
          Container(
            height: 1.h,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xffEAEAEA),
          ),
          GestureDetector(
            onTap: onTapButton2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                context.l10n.createNew,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8E52FF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
