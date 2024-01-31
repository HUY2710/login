// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/enum/gender_type.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateGroupAvatarScreen extends StatelessWidget {
  const CreateGroupAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _MainBody(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CustomAppBar(title: 'Set avatar'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: AppButton(
          title: 'Save',
          onTap: () {
            //
          },
          isEnable: false,
          textSecondColor: const Color(0xFFB685FF),
        ),
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250.h,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
          ),
          16.verticalSpace,
          CustomSwitch(
            onChanged: (value) {
              //
            },
          ),
          24.verticalSpace,
          Text(
            'Choose your favorite avatar!',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3A3A3C),
            ),
          ),
          16.verticalSpace,
          GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 32.w,
            mainAxisSpacing: 32.h,
            children: const [
              CircleAvatar(),
              CircleAvatar(),
              CircleAvatar(),
              CircleAvatar(),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<GenderType> onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
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
                        },
                        height: constraints.maxHeight,
                      ),
                      _buildItem(
                        type: GenderType.female,
                        selected: value,
                        onTap: (gender) {
                          switchValue.value = gender;
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
          setState(() {
            onTap.call(type);
          });
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
