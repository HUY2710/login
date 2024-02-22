import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../app/cubit/exception/exception_cubit.dart';
import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_member/store_member.dart';
import '../../../../gen/gens.dart';
import '../../../../global/global.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../map/cubit/select_group_cubit.dart';
import '../../cubit/my_list_group/my_list_group_cubit.dart';
import '../bottom_sheet/groups/action_group.dart';
import '../bottom_sheet/show_bottom_sheet_home.dart';

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
    final ExceptionCubit exceptionCubit = getIt<ExceptionCubit>();

    return BlocListener<ExceptionCubit, ExceptionState>(
      bloc: exceptionCubit,
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          success: (successMess) {
            Fluttertoast.showToast(msg: successMess);
            if (itemGroup.idGroup == getIt<SelectGroupCubit>().state?.idGroup) {
              getIt<SelectGroupCubit>().update(null);
            }
            exceptionCubit.reset();
          },
          error: (errorMess) {
            Fluttertoast.showToast(msg: errorMess);
            exceptionCubit.reset();
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.primary,
                  backgroundImage: AssetImage(itemGroup.avatarGroup),
                  radius: 20.r,
                ),
                BlocBuilder<SelectGroupCubit, StoreGroup?>(
                  bloc: getIt<SelectGroupCubit>(),
                  builder: (context, state) {
                    if (itemGroup.idGroup ==
                        getIt<SelectGroupCubit>().state?.idGroup) {
                      return Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
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
                return GestureDetector(
                  onTap: () {
                    context.popRoute().then(
                          (value) => showAppModalBottomSheet(
                            context: context,
                            builder: (context) => ActionGroupBottomSheet(
                              itemGroup: itemGroup,
                              isAdmin: isAdmin(itemGroup),
                              myGroupCubit: myGroupCubit,
                            ),
                          ),
                        );
                  },
                  child: GradientSvg(
                    Assets.icons.ic3dot.svg(width: 20.r),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isAdmin(StoreGroup itemGroup) {
    if (itemGroup.storeMembers != null && Global.instance.user != null) {
      if (itemGroup.storeMembers!
          .firstWhere(
            (element) => element.idUser == Global.instance.user!.code,
            orElse: () => const StoreMember(isAdmin: false),
          )
          .isAdmin) {
        return true;
      }
      return false;
    }
    return false;
  }
}
