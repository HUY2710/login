import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../config/di/di.dart';
import '../../../data/models/location/location_model.dart';
import '../../../data/models/places/place_model.dart';
import '../../../data/models/store_location/store_location.dart';
import '../../../global/global.dart';
import '../../../services/http_service.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/helpers/map_helper.dart';
import '../../../shared/widgets/my_drag.dart';
import '../../onboarding/widgets/app_button.dart';
import '../cubit/location_request_place_cubit.dart';
import '../cubit/near_by_place_cubit.dart';
import '../cubit/select_place_cubit.dart';
import '../widgets/item_near_by_place.dart';

class SearchPlaceBottomSheet extends StatefulWidget {
  const SearchPlaceBottomSheet({super.key, required this.selectPlaceCubit});
  final SelectPlaceCubit selectPlaceCubit;
  @override
  State<SearchPlaceBottomSheet> createState() => _SearchPlaceBottomSheetState();
}

class _SearchPlaceBottomSheetState extends State<SearchPlaceBottomSheet> {
  final TextEditingController searchPlaceCtrl = TextEditingController();
  List<Place> listPlaceNearBy = [];
  Future<void> fetchData() async {
    final Map<String, dynamic> body = {
      'maxResultCount': 10,
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': Global.instance.currentLocation.latitude,
            'longitude': Global.instance.currentLocation.longitude
          },
          'radius': 100.0
        }
      }
    };
    try {
      getIt<LocationRequestPlaceCubit>().update(
        LocationModel(
          latitude: Global.instance.currentLocation.latitude,
          longitude: Global.instance.currentLocation.longitude,
        ),
      );
      final response = await HTTPService().postRequestPlaces(body);
      if (response.statusCode == 200) {
        // Nếu yêu cầu thành công (status code 200), bạn có thể xử lý dữ liệu ở đây
        print('Response body: ${response.body}');
        final Map<String, dynamic> result = jsonDecode(response.body);
        final PlaceModel places = PlaceModel.fromJson(result);
        getIt<NearByPlaceCubit>().update(places.places);

        setState(() {
          listPlaceNearBy = places.places;
        });
      } else {
        // Nếu yêu cầu không thành công, bạn có thể xử lý lỗi ở đây
        print('Request failed with status: ${response.statusCode}');
        debugPrint('Request failed with status: ${response.body}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có lỗi xảy ra trong quá trình thực hiện yêu cầu
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationAndRequest();
  }

  //kiểm tra xem vị trí request place lần trước với hiện tại có >100m không
  Future<void> checkLocationAndRequest() async {
    final oldLocationRequest = getIt<LocationRequestPlaceCubit>().state;

    //
    if (oldLocationRequest != null) {
      final result = MapHelper.isWithinRadius(
        LatLng(oldLocationRequest.latitude, oldLocationRequest.longitude),
        Global.instance.currentLocation,
        100,
      );
      debugPrint('${Global.instance.currentLocation}');
      debugPrint(
          '${LatLng(oldLocationRequest.latitude, oldLocationRequest.longitude)}');
      //đúng khi còn nằm trong bán kính
      if (result && getIt<NearByPlaceCubit>().state != null) {
        setState(() {
          listPlaceNearBy = getIt<NearByPlaceCubit>().state!;
        });
      } else {
        await fetchData();
      }
    } else {
      await fetchData();
    }
  }

  StoreLocation locationPlace =
      StoreLocation(address: '', lat: 0, lng: 0, updatedAt: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          Expanded(
            child: listPlaceNearBy.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: listPlaceNearBy.length,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemBuilder: (context, index) {
                      final place = listPlaceNearBy[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            locationPlace = StoreLocation(
                              address: place.displayName.text,
                              lat: place.location.latitude,
                              lng: place.location.longitude,
                              updatedAt: DateTime.now(),
                            );
                          });
                        },
                        child: ItemNearByPlace(
                          namePlace: listPlaceNearBy[index].displayName.text,
                          isSelect:
                              locationPlace.lat == place.location.latitude,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                  ),
          ),
          AppButton(
            title: 'Add Location',
            heightBtn: 44.h,
            paddingVertical: 10.h,
            isEnable: locationPlace.lat != 0,
            onTap: locationPlace.lat != 0
                ? () {
                    widget.selectPlaceCubit.update(locationPlace);
                    context.popRoute();
                  }
                : () {},
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
