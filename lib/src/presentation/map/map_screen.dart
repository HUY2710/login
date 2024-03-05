import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_group/store_group.dart';
import '../../data/models/store_location/store_location.dart';
import '../../data/models/store_place/store_place.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/firestore_client.dart';
import '../../data/remote/token_manager.dart';
import '../../global/global.dart';
import '../../services/my_background_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../chat/cubits/group_cubit.dart';
import '../home/widgets/bottom_bar.dart';
import '../permission/widget/permission_home_android.dart';
import '../permission/widget/permission_home_ios.dart';
import 'cubit/map_type_cubit.dart';
import 'cubit/select_group_cubit.dart';
import 'cubit/tracking_location/tracking_location_cubit.dart';
import 'cubit/tracking_members/tracking_member_cubit.dart';
import 'cubit/tracking_places/tracking_places_cubit.dart';
import 'cubit/tracking_routes/tracking_routes_cubit.dart';
import 'cubit/user_map_visibility/user_map_visibility_cubit.dart';
import 'widgets/custom_map.dart';
import 'widgets/float_right_app_bar.dart';
import 'widgets/member_marker_list.dart';
import 'widgets/place_mark_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.latLng});

  final Map<String, double>? latLng;

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
    FirestoreClient.instance.updateUser({'online': true});
    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) {
      FirestoreClient.instance.updateUser({'online': !isBackground});
    });
    _initStart();
    _trackingMemberCubit.initTrackingMember();
    _trackingPlacesCubit.initTrackingPlaces();
    _defaultLocation = Global.instance.serverLocation;
    getLocalLocation();
    super.initState();

    getIt<GroupCubit>().initStreamGroupChat();
    TokenManager.updateMyFCMToken();
  }

  void getLocalLocation() {
    if (widget.latLng != null) {
      _moveToCurrentLocation(
          LatLng(widget.latLng!['lat']!, widget.latLng!['lng']!));
    } else {
      if (Global.instance.serverLocation != const LatLng(0, 0)) {
        _defaultLocation = LatLng(
          Global.instance.serverLocation.latitude,
          Global.instance.serverLocation.longitude,
        );
        _moveToCurrentLocation(_defaultLocation);
      }
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
            builder: (context1) {
              if (Platform.isIOS) {
                return PermissionHomeIOS(
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
                  },
                );
              }
              return PermissionHomeAndroid(
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
                },
                confirmText: context.l10n.goToSettings,
              );
            });
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
                listenWhen: (previous, current) =>
                    previous?.idGroup != current?.idGroup,
                listener: (context, state) async {
                  //thoát nhóm hoặc chưa chọn nhóm
                  if (state == null) {
                    _trackingMemberCubit.disposeGroupSubscription();
                    _trackingMemberCubit.disposeMarkerSubscription();
                    _trackingMemberCubit.resetData();
                    _trackingPlacesCubit.resetData();
                  } else {
                    _trackingMemberCubit.initTrackingMember();
                    _trackingPlacesCubit.initTrackingPlaces();
                    getIt<UserMapVisibilityCubit>().updateList([]);
                  }
                },
                buildWhen: (previous, current) =>
                    previous?.idGroup != current?.idGroup,
                builder: (context, state) {
                  return BlocConsumer<TrackingMemberCubit, TrackingMemberState>(
                    bloc: _trackingMemberCubit,
                    listener: (context, state) async {
                      final mapController = await _mapController.future;
                      mapController
                          .getVisibleRegion()
                          .then((visibleRegion) async {
                        state.maybeWhen(
                          orElse: () {},
                          initial: () {},
                          success: (List<StoreUser> members) {
                            final List<StoreUser> temp = List.from(
                                getIt<UserMapVisibilityCubit>().state ?? []);
                            for (final member in members) {
                              StoreUser tempMember = member;
                              final memberExists = temp.indexWhere(
                                  (element) => element.code == member.code);
                              if (member.location == null &&
                                  member.code != Global.instance.userCode) {
                                return;
                              }

                              final LatLng latLngMember = LatLng(
                                  member.location?.lat ?? 0,
                                  member.location?.lng ?? 0);
                              if (!visibleRegion.contains(
                                  member.code == Global.instance.userCode
                                      ? Global.instance.currentLocation
                                      : latLngMember)) {
                                if (memberExists == -1) {
                                  if (member.code == Global.instance.userCode) {
                                    tempMember = member.copyWith(
                                      location: StoreLocation(
                                        address: '',
                                        lat: Global
                                            .instance.currentLocation.latitude,
                                        lng: Global
                                            .instance.currentLocation.longitude,
                                        updatedAt: DateTime.now(),
                                      ),
                                    );
                                    temp.add(tempMember);
                                  } else {
                                    temp.add(member);
                                  }
                                }
                              } else {
                                if (memberExists != -1) {
                                  temp.removeAt(memberExists);
                                }
                              }
                            }
                            getIt<UserMapVisibilityCubit>()
                                .updateList([...temp]);
                          },
                        );
                      });
                    },
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
              locationListenCubit: _trackingLocationCubit,
              trackingMemberCubit: _trackingMemberCubit,
              mapController: _mapController,
            ),
          ),
          Positioned(
            bottom: 55.h,
            left: 16.w,
            right: 16.w,
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
