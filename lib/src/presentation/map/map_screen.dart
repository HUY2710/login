import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_group/store_group.dart';
import '../../data/models/store_place/store_place.dart';
import '../../data/models/store_user/store_user.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../global/global.dart';
import '../../services/my_background_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../../shared/widgets/containers/custom_container.dart';
import '../chat/cubits/group_cubit.dart';
import '../home/widgets/bottom_bar.dart';
import '../permission/widget/permission_dialog.dart';
import 'cubit/map_type_cubit.dart';
import 'cubit/select_group_cubit.dart';
import 'cubit/tracking_location/tracking_location_cubit.dart';
import 'cubit/tracking_members/tracking_member_cubit.dart';
import 'cubit/tracking_places/tracking_places_cubit.dart';
import 'cubit/tracking_routes/tracking_routes_cubit.dart';
import 'widgets/custom_map.dart';
import 'widgets/float_right_app_bar.dart';
import 'widgets/member_marker_list.dart';
import 'widgets/place_mark_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen>
    with WidgetsBindingObserver, PermissionMixin {
  LatLng _defaultLocation = const LatLng(0, 0);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final MapTypeCubit _mapTypeCubit = getIt<MapTypeCubit>();
  GoogleMapController? _controller;
  BitmapDescriptor? marker;
  final _trackingMemberCubit = getIt<TrackingMemberCubit>();
  final _trackingPlacesCubit = getIt<TrackingPlacesCubit>();

  //all-cubit
  final TrackingLocationCubit _trackingLocationCubit =
      getIt<TrackingLocationCubit>();

  bool _isInit = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initStart();
    _trackingMemberCubit.initTrackingMember();
    _trackingPlacesCubit.initTrackingPlaces();
    _defaultLocation = Global.instance.serverLocation;
    getLocalLocation();
    _getMyMarker();
    super.initState();

    getIt<GroupCubit>().initStreamGroupChat();
  }

  void getLocalLocation() {
    if (Global.instance.serverLocation != const LatLng(0, 0)) {
      _defaultLocation = LatLng(
        Global.instance.serverLocation.latitude,
        Global.instance.serverLocation.longitude,
      );
      _moveToCurrentLocation(_defaultLocation);
    }
  }

  // move đến màn permission nếu chưa cấp phép
  Future<void> navigateToPermission() async {
    await context.pushRoute(PermissionRoute(fromMapScreen: true));
  }

  Future<void> _initStart() async {
    final bool statusLocation = await checkPermissionLocation();
    if (!statusLocation) {
      await navigateToPermission();
      final bool checkAgain = await checkPermissionLocation();
      if (checkAgain) {
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
      CameraPosition(target: latLng, zoom: AppConstants.defaultCameraZoomLevel),
    ));
  }

  //listen location in foreground
  Future<void> _listenLocation() async {
    _trackingLocationCubit.listenLocation();
    final statusLocationAlway = await statusLocationAlways();
    //nếu đã cấp quyền
    if (statusLocationAlway) {
      _listenBackGroundMode();
    } else {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context1) => PermissionDialog(
            title: context.l10n.permissionsGreate,
            subTitle: context.l10n.permissionsGreateSub,
            confirmTap: () async {
              context1.popRoute();
              final rejectAlway =
                  await Permission.locationAlways.isPermanentlyDenied;
              if (rejectAlway) {
                openAppSettings();
              }
              final status = await Permission.locationAlways.request();
              if (status.isGranted) {
                _listenBackGroundMode();
              }
              debugPrint('status:$status');
            },
            confirmText: context.l10n.change,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 16.w,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 213.w,
                      height: 166.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffABABAB).withOpacity(0.3),
                            )
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Allow “Cycle sharing” to also your location even when you are not using app?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyColors.black34,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          14.verticalSpace,
                          Text(
                            'Just keep it when in use',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyColors.color6C6C6C,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14.h,
                    left: 0,
                    right: 0,
                    child: CustomContainer(
                      width: 260.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      colorBg: Colors.white,
                      child: const Center(
                        child: Text('Change to always allow'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  //show dialog alway permission

  //kiểm tra xem user có cấp quyền chạy ở background hay không
  Future<void> _listenBackGroundMode() async {
    final always = await Permission.locationAlways.status.isGranted;
    if (always) {
      getIt<MyBackgroundService>().initialize();
    }
  }

  Future<void> _getMyMarker() async {
    final newMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size.fromRadius(0.5.r),
        // devicePixelRatio: ScreenUtil().pixelRatio,
      ),
      Assets.images.markers.circleDot.path,
    );
    setState(() {
      marker = newMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              child: BlocBuilder<TrackingMemberCubit, TrackingMemberState>(
                bloc: _trackingMemberCubit,
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    initial: () {
                      return const SizedBox();
                    },
                    success: (List<StoreUser> users) {
                      debugPrint('listUser:${users.length}');
                      if (users.isNotEmpty) {
                        return MemberMarkerList(
                          key: ValueKey(getIt<SelectGroupCubit>().state),
                          trackingMemberCubit: _trackingMemberCubit,
                        );
                      }
                      return const SizedBox();
                    },
                  );
                  // return MemberMarkerList(
                  //   key: ValueKey(getIt<SelectGroupCubit>().state),
                  //   trackingMemberCubit: _trackingMemberCubit,
                  // );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              child: BlocBuilder<TrackingPlacesCubit, TrackingPlacesState>(
                bloc: _trackingPlacesCubit,
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    initial: () {
                      return const SizedBox();
                    },
                    success: (List<StorePlace> places) {
                      if (places.isNotEmpty) {
                        return PlacesMarkerList(
                          trackingPlacesCubit: _trackingPlacesCubit,
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white),
          ),
          BlocConsumer<TrackingLocationCubit, TrackingLocationState>(
            bloc: _trackingLocationCubit,
            listener: _listenLocationCubit,
            builder: (context, locationState) {
              return BlocConsumer<SelectGroupCubit, StoreGroup?>(
                bloc: getIt<SelectGroupCubit>(),
                listener: (context, state) {
                  //thoát nhóm hoặc chưa chọn nhóm
                  if (state == null) {
                    _trackingMemberCubit.disposeGroupSubscription();
                    _trackingMemberCubit.disposeMarkerSubscription();
                    _trackingMemberCubit.resetData();
                    _trackingPlacesCubit.resetData();
                  } else {
                    _trackingMemberCubit.initTrackingMember();
                    _trackingPlacesCubit.initTrackingPlaces();
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<TrackingMemberCubit, TrackingMemberState>(
                    bloc: _trackingMemberCubit,
                    builder: (context, trackingMemberState) {
                      return BlocBuilder<MapTypeCubit, MapType>(
                        bloc: _mapTypeCubit,
                        builder: (context, MapType mapTypeState) {
                          return BlocBuilder<TrackingPlacesCubit,
                              TrackingPlacesState>(
                            bloc: _trackingPlacesCubit,
                            builder: (context, trackingPlacesState) {
                              return BlocBuilder<TrackingRoutesCubit,
                                  Set<Polyline>?>(
                                bloc: getIt<TrackingRoutesCubit>(),
                                builder: (context, polylinesState) {
                                  return CustomMap(
                                    defaultLocation: _defaultLocation,
                                    trackingLocationState: locationState,
                                    mapController: _mapController,
                                    mapType: mapTypeState,
                                    marker: marker,
                                    trackingMemberState: trackingMemberState,
                                    trackingPlacesState: trackingPlacesState,
                                    polylines: polylinesState,
                                  );
                                },
                              );
                            },
                          );
                        },
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
              locationListenCubit: _trackingLocationCubit,
            ),
          ),
          Positioned(
            bottom: 55.h,
            left: 0,
            right: 0,
            child: BottomBar(
              locationListenCubit: _trackingLocationCubit,
              mapController: _mapController,
              trackingMemberCubit: _trackingMemberCubit,
              moveToLocationUser: _moveToCurrentLocation,
            ),
          ),
        ],
      ),
    );
  }

  void _listenLocationCubit(BuildContext context, TrackingLocationState state) {
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

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    _trackingPlacesCubit.dispose();
    _trackingMemberCubit.dispose();
    _trackingLocationCubit.cancelListener();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
