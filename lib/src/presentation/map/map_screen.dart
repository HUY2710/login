import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/di/di.dart';
import '../../data/models/store_group/store_group.dart';
import '../../global/global.dart';
import '../../services/my_background_service.dart';
import '../../shared/helpers/capture_widget_helper.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../home/widgets/bottom_bar.dart';
import 'cubit/select_group_cubit.dart';
import 'widgets/custom_map.dart';
import 'cubit/location_listen/location_listen_cubit.dart';
import 'cubit/map_type_cubit.dart';
import 'cubit/tracking_members/tracking_member_cubit.dart';
import 'widgets/float_right_app_bar.dart';
import 'widgets/member_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with PermissionMixin {
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

  bool _isInit = false;

  @override
  void initState() {
    _initStart();
    _defaultLocation = Global.instance.location;
    getLocalLocation();
    super.initState();
  }

  void getLocalLocation() {
    if (Global.instance.location != const LatLng(0, 0)) {
      _defaultLocation = LatLng(
        Global.instance.location.latitude,
        Global.instance.location.longitude,
      );
      _moveToCurrentLocation(_defaultLocation);
    }
  }

  Future<void> _initStart() async {
    final bool statusLocation =
        await checkPermissionLocation(); // check permission location
    if (!statusLocation) {
      final requestLocation =
          await requestPermissionLocation(); //request permission location
      if (requestLocation) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          _init();
        });
      }
    } else {
      //exist permission
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        _init();
      });
    }
  }

  Future<void> _init() async {
    if (!_isInit) {
      _listenLocation();
      _isInit = true;
    }
  }

  Future<void> _moveToCurrentLocation(LatLng latLng) async {
    _controller ??= await _mapController.future;
    _controller?.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 16),
    ));
  }

  //listen location in foreground
  Future<void> _listenLocation() async {
    _locationListenCubit.listenLocation();
    final requestBackground = await Permission.locationAlways.request();
    if (requestBackground.isGranted) {
      _listenBackGroundMode();
    }
  }

  //kiểm tra xem user có cấp quyền chạy ở background hay không
  Future<void> _listenBackGroundMode() async {
    final always = await Permission.locationAlways.status.isGranted;
    if (always) {
      getIt<MyBackgroundService>().initialize();
    }
  }

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
          Positioned.fill(
            child: Container(color: Colors.white),
          ),
          BlocConsumer<LocationListenCubit, LocationListenState>(
            bloc: _locationListenCubit,
            listener: _listenLocationCubit,
            builder: (context, locationListenState) {
              return BlocConsumer<SelectGroupCubit, StoreGroup?>(
                bloc: getIt<SelectGroupCubit>(),
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state != null) {
                    _trackingMemberCubit.initTrackingMember();
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<MapTypeCubit, MapType>(
                    bloc: _mapTypeCubit,
                    builder: (context, MapType mapTypeState) {
                      return CustomMap(
                        defaultLocation: _defaultLocation,
                        locationListenState: locationListenState,
                        mapController: _mapController,
                        mapType: mapTypeState,
                        marker: marker,
                      );
                    },
                  );
                },
              );
            },
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight == 0
                ? 20.h
                : ScreenUtil().statusBarHeight,
            right: 16.w,
            bottom: 0,
            child: FloatRightAppBar(
              mapController: _mapController,
              locationListenCubit: _locationListenCubit,
            ),
          ),
          Positioned(
            bottom: 55.h,
            left: 0,
            right: 0,
            child: BottomBar(
              locationListenCubit: _locationListenCubit,
              mapController: _mapController,
              trackingMemberCubit: _trackingMemberCubit,
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
