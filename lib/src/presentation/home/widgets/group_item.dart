import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../cubit/my_list_group_cubit.dart';
import 'dialog/group_dialog.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({
    super.key,
    required this.members,
    required this.itemGroup,
    required this.myGroupCubit,
  });

  final int members;
  final StoreGroup itemGroup;
  final MyListGroupCubit myGroupCubit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.primary,
            backgroundImage: AssetImage(itemGroup.avatarGroup),
            radius: 20.r,
          ),
          12.w.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        itemGroup.groupName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8E52FF),
                        ),
                      ),
                    ),
                    12.w.horizontalSpace,
                    if (isAdmin(itemGroup))
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 8.w),
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
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xff6C6C6C)),
                ),
              ],
            ),
          ),
          BlocBuilder<SelectGroupCubit, StoreGroup?>(
            bloc: getIt<SelectGroupCubit>(),
            builder: (context, state) {
              if (state != null &&
                  isAdmin(itemGroup) &&
                  state.idGroup == itemGroup.idGroup) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomInkWell(
                      onTap: () {},
                      child: GradientSvg(Assets.icons.icEdit.svg(width: 20.r)),
                    ),
                    10.horizontalSpace,
                    CustomInkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => GroupDialog(
                            title: 'Remove Group',
                            subTitle:
                                'You’re currently the group owner. Are you sure to delete it permanantly?',
                            confirmTap: () async {
                              //delete group
                              myGroupCubit.deleteGroup(itemGroup).then((value) {
                                getIt<SelectGroupCubit>().update(null);
                                context.popRoute();
                              });
                            },
                            confirmText: 'Delete',
                          ),
                        );
                      },
                      child: Assets.icons.icTrash.svg(width: 20.r),
                    )
                  ],
                );
              }
              return Align(
                alignment: Alignment.centerRight,
                child: CustomInkWell(
                  onTap: () {},
                  child: GradientSvg(Assets.icons.icLoggout.svg(width: 20.r)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool isAdmin(StoreGroup itemGroup) {
    if (itemGroup.members != null && Global.instance.user != null) {
      if (itemGroup.members!.containsKey(Global.instance.user!.code) &&
          itemGroup.members![Global.instance.user!.code] == true) {
        return true;
      }
      return false;
    }
    return false;
  }
}
