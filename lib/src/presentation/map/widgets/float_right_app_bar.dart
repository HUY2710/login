import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/extension/context_extension.dart';
import '../../home/cubit/banner_collapse_cubit.dart';
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
    required this.mapController,
  });

  final TrackingLocationCubit locationListenCubit;
  final TrackingMemberCubit trackingMemberCubit;
  final Completer<GoogleMapController> mapController;

  @override
  State<FloatRightAppBar> createState() => _FloatRightAppBarState();
}

class _FloatRightAppBarState extends State<FloatRightAppBar> {
  GoogleMapController? _googleMapController;
  @override
  void initState() {
    widget.mapController.future.then((value) => _googleMapController = value);
    super.initState();
  }

  Future<void> _goToMemberLocation(StoreUser user) async {
    final CameraPosition newPosition = CameraPosition(
      target: LatLng(user.location!.lat, user.location!.lng),
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
        BlocBuilder<SelectGroupCubit, StoreGroup?>(
          bloc: getIt<SelectGroupCubit>(),
          builder: (context, state) {
            return buildItem(
              state == null
                  ? () {
                      Fluttertoast.showToast(msg: context.l10n.joinAGroup);
                      return;
                    }
                  : () {
                      getIt<BannerCollapseAdCubit>().update(false);
                      showAppModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              InviteCode(code: state.passCode)).then(
                        (value) => getIt<BannerCollapseAdCubit>().update(true),
                      );
                    },
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
            getIt<BannerCollapseAdCubit>().update(false);
            showAppModalBottomSheet(
              context: context,
              builder: (context) {
                return MembersBottomSheet(
                  trackingMemberCubit: widget.trackingMemberCubit,
                  goToUserLocation: (user) => _goToMemberLocation(user),
                );
              },
            ).then((value) => getIt<BannerCollapseAdCubit>().update(true));
          },
          Assets.icons.icPeople.path,
        ),
        SizedBox(height: 16.h),
        buildItem(() {
          if (getIt<SelectGroupCubit>().state == null) {
            Fluttertoast.showToast(msg: context.l10n.joinAGroup);
            return;
          }
          getIt<BannerCollapseAdCubit>().update(false);
          showAppModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const PlacesBottomSheet(),
          ).then((value) => getIt<BannerCollapseAdCubit>().update(true));
        }, Assets.icons.icPlace.path),
        SizedBox(height: 16.h),
        buildSOS()
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
          borderRadius:
              BorderRadius.circular(AppConstants.widgetBorderRadius.r),
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

  Widget buildSOS() {
    return GestureDetector(
      onTap: () async {
        // context.pushRoute(const SosRoute());
        // print(FirebaseAuth.instance.currentUser);
        // print(Global.instance.user);

        print(Global.instance.group);
      },
      child: Image.asset(
        Assets.images.sosBtn.path,
        width: 40.r,
        height: 40.r,
        fit: BoxFit.cover,
      ),
    );
  }
}
