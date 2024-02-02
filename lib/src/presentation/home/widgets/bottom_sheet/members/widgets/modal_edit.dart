import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/extension/context_extension.dart';
import '../../../header_modall.dart';

class ModalEditMember extends StatelessWidget {
  const ModalEditMember({super.key, required this.value});
  final ValueNotifier value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh * 0.46,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20.r), right: Radius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
                width: 40,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: const Color(0xffE2E2E2),
                ),
              ),
              HeaderModal(
                title: context.l10n.done,
                textIcon: context.l10n.done,
                onTap: () {
                  // final update = cubit.update(MemberMode.show);
                  value.value = 0;
                },
                isAdmin: false,
              ),
              16.h.verticalSpace,
              // Expanded(
              //   child: ListView.builder(
              //       itemCount: 4,
              //       itemBuilder: (context, index) {
              //         return MemberWidget(
              //           isAdmin: index == 0 ? true : false,
              //           isEdit: true,
              //         );
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
