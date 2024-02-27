import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/shadow_container.dart';
import '../../chat/cubits/group_cubit.dart';
import '../../chat/cubits/group_state.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../../map/cubit/select_user_cubit.dart';
import '../../map/cubit/tracking_location/tracking_location_cubit.dart';
import '../../map/cubit/tracking_members/tracking_member_cubit.dart';
import 'bottom_sheet/show_bottom_sheet_home.dart';
import 'group/group_bottom_sheet.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.mapController,
    required this.locationListenCubit,
    required this.trackingMemberCubit,
    required this.moveToLocationUser,
  });
  final Completer<GoogleMapController> mapController;
  final TrackingLocationCubit locationListenCubit;
  final TrackingMemberCubit trackingMemberCubit;
  final void Function(LatLng) moveToLocationUser;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    widget.mapController.future.then((value) => _googleMapController = value);
    super.initState();
  }

  Future<void> _goToDetailLocation() async {
    //test
    getIt<SelectUserCubit>().update(null);
    final CameraPosition newPosition = CameraPosition(
      target: Global.instance.currentLocation,
      zoom: AppConstants.defaultCameraZoomLevel,
    );
    _googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<SelectUserCubit, StoreUser?>(
          bloc: getIt<SelectUserCubit>(),
          builder: (context, state) {
            if (state != null) {
              return GestureDetector(
                onTap: _goToDetailLocation,
                child: ShadowContainer(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  child: SvgPicture.asset(Assets.icons.icGps.path),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: _goToDetailLocation,
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
                  Assets.icons.icGps.path,
                  height: 20.r,
                  width: 20.r,
                ),
              ),
            ),
          ),
        ),
        18.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<GroupCubit, GroupState>(
                  bloc: getIt<GroupCubit>(),
                  builder: (context, state) {
                    return buildItem(
                        !getIt<GroupCubit>().myGroups.every((element) =>
                                element.seen == false || element.seen == null)
                            ? Assets.icons.icChatActive.path
                            : Assets.icons.icMessage.path,
                        context,
                        true);
                  }),
              16.horizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showAppModalBottomSheet(
                      context: context,
                      builder: (context) => const GroupBottomSheet(),
                    );
                  },
                  child: ShadowContainer(
                    maxWidth: MediaQuery.sizeOf(context).width - 80.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                    child: BlocBuilder<SelectGroupCubit, StoreGroup?>(
                      bloc: getIt<SelectGroupCubit>(),
                      builder: (context, state) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: MyColors.primary,
                              backgroundImage: AssetImage(state == null
                                  ? Assets.images.avatars.groups.group1.path
                                  : state.avatarGroup),
                              radius: 14.r,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  state == null
                                      ? context.l10n.newGroup
                                      : state.groupName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
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
                ),
              ),
              16.horizontalSpace,
              buildItem(Assets.icons.icSetting.path, context, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildItem(String path, BuildContext context, bool isMessage,
      {bool? avatar}) {
    return InkWell(
      onTap: () {
        //check xem có join group nào chưa
        if (isMessage) {
          if (getIt<SelectGroupCubit>().state != null) {
            context.pushRoute(const ChatRoute());
            return;
          } else {
            Fluttertoast.showToast(msg: context.l10n.joinAGroup);
            return;
          }
        }
        context.pushRoute(const SettingRoute());
      },
      child: Container(
        height: 48.r,
        width: 48.r,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          gradient: const LinearGradient(colors: [
            Color(0xffB67DFF),
            Color(0xff7B3EFF),
          ]),
        ),
        child: SvgPicture.asset(
          path,
          height: 22.r,
          width: 22.r,
        ),
      ),
    );
  }

  Widget _buildAvatar(String pathAvatar) {
    return ShadowContainer(
      child: Container(
        height: 72.r,
        width: 72.r,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.r),
          ),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.r),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          pathAvatar,
        ),
      ),
    );
  }
}
