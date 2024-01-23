import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/gens.dart';
import 'modal_bottom/widgets/modal_edit.dart';
import 'modal_bottom/widgets/modal_show.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildItem(Assets.icons.icPeople.path, context),
        23.horizontalSpace,
        //avatar
        23.horizontalSpace,
        buildItem(Assets.icons.icMessage.path, context),
      ],
    );
  }

  Widget buildItem(String path, BuildContext context, {bool? avatar}) {
    final value = ValueNotifier<int>(0);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, _) {
                return ValueListenableBuilder(
                    valueListenable: value,
                    builder: (context, val, child) {
                      return AnimatedSwitcher(
                          child: (val == 0)
                              ? ModalShowMember(value: value)
                              : ModalEditMember(value: value),
                          // crossFadeState: (val == 0)
                          //     ? CrossFadeState.showFirst
                          //     : CrossFadeState.showSecond,
                          duration: const Duration(
                            microseconds: 700,
                          ));
                    });
              });
            });
      },
      child: Container(
        height: 48.r,
        width: 48.r,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          gradient: const LinearGradient(colors: [
            Color(0xffB67DFF),
            Color(0xff7B3EFF),
          ]),
        ),
        child: SvgPicture.asset(
          path,
          height: 22.r,
          width: 22.r,
        ),
      ),
    );
  }
}
