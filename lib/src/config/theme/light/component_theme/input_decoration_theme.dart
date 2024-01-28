import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyInputDecorationTheme extends InputDecorationTheme {
  @override
  EdgeInsetsGeometry? get contentPadding =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);

  @override
  TextStyle? get hintStyle => TextStyle(color: Colors.red, fontSize: 14.sp);

  @override
  int? get errorMaxLines => 2;

  @override
  bool get isDense => true;

  BorderRadius get borderRadius => BorderRadius.circular(15.r);

  @override
  InputBorder? get border => OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: Colors.grey.shade100,
        width: 1.w,
      ));

  @override
  InputBorder? get focusedErrorBorder => OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      );

  @override
  InputBorder? get errorBorder => OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      );

  @override
  InputBorder? get enabledBorder => OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.grey, width: 1.w),
      );

  @override
  InputBorder? get disabledBorder => OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.grey, width: 1.w),
      );

  @override
  InputBorder? get focusedBorder => OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(width: 1.w, color: Colors.grey),
      );
}
