import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../gen/gens.dart';
import '../../../../../../shared/extension/context_extension.dart';
import '../../../../../../shared/widgets/gradient_text.dart';
import '../../../header_modall.dart';
import '../../invite_group/invite_group.dart';
import '../show_member.dart';

class ModalShowMember extends StatelessWidget {
  const ModalShowMember({super.key, required this.value});
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
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: const Color(0xffE2E2E2),
                ),
              ),
              HeaderModal(
                title: context.l10n.people,
                icon: Assets.icons.icEdit,
                textIcon: context.l10n.edit,
                onTap: () {
                  // cubit.update(MemberMode.edit);
                  value.value = 1;
                },
              ),
              16.h.verticalSpace,
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return InviteGroupWidget();
                          });
                    },
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        return Colors.white;
                      }),
                      shape: MaterialStateProperty.resolveWith((states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r));
                      }),
                      shadowColor: MaterialStateProperty.resolveWith((states) {
                        return Colors.black;
                      }),
                      elevation: MaterialStateProperty.resolveWith((states) {
                        return 8.0;
                      }),
                    ),
                  ),
                  12.w.horizontalSpace,
                  GradientText(
                    context.l10n.addMember,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                     ),
                  )
                ],
              ),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return MemberWidget(
                        isAdmin: index == 0 ? true : false,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
