// ignore_for_file: unused_local_variable, cast_nullable_to_non_nullable

import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../flavors.dart';
import '../config/di/di.dart';
import '../data/models/store_user/store_user.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';
import '../shared/helpers/map_helper.dart';
import 'firebase_message_service.dart';
import 'location_service.dart';
import 'tracking_history_place_service.dart';

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
      locationService
          .getLocationStreamOnBackground()
          .listen((LatLng latLng) async {
        Timer.periodic(Duration(seconds: Flavor.dev == F.appFlavor ? 15 : 30),
            (timer) async {
          debugPrint('timer: ${timer.tick}');
          //check current location with new location => location > 30m => update
          final bool inRadius = MapHelper.isWithinRadius(
            Global.instance.currentLocation,
            latLng,
            30,
          );
          if (!inRadius) {
            //update local
            Global.instance.serverLocation = latLng;
            Global.instance.currentLocation = latLng;
            debugPrint(
                'currentLocation background:${Global.instance.currentLocation}');

            await getIt<LocationService>().updateLocationUser(latLng: latLng);
            await getIt<TrackingHistoryPlaceService>().trackingHistoryPlace();

            //update to sever
            //do something
          }
        });
      });
    }
  }

  Future<void> initSubAndUnSubTopic() async {
    if (Global.instance.user != null) {
      listenMyGroupToSubAndUnSubTopic();
    }
  }

  //lắng nghe myGroups để đăng kí và hủy thông báo
  Future<void> listenMyGroupToSubAndUnSubTopic() async {
    fireStoreClient
        .listenMyGroups()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (final change in snapshot.docChanges) {
        //đăng kí nhận thông báo khi có group mới
        if (change.type == DocumentChangeType.added) {
          FirebaseMessageService().subscribeTopics([change.doc.id]);
        }
        //hủy thông báo khi có group bị xóa
        if (change.type == DocumentChangeType.removed) {
          FirebaseMessageService().unSubscribeTopics([change.doc.id]);
        }
      }
    });
  }
}
