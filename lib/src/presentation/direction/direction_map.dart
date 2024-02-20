import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/routes/route_model.dart';
import '../../data/models/store_user/store_user.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/http_service.dart';
import '../../shared/enum/route_travel.dart';
import '../../shared/helpers/map_helper.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../../shared/widgets/my_drag.dart';
import '../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../map/cubit/tracking_routes/tracking_routes_cubit.dart';
import '../onboarding/widgets/app_button.dart';
import 'info_direction.dart';

class DirectionMap extends StatefulWidget {
  const DirectionMap({super.key, required this.user});
  final StoreUser user;

  @override
  State<DirectionMap> createState() => _DirectionMapState();
}

class _DirectionMapState extends State<DirectionMap> {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> _polylines = {};
  String typeDirection = RouteTravelMode.DRIVE.name;
  double distance = 0;
  double duration = 0;
  Future<void> _openMap({
    required double lat,
    required double lng,
    required String name,
  }) async {
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    await openMapWithDestination(
      lat: lat,
      long: lng,
      title: name,
    );
  }

  Future<void> testRequest() async {
    final Map<String, dynamic> body = {
      'origin': {
        'location': {
          'latLng': {
            'latitude': Global.instance.currentLocation.latitude,
            'longitude': Global.instance.currentLocation.longitude
          }
        }
      },
      'destination': {
        'location': {
          'latLng': {
            'latitude': widget.user.location?.lat,
            'longitude': widget.user.location?.lng
          }
        }
      },
      'travelMode': typeDirection,
      'routingPreference': 'TRAFFIC_AWARE'
    };
    final response = await HTTPService().postRequestRoutes(body);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final Map<String, dynamic> result = jsonDecode(response.body);
      final RouteModel routeModel = RouteModel.fromJson(result['routes'][0]);
      _getPolyline(routeModel.polyline.encodedPolyline);
    } else {
      // Nếu yêu cầu không thành công, bạn có thể xử lý lỗi ở đây
      print('Request failed with status: ${response.statusCode}');
      debugPrint('Request failed with status: ${response.body}');
    }
  }

  Future<void> _getPolyline(String endCodePolyline) async {
    final List<PointLatLng> result =
        polylinePoints.decodePolyline(endCodePolyline);

    if (result.isNotEmpty) {
      for (final point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    getIt<TrackingRoutesCubit>().update(<Polyline>{
      Polyline(
        polylineId: const PolylineId('poly'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 3,
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      typeDirection = RouteTravelMode.WALK.name;
                    });
                  },
                  child: Stack(
                    children: [
                      ShadowContainer(
                        opacityColor: 0.15,
                        colorShadow: typeDirection == RouteTravelMode.WALK.name
                            ? const Color(0xff7B3EFF).withOpacity(0.8)
                            : null,
                        child: Padding(
                          padding: EdgeInsets.all(20.r),
                          child: SvgPicture.asset(
                            Assets.icons.activity.walking.path,
                            height: 32.r,
                            width: 32.r,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: ShadowContainer(
                          padding: EdgeInsets.all(6.r),
                          child: SvgPicture.asset(
                            Assets.icons.icPremium.path,
                            width: 120.r,
                            height: 12.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      typeDirection = RouteTravelMode.BICYCLE.name;
                    });
                  },
                  child: Stack(
                    children: [
                      ShadowContainer(
                        opacityColor: 0.15,
                        colorShadow:
                            typeDirection == RouteTravelMode.BICYCLE.name
                                ? const Color(0xff7B3EFF).withOpacity(0.8)
                                : null,
                        child: Padding(
                          padding: EdgeInsets.all(20.r),
                          child: SvgPicture.asset(
                            Assets.icons.activity.bicycle.path,
                            height: 32.r,
                            width: 32.r,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: ShadowContainer(
                          padding: EdgeInsets.all(6.r),
                          child: SvgPicture.asset(
                            Assets.icons.icPremium.path,
                            width: 120.r,
                            height: 12.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      typeDirection = RouteTravelMode.DRIVE.name;
                    });
                  },
                  child: Stack(
                    children: [
                      ShadowContainer(
                        opacityColor: 0.15,
                        colorShadow: typeDirection == RouteTravelMode.DRIVE.name
                            ? const Color(0xff7B3EFF).withOpacity(0.8)
                            : null,
                        child: Padding(
                          padding: EdgeInsets.all(20.r),
                          child: SvgPicture.asset(
                            Assets.icons.activity.car.path,
                            height: 32.r,
                            width: 32.r,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: ShadowContainer(
                          padding: EdgeInsets.all(6.r),
                          child: SvgPicture.asset(
                            Assets.icons.icPremium.path,
                            width: 120.r,
                            height: 12.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          32.verticalSpace,
          AppButton(
            title: 'Get Directions in app',
            paddingVertical: 12.h,
            heightBtn: 44.h,
            onTap: () async {
              EasyLoading.show();
              try {
                //xử lí với premium
                testRequest().then((value) => context.popRoute());
              } catch (error) {}
              EasyLoading.dismiss();
            },
          ),
          16.verticalSpace,
          AppButton(
              title: 'Get Directions on Maps',
              paddingVertical: 12.h,
              heightBtn: 44.h,
              onTap: () {
                //
                if (widget.user.location != null) {
                  _openMap(
                    lat: widget.user.location!.lat,
                    lng: widget.user.location!.lng,
                    name: widget.user.userName,
                  );
                }
              })
        ],
      ),
    );
  }
}
