import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../../app/cubit/exception/exception_cubit.dart';
import '../../../../../../app/cubit/loading_cubit.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/navigation/app_router.dart';
import '../../../../../data/models/store_group/store_group.dart';
import '../../../../../data/models/store_member/store_member.dart';
import '../../../../../data/remote/firestore_client.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../global/global.dart';
import '../../../../../services/firebase_message_service.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/cubit/value_cubit.dart';
import '../../../../../shared/extension/context_extension.dart';
import '../../../../../shared/widgets/main_switch.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../map/cubit/select_group_cubit.dart';
import '../../../cubit/my_list_group/my_list_group_cubit.dart';
import '../../dialog/action_dialog.dart';
import '../create_edit_group.dart';
import '../show_bottom_sheet_home.dart';

class ActionGroupBottomSheet extends StatelessWidget {
  const ActionGroupBottomSheet(
      {super.key,
      required this.itemGroup,
      this.isAdmin = false,
      required this.myGroupCubit});
  final StoreGroup itemGroup;
  final bool isAdmin;
  final MyListGroupCubit myGroupCubit;

  @override
  Widget build(BuildContext context) {
    final StoreMember member = itemGroup.storeMembers!
        .firstWhere((member) => member.idUser == Global.instance.user?.code);
    final ValueCubit<bool> notifyCubit = ValueCubit(member.onNotify);
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: MyDrag()),
            if (isAdmin)
              GestureDetector(
                onTap: () {
                  context.popRoute().then((value) {
                    getIt<AppRouter>()
                        .navigatorKey
                        .currentContext!
                        .popRoute()
                        .then(
                          (value) => showAppModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: CreateEditGroup(
                                detailGroup: itemGroup,
                              ),
                            ),
                          ),
                        );
                  });
                },
                child: itemAction(
                    Assets.icons.icEdit.svg(width: 20.r), context.l10n.edit),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: GestureDetector(
                child: itemAction(Assets.icons.icNotify.svg(width: 20.r),
                    context.l10n.notification,
                    notifyCubit: notifyCubit, member: member),
              ),
            ),
            if (isAdmin)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context1) => ActionDialog(
                      title: context.l10n.removeGroup,
                      subTitle: context.l10n.removeGroupSubAdmin,
                      confirmTap: () async {
                        //delete group
                        // EasyLoading.show();
                        showLoading();
                        myGroupCubit.deleteGroup(itemGroup).then((value) async {
                          if (itemGroup.idGroup ==
                              getIt<SelectGroupCubit>().state?.idGroup) {
                            getIt<SelectGroupCubit>().update(null);
                          }
                          // EasyLoading.dismiss();
                          hideLoading();
                          await context1
                              .popRoute()
                              .then((value) => context.popRoute());
                        });
                      },
                      confirmText: context.l10n.delete,
                    ),
                  );
                },
                child: itemAction(
                    Assets.icons.icDelete.svg(width: 20.r), context.l10n.delete,
                    colorText: Colors.red),
              ),
            if (!isAdmin)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context1) => ActionDialog(
                      title: context.l10n.leaveGroup,
                      subTitle: context.l10n.leaveGroupContent,
                      confirmTap: () {
                        // EasyLoading.show();
                        showLoading();
                        myGroupCubit
                            .leaveGroup(
                          group: itemGroup,
                          exceptionCubit: exceptionCubit,
                          context: context,
                        )
                            .then((value) async {
                          // EasyLoading.dismiss();
                          hideLoading();
                          await context1
                              .popRoute()
                              .then((value) => context.popRoute());
                        });
                      },
                      confirmText: context.l10n.leave,
                    ),
                  );
                },
                child: itemAction(
                  Assets.icons.icLoggout.svg(width: 20.r),
                  context.l10n.leave,
                ),
              ),
            14.verticalSpace,
          ],
        ),
      ),
    );
  }

  Row itemAction(
    SvgPicture svg,
    String text, {
    Color? colorText,
    ValueCubit<bool>? notifyCubit,
    StoreMember? member,
  }) {
    return Row(
      children: [
        svg,
        12.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorText ?? MyColors.black34,
            ),
          ),
        ),
        if (notifyCubit != null && member != null)
          BlocBuilder<ValueCubit<bool>, bool>(
            bloc: notifyCubit,
            builder: (context, state) {
              return MainSwitch(
                  value: state,
                  onChanged: (value) {
                    notifyCubit.update(value);
                    //update sever
                    if (value) {
                      //đăng kí nhận lắng nghe thông báo
                      getIt<FirebaseMessageService>()
                          .subscribeTopics([itemGroup.idGroup!]);
                      //đăng kí nhận lắng nghe thông báo
                      getIt<FirebaseMessageService>()
                          .subscribeTopics(['testGroup']);
                    } else {
                      //hủy thông báo
                      getIt<FirebaseMessageService>()
                          .unSubscribeTopics([itemGroup.idGroup!]);
                      //đăng kí nhận lắng nghe thông báo
                      getIt<FirebaseMessageService>()
                          .unSubscribeTopics(['testGroup']);
                    }
                    FirestoreClient.instance.updateNotifyGroupEachMember(
                      idGroup: getIt<SelectGroupCubit>().state!.idGroup!,
                      onNotify: value,
                    );

                    //update local
                    myGroupCubit.state.maybeWhen(
                      orElse: () {},
                      success: (groups) {
                        //cập nhật lại field onNotify của member (bản thân mình)
                        member = member!.copyWith(onNotify: value);
                        //lấy ra group hiện tại vừa cập nhật
                        final indexGroup = groups.indexWhere(
                          (element) => element.idGroup == itemGroup.idGroup,
                        );
                        final List<StoreMember> listMembers =
                            List.from(groups[indexGroup].storeMembers!);
                        final index = listMembers.indexWhere(
                            (element) => element.idUser == member?.idUser);
                        if (index != -1) {
                          listMembers[index] = member!;
                        }
                        //sau đó tiến hành cập nhật member trong list danh sách member của group
                        final tempGroup =
                            itemGroup.copyWith(storeMembers: listMembers);
                        myGroupCubit.updateItemGroup(tempGroup, indexGroup);
                      },
                    );
                  });
            },
          )
      ],
    );
  }
}
