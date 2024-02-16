import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainSwitch extends StatefulWidget {
  const MainSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool value) onChanged;

  @override
  State<MainSwitch> createState() => _MainSwitchState();
}

class _MainSwitchState extends State<MainSwitch> {
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
              gradient: LinearGradient(
                  colors: widget.value
                      ? [const Color(0xff7B3EFF), const Color(0xffB67DFF)]
                      : [const Color(0xffEEEEEE), const Color(0xffEEEEEE)]),
              borderRadius: BorderRadius.circular(100).r,
            ),
            width: 56.r,
            height: 28.r,
          ),
          AnimatedPositioned(
            top: 4.r,
            left: widget.value ? 32.r : 2.r,
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
