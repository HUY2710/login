// ignore_for_file: prefer_void_to_null

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../home/widgets/bottom_sheet/places/places_bottom_sheet.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../cubit/location_listen/location_listen_cubit.dart';
import 'map_type_selector.dart';

class FloatRightAppBar extends StatefulWidget {
  const FloatRightAppBar({
    super.key,
    required this.mapController,
    required this.locationListenCubit,
  });
  final Completer<GoogleMapController> mapController;
  final LocationListenCubit locationListenCubit;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildItem(() {
          context.pushRoute(const SettingRoute());
        }, Assets.icons.icSetting.path),
        16.verticalSpace,
        BlocBuilder<LocationListenCubit, LocationListenState>(
          bloc: widget.locationListenCubit,
          builder: (context, state) {
            return buildItem(() {
              showBottomSheetTypeOfHome(
                  context: context, child: const PlacesBottomSheet());
            }, Assets.icons.icLocation.path);
          },
        ),
        16.verticalSpace,
        buildItem(
          () async {
            await showBottomSheetTypeOfHome(
              context: context,
              child: const MapTypeSelector(),
            );
          },
          Assets.icons.icMap.path,
        ),
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
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff42474C).withOpacity(0.3),
                blurRadius: 17,
              )
            ]),
        child: SvgPicture.asset(
          pathIc,
          height: 20.r,
          width: 20.r,
        ),
      ),
    );
  }

  Null _animateCurrentLocation(LocationListenState state) {
    return state.maybeWhen(success: (latLng) {
      final CameraPosition newPosition = CameraPosition(
        target: latLng,
        zoom: AppConstants.defaultCameraZoomLevel,
      );
      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          newPosition,
        ),
      );
      return null;
    }, orElse: () {
      final LatLng newLatLong = LatLng(
        Global.instance.location.latitude,
        Global.instance.location.latitude,
      );
      final CameraPosition newPosition = CameraPosition(
        target: newLatLong,
        zoom: AppConstants.defaultCameraZoomLevel,
      );
      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          newPosition,
        ),
      );
      return null;
    });
  }
}
