import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/constants/app_text_style.dart';
import '../../../shared/extension/context_extension.dart';

class TextFieldPasswordWidget extends StatefulWidget {
  const TextFieldPasswordWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
  });
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<TextFieldPasswordWidget> createState() =>
      _TextFieldPasswordWidgetState();
}

class _TextFieldPasswordWidgetState extends State<TextFieldPasswordWidget> {
  bool isNotNull = false;
  bool hidePassword = true;
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
      onChanged: widget.onChanged,
      style: AppTextStyle.s14w400,
      validator: widget.validator,
      obscureText: hidePassword,
      decoration: InputDecoration(
        hintText: 'passwrod',
        hintStyle: AppTextStyle.s14w400.copyWith(
          color: Colors.black,
        ),
        filled: true,
        contentPadding: EdgeInsets.all(10.w),
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: isNotNull
            ? GestureDetector(
                onTap: () {
                  if (hidePassword) {
                    setState(() {});
                    hidePassword = false;
                  } else {
                    setState(() {});
                    hidePassword = true;
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: !hidePassword
                      ? Assets.icons.ic3dot.svg()
                      : Assets.icons.ic3dot.svg(),
                ),
              )
            : const SizedBox(),
        fillColor: const Color.fromARGB(255, 106, 167, 224),
        focusColor: context.primary,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          borderSide: BorderSide(
            color: context.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        border: OutlineInputBorder(
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
