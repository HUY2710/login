import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.titleDialog,
    required this.subTitleDialog,
    this.isTextRed = false,
    required this.titleButton1,
    required this.titleButton2,
    this.onTapButton1,
  });
  final String titleDialog;
  final String subTitleDialog;
  final bool isTextRed;
  final String titleButton1;
  final String titleButton2;
  final Function()? onTapButton1;

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
            titleDialog,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff343434)),
          ),
          4.verticalSpace,
          Text(
            subTitleDialog,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff6C6C6C)),
          ),
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
                titleButton1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isTextRed
                        ? const Color(0xffFF3B30)
                        : const Color(0xff8E52FF)),
              ),
            ),
          ),
          Container(
            height: 1.h,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xffEAEAEA),
          ),
          GestureDetector(
            onTap: () {
              context.popRoute();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                titleButton2,
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
