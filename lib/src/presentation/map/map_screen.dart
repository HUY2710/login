import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/di/di.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../shared/helpers/capture_widget_helper.dart';
import '../home/widgets/bottom_bar.dart';
import '../home/widgets/maps/custom_map.dart';
import 'cubit/location_listen/location_listen_cubit.dart';
import 'cubit/map_type_cubit.dart';
import 'cubit/tracking_members/tracking_member_cubit.dart';
import 'widgets/member_marker.dart';
import 'widgets/member_marker_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng _defaultLocation = const LatLng(0, 0);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final MapTypeCubit _mapTypeCubit = getIt<MapTypeCubit>();
  GoogleMapController? _controller;
  BitmapDescriptor? marker;
  final _trackingMemberCubit = getIt<TrackingMemberCubit>();
  final GlobalKey<State<StatefulWidget>> myKey =
      GlobalKey<State<StatefulWidget>>();

  //all-cubit
  final LocationListenCubit _locationListenCubit = getIt<LocationListenCubit>();
  @override
  void initState() {
    getLocationDemo();
    super.initState();
  }

  Future<void> getLocationDemo() async {
    final latLog = await getIt<LocationService>().getCurrentLocation();
    setState(() {
      _defaultLocation = latLog;
    });
  }

  Future<void> _moveToCurrentLocation(LatLng latLng) async {
    _controller ??= await _mapController.future;
    _controller?.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 16),
    ));
  }

  //listen location in foreground
  // Future<void> _listenLocation() async {
  //   final locationStatus = await _permissionManager.requestLocationPermission();
  //   if (locationStatus) {
  //     _locationListenCubit.listenLocation();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              child: BuildMarker(
                index: 0,
                member: Global.instance.user!,
                callBack: () async {
                  final Uint8List? bytes =
                      await CaptureWidgetHelp.widgetToBytes(myKey);

                  if (bytes != null) {
                    setState(() {
                      marker = BitmapDescriptor.fromBytes(
                        bytes,
                        size: const Size.fromWidth(30),
                      );
                    });
                  }
                },
                keyCap: myKey,
              ),
            ),
          ),
          BlocConsumer<LocationListenCubit, LocationListenState>(
            bloc: _locationListenCubit,
            listener: _listenLocationCubit,
            builder: (context, state) {
              return BlocBuilder<MapTypeCubit, MapType>(
                bloc: _mapTypeCubit,
                builder: (context, MapType mapTypeState) {
                  return CustomMap(
                    defaultLocation: _defaultLocation,
                    mapController: _mapController,
                    mapType: mapTypeState,
                    marker: marker,
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 55.h,
            left: 0,
            right: 0,
            child: BottomBar(
              mapController: _mapController,
            ),
          )
        ],
      ),
    );
  }

  void _listenLocationCubit(BuildContext context, LocationListenState state) {
    state.whenOrNull(
      success: (latLng) async {
        if (_defaultLocation.latitude == 0 && _defaultLocation.longitude == 0) {
          _moveToCurrentLocation(latLng);
        }
        setState(() {
          _defaultLocation = latLng;
        });
      },
    );
  }
}
