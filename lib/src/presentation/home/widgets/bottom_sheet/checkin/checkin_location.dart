import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../config/di/di.dart';
import '../../../../../data/models/location/location_model.dart';
import '../../../../../data/models/places/place_model.dart';
import '../../../../../gen/gens.dart';
import '../../../../../global/global.dart';
import '../../../../../services/http_service.dart';
import '../../../../../shared/helpers/map_helper.dart';
import '../../../../../shared/widgets/custom_inkwell.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../place/cubit/location_request_place_cubit.dart';
import '../../../../place/cubit/near_by_place_cubit.dart';
import 'widgets/check_in_dialog.dart';

class CheckInLocation extends StatefulWidget {
  const CheckInLocation({super.key});

  @override
  State<CheckInLocation> createState() => _CheckInLocationState();
}

class _CheckInLocationState extends State<CheckInLocation> {
  List<Place> listPlaceNearBy = [];
  @override
  void initState() {
    checkLocationAndRequest();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      child: Column(
        children: [
          const MyDrag(),
          20.h.verticalSpace,
          Expanded(
            child: buildListPlace(),
          )
        ],
      ),
    );
  }

  Widget buildListPlace() {
    return ListView.separated(
        // shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildButtonCurrentLc();
          }
          return CustomInkWell(
            onTap: () {},
            child: buildButtonPremium(listPlaceNearBy[index - 1]),
          );
        },
        separatorBuilder: (context, index) {
          return 16.h.verticalSpace;
        },
        itemCount: listPlaceNearBy.length + 1);
  }

  Widget buildButtonPremium(Place item) {
    return CustomInkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ]),
        child: Row(
          children: [
            Assets.icons.icNearPlace.svg(),
            12.w.horizontalSpace,
            SizedBox(
              width: 1.sw * 0.7,
              child: Text(
                item.formattedAddress,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: MyColors.black34,
                  fontSize: 13.sp,
                ),
              ),
            ),
            const Spacer(),
            CustomInkWell(
                child: Assets.icons.premium.icPremiumSvg.svg(), onTap: () {})
          ],
        ),
      ),
    );
  }

  CustomInkWell buildButtonCurrentLc() {
    return CustomInkWell(
      onTap: () {
        // ChatService().sendMessageLocation(content: '', idGroup: idGroup, lat: lat, long: long, groupName: groupName)
        context.popRoute().then((value) {
          return showDialog(
              context: context,
              builder: (ctx) {
                Timer(
                  const Duration(seconds: 1),
                  () async {
                    await ctx.popRoute();
                  },
                );

                return const CheckInDialog();
              });
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ]),
        child: Row(
          children: [
            Assets.icons.icShareLocation.svg(
                width: 20.r,
                height: 20.r,
                colorFilter:
                    const ColorFilter.mode(MyColors.primary, BlendMode.srcIn)),
            12.w.horizontalSpace,
            SizedBox(
              width: 1.sw * 0.7,
              child: Text(
                'Current location',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: MyColors.black34,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
