// ignore_for_file: unused_local_variable, cast_nullable_to_non_nullable

import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../config/di/di.dart';
import '../data/models/store_place/store_place.dart';
import '../data/models/store_user/store_user.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';
import '../shared/helpers/map_helper.dart';
import 'location_service.dart';

@singleton
class MyBackgroundService {
  bool isRunning = false;
  final fireStoreClient = FirestoreClient.instance;

  Future<void> initialize() async {
    if (isRunning) {
      return;
    } else {
      isRunning = true;
    }
    final LocationService locationService = getIt<LocationService>();
    final StoreUser? user = Global.instance.user;
    final LatLng serverLocation = Global.instance.serverLocation;
    final Battery battery = Battery();

    if (user != null) {
      LatLng newLocation =
          LatLng(serverLocation.latitude, serverLocation.longitude);

      locationService
          .getLocationStreamOnBackground()
          .listen((LatLng latLng) async {
        newLocation = latLng;
      });

      Timer.periodic(const Duration(seconds: 30), (timer) async {
        //check current location with new location => location > 30m => update
        final bool shouldUpdate = MapHelper.isWithinRadius(
          LatLng(serverLocation.latitude, serverLocation.longitude),
          LatLng(newLocation.latitude, newLocation.longitude),
          30,
        );
        if (shouldUpdate) {
          //update local
          Global.instance.serverLocation = newLocation;

          //update to sever
          //do something
        }
      });
    }
  }

  //tracking history place
  Future<void> trackingHistoryPlace() async {
    //lấy ra toàn bộ id group mà mình join
    final List<String>? listIdGroup = await fireStoreClient.listIdGroup();
    final List<Map<String, List<StorePlace>?>> listPlaces = [];
    if (listIdGroup != null && listIdGroup.isNotEmpty) {
      //lấy toàn bộ place trong từng group
      listIdGroup.map((id) async {
        final listPlace = await fireStoreClient.listPlaces(id);
        listPlaces.add({id: listPlace});
      });
    }

    //sau khi lấy được toàn bộ thông tin place
    listPlaces.map((e) {
      e.values.map((places) {
        places?.map((place) {
          //check xem vị trí hiện tại đã đi vào bán kính hay đi ra bán kính với vị trí của place hay chưa
        });
      });
    });
  }
}
