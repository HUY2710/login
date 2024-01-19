import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extension/context_extension.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool value) onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: widget.value
              ? context.colorScheme.primary
              : const Color(0xffDFDFDF),
          borderRadius: BorderRadius.circular(30).r,
        ),
        padding: EdgeInsets.all(2.4.r),
        width: 46.r,
        height: 24.r,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30).r,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
