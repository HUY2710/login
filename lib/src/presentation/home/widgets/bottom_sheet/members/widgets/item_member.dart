import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../data/models/store_user/store_user.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../global/global.dart';
import '../../../../../../shared/extension/context_extension.dart';

class ItemMember extends StatelessWidget {
  const ItemMember({super.key, required this.isAdmin, required this.user});

  final bool isAdmin;
  final StoreUser user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(
              user.avatarUrl,
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
                      user.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    8.w.horizontalSpace,
                    if (isAdmin || user.code == Global.instance.user?.code)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xffEADDFF),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Text(
                          user.code == Global.instance.user?.code
                              ? '${context.l10n.you}${isAdmin ? ' - ${context.l10n.admin}' : ''}'
                              : context.l10n.admin,
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
                        user.location?.address ?? '...',
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
          IconButton(
            onPressed: () {},
            icon: Transform.rotate(
              angle: pi,
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.r,
                color: MyColors.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
