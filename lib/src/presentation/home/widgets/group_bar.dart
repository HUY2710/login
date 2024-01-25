import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/border_container.dart';
import '../../../shared/widgets/containers/linear_container.dart';
import '../../../shared/widgets/containers/shadow_container.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../cubit/my_list_group_cubit.dart';
import 'bottom_sheet/create_group_bottom_sheet.dart';
import 'group_item.dart';
import 'modal_bottom/join_group/join_group.dart';

class GroupBar extends StatelessWidget {
  const GroupBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialogGroup(context);
      },
      child: ShadowContainer(
        maxWidth: MediaQuery.sizeOf(context).width - 80.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: BlocBuilder<SelectGroupCubit, StoreGroup?>(
          bloc: getIt<SelectGroupCubit>(),
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.primary,
                  backgroundImage: AssetImage(state == null
                      ? Assets.images.avatars.avatar1.path
                      : state.avatarGroup),
                  radius: 14.r,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      state == null ? 'New Group' : state.groupName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xff8E52FF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: MyColors.primary,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void showDialogGroup(
    BuildContext context,
  ) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: const Alignment(0, -0.7),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0.0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 32.w,
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await context.popRoute();
                            if (context.mounted) {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: const BottomSheetCreateGroup(),
                                    );
                                  });
                            }
                          },
                          child: LinearContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                              ),
                              child: Text(
                                'New Group',
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
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      const JoinGroupWidget());
                            }
                          },
                          child: BorderContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                              ),
                              child: Text(
                                'Join Group',
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
                      bloc: getIt<MyListGroupCubit>()..fetchMyGroups(),
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
                              return const Text("Don't have any groups");
                            }
                            return SizedBox(
                              height: 1.sh * 0.26,
                              child: ListView.separated(
                                itemCount: groups.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: Color(0xffEAEAEA),
                                  thickness: 1,
                                ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      getIt<SelectGroupCubit>()
                                          .update(groups[index]);
                                    },
                                    child: GroupItem(
                                      members:
                                          groups[index].members?.length ?? 1,
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
          ),
        );
      },
    );
  }
}
