import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../config/di/di.dart';
import '../../../../../data/models/store_user/store_user.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../global/global.dart';
import '../../../../../shared/cubit/value_cubit.dart';
import '../../../../../shared/extension/context_extension.dart';
import '../../../../../shared/helpers/gradient_background.dart';
import '../../../../../shared/widgets/custom_inkwell.dart';
import '../../../../../shared/widgets/gradient_text.dart';
import '../../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../map/cubit/select_group_cubit.dart';
import '../../../../map/cubit/tracking_members/tracking_member_cubit.dart';
import '../invite_code.dart';
import '../show_bottom_sheet_home.dart';
import 'widgets/build_list_member.dart';

class MembersBottomSheet extends StatelessWidget {
  const MembersBottomSheet({
    super.key,
    required this.trackingMemberCubit,
    required this.goToUserLocation,
  });
  final TrackingMemberCubit trackingMemberCubit;
  final Function(StoreUser user) goToUserLocation;
  @override
  Widget build(BuildContext context) {
    final currentGroupCubit = getIt<SelectGroupCubit>();
    final ValueCubit<bool> isEditCubit = ValueCubit(false);
    return SizedBox(
      height: 1.sh * 0.46,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20.r), right: Radius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: const Color(0xffE2E2E2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.people,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xff343434),
                        fontWeight: FontWeight.w500),
                  ),
                  if (currentGroupCubit.state?.storeMembers?.any((member) =>
                          member.isAdmin &&
                          member.idUser == Global.instance.user?.code) ??
                      false)
                    BlocBuilder<ValueCubit<bool>, bool>(
                      bloc: isEditCubit,
                      builder: (context, state) {
                        if (state) {
                          return CustomInkWell(
                            onTap: () {
                              isEditCubit.update(false);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.r, vertical: 10.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: gradientBackground,
                              ),
                              child: Text(
                                context.l10n.done,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        } else {
                          return CustomInkWell(
                            onTap: () {
                              isEditCubit.update(true);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.r, vertical: 10.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99.r),
                                  gradient: gradientBackground),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.icons.icEdit.path,
                                    width: 20.r,
                                    height: 20.r,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    context.l10n.edit,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    )
                ],
              ),
              16.h.verticalSpace,
              GestureDetector(
                onTap: () {
                  showAppModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return InviteCode(
                          code: currentGroupCubit.state?.passCode ?? '',
                        );
                      });
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showAppModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return InviteCode(
                                code: currentGroupCubit.state?.passCode ?? '',
                              );
                            });
                      },
                      icon: const Icon(Icons.add),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return Colors.white;
                        }),
                        shape: MaterialStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r));
                        }),
                        shadowColor:
                            MaterialStateProperty.resolveWith((states) {
                          return const Color(0xff42474C).withOpacity(0.15);
                        }),
                        elevation: MaterialStateProperty.resolveWith((states) {
                          return 8.0;
                        }),
                      ),
                    ),
                    12.w.horizontalSpace,
                    GradientText(
                      context.l10n.addMember,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              BlocBuilder<TrackingMemberCubit, TrackingMemberState>(
                bloc: trackingMemberCubit,
                builder: (context, stateTrackingMemberCubit) {
                  return stateTrackingMemberCubit.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading: () => SizedBox(
                      height: 40,
                      width: 60.w,
                      child: const LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                      ),
                    ),
                    success: (List<StoreUser> members) {
                      return Expanded(
                        child: BuildListMember(
                          listMembers: members,
                          isEditCubit: isEditCubit,
                          goToUserLocation: goToUserLocation,
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
