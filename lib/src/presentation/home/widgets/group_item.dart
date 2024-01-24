import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/gens.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import '../../../shared/widgets/gradient_text.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({super.key, required this.isAdmin, required this.members});

  final bool isAdmin;
  final int members;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.primary,
            backgroundImage: AssetImage(Assets.images.avatars.avatar1.path),
            radius: 20.r,
          ),
          12.w.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GradientText(
                    'My Planet',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  12.w.horizontalSpace,
                  if (isAdmin)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                          color: const Color(0xffEADDFF),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Text(
                        context.l10n.admin,
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: MyColors.black34),
                      ),
                    )
                ],
              ),
              Text(
                '$members members',
                style:
                    TextStyle(fontSize: 12.sp, color: const Color(0xff6C6C6C)),
              ),
            ],
          ),
          Expanded(
            child: isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomInkWell(
                        onTap: () {},
                        child:
                            GradientSvg(Assets.icons.icEdit.svg(width: 20.r)),
                      ),
                      5.w.horizontalSpace,
                      CustomInkWell(
                        onTap: () {},
                        child: Assets.icons.icTrash.svg(width: 20.r),
                      )
                    ],
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: CustomInkWell(
                      onTap: () {},
                      child:
                          GradientSvg(Assets.icons.icLoggout.svg(width: 20.r)),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
