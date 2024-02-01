import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/enum/gender_type.dart';

class GenderSwitch extends StatefulWidget {
  const GenderSwitch({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<GenderType> onChanged;

  @override
  State<GenderSwitch> createState() => _GenderSwitchState();
}

class _GenderSwitchState extends State<GenderSwitch> {
  final ValueNotifier<GenderType> switchValue = ValueNotifier(GenderType.male);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFF7B3EFF),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ValueListenableBuilder(
            valueListenable: switchValue,
            builder: (context, value, child) => Stack(
              children: [
                AnimatedPositioned(
                  height: constraints.maxHeight,
                  duration: const Duration(milliseconds: 150),
                  left: value == GenderType.male ? 0 : constraints.maxWidth / 2,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth / 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB67DFF),
                          Color(0xFF7B3EFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildItem(
                        type: GenderType.male,
                        selected: value,
                        onTap: (gender) {
                          switchValue.value = gender;
                          widget.onChanged.call(gender);
                        },
                        height: constraints.maxHeight,
                      ),
                      _buildItem(
                        type: GenderType.female,
                        selected: value,
                        onTap: (gender) {
                          switchValue.value = gender;
                          widget.onChanged.call(gender);
                        },
                        height: constraints.maxHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required GenderType selected,
    required GenderType type,
    required Function(GenderType gender) onTap,
    required double height,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap.call(type);
        },
        child: SizedBox(
          height: height,
          child: Align(
            child: Text(
              type.name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color:
                    type == selected ? Colors.white : const Color(0xFF8E52FF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
