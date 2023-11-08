import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/colors.gen.dart';
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
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: widget.value
                  ? context.colorScheme.primary
                  : MyColors.primary.shade100,
              borderRadius: BorderRadius.circular(30).r,
            ),
            width: 48.r,
            height: 24.r,
          ),
          AnimatedPositioned(
            top: 2.r,
            left: widget.value ? 26.r : 2.r,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30).r,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
