import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../module/iap/my_purchase_manager.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/navigation/app_router.dart';
import '../../../../../data/models/location/location_model.dart';
import '../../../../../data/models/places/place_model.dart';
import '../../../../../gen/gens.dart';
import '../../../../../global/global.dart';
import '../../../../../services/http_service.dart';
import '../../../../../shared/helpers/map_helper.dart';
import '../../../../../shared/widgets/custom_inkwell.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../chat/services/chat_service.dart';
import '../../../../map/cubit/select_group_cubit.dart';
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
  final isPremium = getIt<MyPurchaseManager>().state.isPremium();
  @override
  void initState() {
    if (isPremium) {
      checkLocationAndRequest();
    }
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
      height: isPremium ? 1.sh * 0.5 : 1.sh * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          20.h.verticalSpace,
          Expanded(child: buildListPlace()),
        ],
      ),
    );
  }

  Widget buildListPlace() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildButtonCurrentLc();
          }
          if (isPremium) {
            return buildButtonPremium(item: listPlaceNearBy[index - 1]);
          }

          return buildButtonPremium();
        },
        separatorBuilder: (context, index) {
          return 16.h.verticalSpace;
        },
        itemCount: isPremium ? listPlaceNearBy.length + 1 : 2);
  }

  Widget buildButtonPremium({Place? item}) {
    return CustomInkWell(
      onTap: () {
        if (item != null) {
          _checkIn(item: item);
        } else {
          context.popRoute();
          context.pushRoute(PremiumRoute());
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: Row(
          children: [
            Assets.icons.icNearPlace.svg(),
            12.w.horizontalSpace,
            SizedBox(
              width: 1.sw * 0.7,
              child: Text(
                item?.formattedAddress ?? 'Nearby location',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: MyColors.black34,
                  fontSize: 13.sp,
                ),
              ),
            ),
            const Spacer(),
            if (!isPremium) Assets.icons.premium.icPremiumSvg.svg()
          ],
        ),
      ),
    );
  }

  CustomInkWell buildButtonCurrentLc() {
    return CustomInkWell(
      onTap: () {
        _checkIn();
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

  void _checkIn({Place? item}) {
    final storeGroup = getIt<SelectGroupCubit>().state;
    ChatService.instance.sendMessageLocation(
      content: '',
      idGroup: storeGroup?.idGroup ?? '',
      lat: item == null
          ? Global.instance.currentLocation.latitude
          : item.location.latitude,
      long: item == null
          ? Global.instance.currentLocation.longitude
          : item.location.longitude,
      groupName: storeGroup?.groupName ?? 'Group',
      context: context,
      isCheckin: true,
    );
    context.popRoute().then((value) {
      return showDialog(
          context: context,
          builder: (ctx) {
            Timer(
              const Duration(seconds: 1),
              () {
                ctx.popRoute();
              },
            );

            return const CheckInDialog();
          });
    });
  }
}
