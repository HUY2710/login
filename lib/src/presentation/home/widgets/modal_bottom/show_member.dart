import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/gens.dart';
import '../../../../shared/extension/context_extension.dart';

class MemberWidget extends StatelessWidget {
  const MemberWidget({
    super.key,
    this.isAdmin = false,
    this.isEdit = false,
  });
  final bool isAdmin;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Row(
        children: [
          if (isEdit)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: InkWell(child: Assets.icons.icDelete.svg(width: 20.r)),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(
              'assets/images/avatars/avatar_1.png',
              width: 40.r,
              height: 40.r,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Lily',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    8.w.horizontalSpace,
                    if (isAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            color: Color(0xffEADDFF),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Text(
                          context.l10n.admin,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      )
                  ],
                ),
                7.h.verticalSpace,
                Row(
                  children: [
                    Assets.icons.icShareLocation.svg(width: 16.r),
                    4.w.horizontalSpace,
                    Expanded(
                      child: Text(
                        'My Dinh, Nam Tu Liem, Hanoi, Viet Nam',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff6C6C6C),
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          if (!isEdit)
            IconButton(
                onPressed: () {},
                icon: Transform.rotate(
                    angle: pi,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20.r,
                      color: MyColors.primary,
                    )))
        ],
      ),
    );
  }
}
