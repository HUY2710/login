import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../app/cubit/exception/exception_cubit.dart';
import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_member/store_member.dart';
import '../../../../gen/gens.dart';
import '../../../../global/global.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/widgets/custom_inkwell.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../map/cubit/select_group_cubit.dart';
import '../../cubit/my_list_group/my_list_group_cubit.dart';
import '../bottom_sheet/create_edit_group.dart';
import '../bottom_sheet/show_bottom_sheet_home.dart';
import '../dialog/action_dialog.dart';

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
                if (isAdmin(itemGroup)) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomInkWell(
                        onTap: () {
                          context.popRoute().then(
                                (value) => showAppModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: CreateEditGroup(
                                      detailGroup: itemGroup,
                                    ),
                                  ),
                                ),
                              );
                        },
                        child:
                            GradientSvg(Assets.icons.icEdit.svg(width: 20.r)),
                      ),
                      10.horizontalSpace,
                      CustomInkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ActionDialog(
                              title: 'Remove Group',
                              subTitle:
                                  'You’re currently the group owner. Are you sure to delete it permanantly?',
                              confirmTap: () async {
                                //delete group
                                EasyLoading.show();
                                myGroupCubit
                                    .deleteGroup(itemGroup)
                                    .then((value) {
                                  if (itemGroup.idGroup == state?.idGroup) {
                                    getIt<SelectGroupCubit>().update(null);
                                  }
                                  EasyLoading.dismiss();
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
                if (!isAdmin(itemGroup)) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: CustomInkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ActionDialog(
                            title: 'Leave Group',
                            subTitle: 'Are you sure to leave group?',
                            confirmTap: () {
                              EasyLoading.show();
                              myGroupCubit
                                  .leaveGroup(
                                group: itemGroup,
                                exceptionCubit: exceptionCubit,
                                context: context,
                              )
                                  .then((value) async {
                                EasyLoading.dismiss();
                                context.popRoute();
                              });
                            },
                            confirmText: 'Leave',
                          ),
                        );
                      },
                      child:
                          GradientSvg(Assets.icons.icLoggout.svg(width: 20.r)),
                    ),
                  );
                }
                return const SizedBox();
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
