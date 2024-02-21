import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/navigation/app_router.dart';
import '../../../../../data/models/store_group/store_group.dart';
import '../../../../../data/remote/firestore_client.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/cubit/value_cubit.dart';
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
    final ValueCubit<bool> notifyCubit = ValueCubit(itemGroup.notify);
    return Container(
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
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: CreateEditGroup(
                              detailGroup: itemGroup,
                            ),
                          ),
                        ),
                      );
                });
              },
              child: itemAction(Assets.icons.icEdit.svg(width: 20.r), 'Edit'),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: GestureDetector(
              child: itemAction(
                  Assets.icons.icNotify.svg(width: 20.r), 'Notification',
                  notifyCubit: notifyCubit),
            ),
          ),
          if (isAdmin)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context1) => ActionDialog(
                    title: 'Remove Group',
                    subTitle:
                        'You’re currently the group owner. Are you sure to delete it permanantly?',
                    confirmTap: () async {
                      //delete group
                      EasyLoading.show();
                      myGroupCubit.deleteGroup(itemGroup).then((value) async {
                        if (itemGroup.idGroup ==
                            getIt<SelectGroupCubit>().state?.idGroup) {
                          getIt<SelectGroupCubit>().update(null);
                        }
                        EasyLoading.dismiss();
                        await context1
                            .popRoute()
                            .then((value) => context.popRoute());
                      });
                    },
                    confirmText: 'Delete',
                  ),
                );
              },
              child: itemAction(
                  Assets.icons.icDelete.svg(width: 20.r), 'Delete',
                  colorText: Colors.red),
            ),
          if (!isAdmin)
            itemAction(
              Assets.icons.icLoggout.svg(width: 20.r),
              'Leave',
            ),
          14.verticalSpace,
        ],
      ),
    );
  }

  Row itemAction(SvgPicture svg, String text,
      {Color? colorText, ValueCubit<bool>? notifyCubit}) {
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
        if (notifyCubit != null)
          BlocBuilder<ValueCubit<bool>, bool>(
            bloc: notifyCubit,
            builder: (context, state) {
              return MainSwitch(
                  value: state,
                  onChanged: (value) {
                    notifyCubit.update(value);
                    //update sever
                    FirestoreClient.instance.updateNotifyGroup(
                      idGroup: getIt<SelectGroupCubit>().state!.idGroup!,
                      onNotify: value,
                    );

                    //update local
                    myGroupCubit.state.maybeWhen(
                      orElse: () {},
                      success: (groups) {
                        final indexGroup = groups.indexWhere(
                          (element) =>
                              element.idGroup ==
                              getIt<SelectGroupCubit>().state!.idGroup,
                        );
                        final tempGroup = itemGroup.copyWith(notify: value);
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
