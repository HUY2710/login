import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extension/context_extension.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.messageError, this.cancelText});
  final String messageError;
  final String? cancelText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              messageError,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          24.verticalSpace,
          const Divider(
            color: Color(0xffEAEAEA),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cancelText ?? context.l10n.cancel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffB67DFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
