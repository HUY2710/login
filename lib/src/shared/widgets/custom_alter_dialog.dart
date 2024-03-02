import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/colors.gen.dart';

class CustomAlertDialog extends Dialog {
  const CustomAlertDialog({
    super.key,
    required this.actions,
    required this.content,
  });

  final List<Widget> actions;

  final Widget content;

  @override
  Color? get backgroundColor => const Color(0xffEAEAEA);

  @override
  double? get elevation => 0.0;
  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Widget? get child => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: content,
          ),
          if (actions.isNotEmpty)
            ClipRRect(
              child: Table(
                border: TableBorder(
                  top: BorderSide(
                    color: const Color(0x5C3C3C43),
                    width: 0.3.r,
                  ),
                  verticalInside: BorderSide(
                    color: const Color(0x5C3C3C43),
                    width: 0.3.r,
                  ),
                ),
                children: [
                  TableRow(
                    children: actions,
                  ),
                ],
              ),
            ),
        ],
      );
}

class CustomDialogAction extends Container {
  CustomDialogAction({
    super.key,
    required this.onTap,
    required this.labelText,
    this.isPrimaryAction = false,
  });

  final VoidCallback onTap;
  final String labelText;
  final bool isPrimaryAction;

  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.symmetric(
        vertical: 11.h,
      );

  @override
  Widget? get child => GestureDetector(
        onTap: onTap,
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isPrimaryAction ? FontWeight.w600 : FontWeight.w400,
            color: isPrimaryAction ? Colors.black : MyColors.primary,
          ),
        ),
      );
}
