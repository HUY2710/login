import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../home/widgets/bottom_sheet/invite_code.dart';
import '../../home/widgets/bottom_sheet/members/members.dart';
import '../../home/widgets/bottom_sheet/places/places_bottom_sheet.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../cubit/select_group_cubit.dart';
import '../cubit/tracking_location/tracking_location_cubit.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';

class FloatRightAppBar extends StatefulWidget {
  const FloatRightAppBar({
    super.key,
    required this.locationListenCubit,
    required this.trackingMemberCubit,
  });

  final TrackingLocationCubit locationListenCubit;
  final TrackingMemberCubit trackingMemberCubit;

  @override
  State<FloatRightAppBar> createState() => _FloatRightAppBarState();
}

class _FloatRightAppBarState extends State<FloatRightAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<SelectGroupCubit, StoreGroup?>(
          bloc: getIt<SelectGroupCubit>(),
          builder: (context, state) {
            return buildItem(
              state == null
                  ? () {
                      Fluttertoast.showToast(msg: context.l10n.joinAGroup);
                      return;
                    }
                  : () => showAppModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => InviteCode(code: state.passCode)),
              Assets.icons.icAddMember.path,
            );
          },
        ),
        SizedBox(height: 16.h),
        buildItem(
          () async {
            if (getIt<SelectGroupCubit>().state == null) {
              Fluttertoast.showToast(msg: context.l10n.joinAGroup);
              return;
            }
            showAppModalBottomSheet(
              context: context,
              builder: (context) {
                return MembersBottomSheet(
                  trackingMemberCubit: widget.trackingMemberCubit,
                );
              },
            );
          },
          Assets.icons.icPeople.path,
        ),
        SizedBox(height: 16.h),
        buildItem(() {
          if (getIt<SelectGroupCubit>().state == null) {
            Fluttertoast.showToast(msg: context.l10n.joinAGroup);
            return;
          }
          showAppModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const PlacesBottomSheet(),
          );
        }, Assets.icons.icPlace.path),
      ],
    );
  }

  Widget buildItem(VoidCallback onTap, String pathIc) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff42474C).withOpacity(0.3),
              blurRadius: 17,
            )
          ],
        ),
        child: SvgPicture.asset(
          pathIc,
          height: 20.r,
          width: 20.r,
        ),
      ),
    );
  }
}
