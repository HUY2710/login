import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/constants/app_text_style.dart';
import '../../../shared/extension/context_extension.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hinText,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.contentPadding,
    this.hintStyle,
    this.autoFocus = false,
    this.maxHeight,
    this.maxWidth,
    this.border,
    this.isReadOnly = false,
    this.borderFocus,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.inputFormatters,
    this.onTap,
  });
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hinText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final bool autoFocus;
  final double? maxHeight;
  final double? maxWidth;
  final InputBorder? border;
  final InputBorder? borderFocus;
  final Function()? onTap;
  final Function(String value)? onFieldSubmitted;
  final BoxConstraints? suffixIconConstraints;
  final bool isReadOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isNotNull = false;
  @override
  void initState() {
    widget.controller?.addListener(() {
      if (widget.controller != null && widget.controller!.text.isNotEmpty) {
        isNotNull = true;
        setState(() {});
      } else {
        isNotNull = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      style: AppTextStyle.s14w400,
      validator: widget.validator,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      readOnly: widget.isReadOnly,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        hintText: widget.hinText,
        hintStyle: widget.hintStyle ??
            AppTextStyle.s14w400.copyWith(
              color: Colors.black,
              height: 1,
            ),
        filled: true,
        prefixIconConstraints: BoxConstraints(
          maxHeight: widget.maxHeight ?? 20.w,
          maxWidth: widget.maxWidth ?? 20.w,
        ),
        suffixIconConstraints: widget.suffixIconConstraints,
        contentPadding: widget.contentPadding ?? EdgeInsets.all(10.w),
        suffixIcon: widget.suffixIcon ??
            (isNotNull && !widget.isReadOnly
                ? GestureDetector(
                    onTap: () {
                      widget.controller?.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Assets.icons.icClose.svg(),
                    ),
                  )
                : const SizedBox()),
        fillColor: const Color.fromARGB(255, 106, 171, 228),
        focusColor: context.primary,
        focusedBorder: widget.borderFocus ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.r),
              ),
              borderSide: BorderSide(
                color: context.primary,
              ),
            ),
        enabledBorder: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.r),
              ),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.r),
              ),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
      ),
    );
  }
}
