import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extension/context_extension.dart';

class MainTextFormField extends StatefulWidget {
  const MainTextFormField({
    super.key,
    this.prefixIcon,
    this.hintText,
    this.controller,
    this.readonly = false,
    this.validator,
    this.keyboardType,
    this.errorText,
    this.title,
    this.filledColor,
    this.maxLines,
    this.prefixText,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.onChanged,
    this.onTap,
    this.contentPadding,
  });

  final Widget? prefixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final bool readonly;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? title;
  final Color? filledColor;
  final int? maxLines;
  final String? prefixText;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;
  final double? paddingLeft;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  @override
  State<MainTextFormField> createState() => _MainTextFormFieldState();
}

class _MainTextFormFieldState extends State<MainTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readonly,
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.maxLines ?? 1,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        fillColor: const Color(0xffEFEFEF),
        filled: true,
        errorText: widget.errorText,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: 150.r),
        prefixStyle: TextStyle(
          fontSize: 14.sp,
          color: context.colorScheme.primary,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: widget.prefixIcon,
              )
            : widget.prefixText != null
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 12.w),
                    child: Text(
                      widget.prefixText.toString(),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )
                : null,
      ),
    );
  }
}
