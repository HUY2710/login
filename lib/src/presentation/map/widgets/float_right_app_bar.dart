import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../home/widgets/bottom_sheet/members/members.dart';
import '../../home/widgets/bottom_sheet/places/places_bottom_sheet.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../cubit/select_group_cubit.dart';
import '../cubit/tracking_location/tracking_location_cubit.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';

class FloatRightAppBar extends StatefulWidget {
  const FloatRightAppBar({
    super.key,
    required this.mapController,
    required this.locationListenCubit,
    required this.trackingMemberCubit,
  });

  final Completer<GoogleMapController> mapController;
  final TrackingLocationCubit locationListenCubit;
  final TrackingMemberCubit trackingMemberCubit;

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

  void _goToCurrentLocation() {
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
        buildItem(
          () async {
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
        buildItem(_goToCurrentLocation, Assets.icons.icGps.path),
        SizedBox(height: 16.h),
        buildItem(() {
          if (getIt<SelectGroupCubit>().state == null) {
            Fluttertoast.showToast(msg: 'Please join group first');
            return;
          }
          showBottomSheetTypeOfHome(
            context: context,
            child: const PlacesBottomSheet(),
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
