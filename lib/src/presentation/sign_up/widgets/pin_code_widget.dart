import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../shared/constants/app_text_style.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    super.key,
    this.onChanged,
    this.controller,
    this.onCompleted,
    this.onSubmitted,
    this.autoFocus = false,
  });
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Function(String)? onCompleted;
  final Function(String)? onSubmitted;
  final bool autoFocus;

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      obscuringCharacter: '*',
      obscureText: true,
      animationType: AnimationType.fade,
      cursorHeight: 30.h,
      enableActiveFill: true,
      autoFocus: widget.autoFocus,
      onSubmitted: widget.onSubmitted,
      textStyle: AppTextStyle.s50w700,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 46.w,
        activeFillColor: Colors.grey,
        selectedFillColor: Colors.grey,
        inactiveFillColor: Colors.grey,
        fieldWidth: 46.w,
        inactiveColor: Colors.transparent,
        selectedColor: Colors.transparent,
        activeColor: Colors.transparent,
      ),
      onCompleted: widget.onCompleted,
      length: 4,
    );
  }
}
