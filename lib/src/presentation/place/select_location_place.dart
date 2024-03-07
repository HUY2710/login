import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../module/iap/my_purchase_manager.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_location/store_location.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../map/cubit/map_type_cubit.dart';
import 'bottom_sheet/search_place.dart';
import 'cubit/select_place_cubit.dart';

@RoutePage()
class SelectLocationPlaceScreen extends StatefulWidget {
  const SelectLocationPlaceScreen({super.key, required this.selectPlaceCubit});
  final SelectPlaceCubit selectPlaceCubit;
  @override
  State<SelectLocationPlaceScreen> createState() =>
      _SelectLocationPlaceScreenState();
}

class _SelectLocationPlaceScreenState extends State<SelectLocationPlaceScreen> {
  BitmapDescriptor? marker;
  BitmapDescriptor? defaultMarkerMap;
  ValueCubit<String> addressCubit = ValueCubit('...');
  ValueCubit<bool> requestApi = ValueCubit(false);
  ValueCubit<LatLng> placeLatLngCubit = ValueCubit(const LatLng(0, 0));
  LatLng _currentLocationOnMap = Global.instance.currentLocation;
  late final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  void initState() {
    _getMyMarker();
    super.initState();
  }

  Future<void> _getMyMarker() async {
    final newMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size.fromRadius(0.5.r),
        devicePixelRatio: ScreenUtil().pixelRatio,
      ),
      Assets.images.markers.circleDot.path,
    );
    final defaultMrk = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size.fromRadius(0.5.r),
        devicePixelRatio: ScreenUtil().pixelRatio,
      ),
      Assets.images.markers.pin.path,
    );

    setState(() {
      marker = newMarker;
      defaultMarkerMap = defaultMrk;
    });
  }

  void showModalSearchPlace() {
    showAppModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.white.withOpacity(0.2),
      builder: (context) => SearchPlaceBottomSheet(
        selectPlaceCubit: widget.selectPlaceCubit,
        addressCubit: addressCubit,
        placeLatLngCubit: placeLatLngCubit,
        requestApi: requestApi,
      ),
    ).then((value) {
      if (widget.selectPlaceCubit.state != null) {
        context.popRoute();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          BlocConsumer<ValueCubit<LatLng>, LatLng>(
            bloc: placeLatLngCubit,
            listener: (context, state) async {
              final controller = await _mapController.future;
              controller.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: state, zoom: 16),
              ));
            },
            builder: (context, state) {
              return BlocBuilder<ValueCubit<LatLng>, LatLng>(
                bloc: placeLatLngCubit,
                builder: (context, state) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: Global.instance.currentLocation,
                      zoom: 16,
                    ),
                    onMapCreated: (controller) {
                      _mapController.complete(controller);
                    },
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId('You'),
                        position: Global.instance.currentLocation,
                        icon: marker ?? BitmapDescriptor.defaultMarker,
                      ),
                      if (requestApi.state)
                        Marker(
                          markerId: const MarkerId('Place'),
                          position: state,
                          draggable: true,
                          icon: defaultMarkerMap ??
                              BitmapDescriptor.defaultMarker,
                        ),
                    },
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition position) {
                      if (!requestApi.state) {
                        _currentLocationOnMap = position.target;
                      }
                    },
                    onCameraIdle: () async {
                      if (!requestApi.state) {
                        final String address = await getIt<LocationService>()
                            .getCurrentAddress(_currentLocationOnMap);
                        addressCubit.update(address);
                        placeLatLngCubit.update(_currentLocationOnMap);
                      }
                    },
                    compassEnabled: false,
                    mapType: getIt<MapTypeCubit>().state,
                    myLocationButtonEnabled: false,
                  );
                },
              );
            },
          ),
          BlocBuilder<ValueCubit<bool>, bool>(
            bloc: requestApi,
            builder: (context, state) {
              if (!requestApi.state) {
                return Positioned(
                  child: Align(
                    child: FractionalTranslation(
                      translation: const Offset(0.0, -0.5),
                      child: Image.asset(
                        Assets.images.markers.pin.path,
                        width: 25.w,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight == 0
                ? 20.h
                : ScreenUtil().statusBarHeight,
            right: 16.w,
            left: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.popRoute(),
                  child: ShadowContainer(
                    padding: EdgeInsets.all(6.r),
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    child: SvgPicture.asset(
                      Assets.icons.iconBack.path,
                      width: 28.r,
                      height: 28.r,
                    ),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: ShadowContainer(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    child: BlocBuilder<ValueCubit<String>, String>(
                      bloc: addressCubit,
                      builder: (context, state) {
                        return Text(
                          state,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                ),
                16.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    widget.selectPlaceCubit.update(
                      StoreLocation(
                        address: addressCubit.state,
                        lat: placeLatLngCubit.state.latitude,
                        lng: placeLatLngCubit.state.longitude,
                        updatedAt: DateTime.now(),
                      ),
                    );
                    context.popRoute<bool>(true);
                  },
                  child: ShadowContainer(
                    padding: EdgeInsets.all(6.r),
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    child: SvgPicture.asset(
                      Assets.icons.icChecked.path,
                      width: 28.r,
                      height: 28.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 35.h,
            right: 16.w,
            left: 16.w,
            child: BlocBuilder<MyPurchaseManager, PurchaseState>(
              builder: (context, statePurchase) {
                return GestureDetector(
                  onTap: () async {
                    if (statePurchase.isPremium()) {
                      showModalSearchPlace();
                    } else {
                      context.pushRoute(PremiumRoute());
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: ShadowContainer(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.icons.icSearch.path,
                                height: 24.r,
                                width: 24.r,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  context.l10n.searchLocationByType,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              6.horizontalSpace,
                              if (!statePurchase.isPremium())
                                SvgPicture.asset(
                                  Assets.icons.icPremium.path,
                                  height: 24.r,
                                  width: 24.r,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
