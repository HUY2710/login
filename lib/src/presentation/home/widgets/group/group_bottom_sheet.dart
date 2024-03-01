import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/di/di.dart';
import '../../../../global/global.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/widgets/containers/border_container.dart';
import '../../../../shared/widgets/containers/linear_container.dart';
import '../../../../shared/widgets/custom_inkwell.dart';
import '../../../../shared/widgets/my_drag.dart';
import '../../../map/cubit/select_group_cubit.dart';
import '../../cubit/my_list_group/my_list_group_cubit.dart';
import '../bottom_sheet/create_edit_group.dart';
import '../bottom_sheet/join_group.dart';
import '../bottom_sheet/show_bottom_sheet_home.dart';
import 'group_item.dart';

class GroupBottomSheet extends StatelessWidget {
  const GroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final MyListGroupCubit myListGroupCubit = getIt<MyListGroupCubit>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
      ),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyDrag(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await context.popRoute();
                      if (context.mounted) {
                        await showAppModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: const CreateEditGroup(),
                              );
                            });
                      }
                    },
                    child: LinearContainer(
                      radius: AppConstants.widgetBorderRadius.r,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                        ),
                        child: Text(
                          context.l10n.newGroup,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomInkWell(
                    onTap: () async {
                      await context.popRoute();
                      if (context.mounted) {
                        showAppModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const JoinGroupWidget());
                      }
                    },
                    child: BorderContainer(
                      radius: AppConstants.widgetBorderRadius.r,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                        ),
                        child: Text(
                          context.l10n.joinGroup,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff8E52FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            StatefulBuilder(
              builder: (context, setState) =>
                  BlocBuilder<MyListGroupCubit, MyListGroupState>(
                bloc: myListGroupCubit..fetchMyGroups(),
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => SizedBox(
                      height: 1.sh * 0.26,
                    ),
                    loading: () => SizedBox(
                      height: 1.sh * 0.26,
                      child: SpinKitFadingCircle(
                        color: context.colorScheme.primary,
                      ),
                    ),
                    success: (groups) {
                      debugPrint('value:$groups');
                      if (groups.isEmpty) {
                        return SizedBox(
                          height: 1.sh * 0.26,
                          child: Center(child: Text(context.l10n.noGroups)),
                        );
                      }
                      return SizedBox(
                        height: 1.sh * 0.26,
                        child: ListView.separated(
                          itemCount: groups.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Color(0xffEAEAEA),
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.popRoute();
                                if (groups[index].idGroup !=
                                    getIt<SelectGroupCubit>().state?.idGroup) {
                                  getIt<SelectGroupCubit>()
                                      .update(groups[index]);
                                  Global.instance.group = groups[index];
                                }
                              },
                              child: GroupItem(
                                myGroupCubit: myListGroupCubit,
                                members: groups[index].storeMembers!.length,
                                itemGroup: groups[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
