// ignore_for_file: unused_local_variable, cast_nullable_to_non_nullable

import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../app/cubit/last_place_cubit.dart';
import '../../flavors.dart';
import '../config/di/di.dart';
import '../data/models/last_place_default/last_place_default_model.dart';
import '../data/models/store_history_place/store_history_place.dart';
import '../data/models/store_user/store_user.dart';
import '../data/remote/firestore_client.dart';
import '../data/remote/group_manager.dart';
import '../data/remote/history_place_manager.dart';
import '../data/remote/token_manager.dart';
import '../global/global.dart';
import '../shared/extension/int_extension.dart';
import '../shared/helpers/map_helper.dart';
import '../shared/helpers/time_helper.dart';
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
      LatLng newLocation =
          LatLng(serverLocation.latitude, serverLocation.longitude);

      if (getIt<LastPlaceCubit>().state != null) {
        final bool inRadius100mPlace = MapHelper.isWithinRadius(
          LatLng(getIt<LastPlaceCubit>().state!.latitude,
              getIt<LastPlaceCubit>().state!.longitude),
          newLocation,
          100,
        );

        final time = TimerHelper.checkHourTime(
            getIt<LastPlaceCubit>().state!.lastTime, 2);
        if (!inRadius100mPlace && time) {
          final oldHistoryPlace = StoreHistoryPlace(
            idPlace: '',
            enterTime: getIt<LastPlaceCubit>().state!.lastTime,
            leftTime: DateTime.now(),
            idHistoryPlace: getIt<LastPlaceCubit>().state!.idHistoryPlace,
          );

          //update history mà không cần place tracking
          //lấy toàn bộ list id group
          final List<String>? idGroups = await GroupsManager.getIdMyListGroup();
          idGroups?.forEach((idGroup) {
            HistoryPlacesManager.updateHistoryPlace(
                idGroup: idGroup,
                historyPlace: oldHistoryPlace,
                field: {'enterTime': DateTime.now()});
          });
        }
      } else {
        //lần đầu
        final address = await locationService.getCurrentAddress(newLocation);
        final newHistory = StoreHistoryPlace(
          idPlace: '',
          enterTime: DateTime.now(),
          idHistoryPlace: 24.randomString(),
          nameDefault: address,
        );
        //lấy toàn bộ list id group
        final List<String>? idGroups = await GroupsManager.getIdMyListGroup();
        idGroups?.forEach((idGroup) {
          HistoryPlacesManager.createHistoryPlace(
            idGroup: idGroup,
            historyPlace: newHistory,
          );
        });
        getIt<LastPlaceCubit>().update(
          LastPlaceDefault(
            latitude: newLocation.latitude,
            longitude: newLocation.longitude,
            lastTime: DateTime.now(),
            idHistoryPlace: newHistory.idHistoryPlace ?? 24.randomString(),
          ),
        );
      }

      locationService
          .getLocationStreamOnBackground()
          .listen((LatLng latLng) async {
        newLocation = latLng;
      });
      Timer.periodic(Duration(seconds: Flavor.dev == F.appFlavor ? 15 : 30),
          (timers) async {
        //update location background
        debugPrint('update location background');
        Global.instance.currentLocation = newLocation;
        //check current location with new location => location > 30m => update
        final bool inRadius = MapHelper.isWithinRadius(
          Global.instance.serverLocation,
          newLocation,
          30,
        );
        if (!inRadius) {
          //update local
          Global.instance.serverLocation = newLocation;
          await getIt<LocationService>()
              .updateLocationUser(latLng: newLocation);
          await getIt<TrackingHistoryPlaceService>().trackingHistoryPlace();
        } else {
          debugPrint('in Radius');
        }
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
    final ids = await fireStoreClient.listIdGroup();

    fireStoreClient
        .listenMyGroups()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (final change in snapshot.docChanges) {
        //hủy thông báo khi group trong listgroup của mình bị xóa (mình rời hoặc bị xóa)
        if (change.type == DocumentChangeType.removed) {
          TokenManager.updateGroupNotification(true, change.doc.id);
        }
      }
    });
  }
}
