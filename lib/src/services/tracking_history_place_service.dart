import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../config/di/di.dart';
import '../config/navigation/app_router.dart';
import '../data/local/shared_preferences_manager.dart';
import '../data/models/store_history_place/store_history_place.dart';
import '../data/models/store_notification_place/store_notification_place.dart';
import '../data/models/store_place/store_place.dart';
import '../data/remote/firestore_client.dart';
import '../data/remote/notification_place_manager.dart';
import '../global/global.dart';
import '../shared/extension/context_extension.dart';
import '../shared/helpers/map_helper.dart';
import '../shared/helpers/time_helper.dart';
import 'firebase_message_service.dart';

@singleton
class TrackingHistoryPlaceService {
  BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  final fireStoreClient = FirestoreClient.instance;
  List<String> listIdGroup = [];
  List<Map<String, List<StorePlace>?>> listMapPlaces = [];

  Future<void> initGroups() async {
    //lắng nghe realtime list groups
    fireStoreClient
        .listenMyGroups()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (final change in snapshot.docChanges) {
        //khi có group mới
        if (change.type == DocumentChangeType.added) {
          listIdGroup.add(change.doc.id);
          listMapPlaces.add({change.doc.id: []});
          initPlacesOfGroup(change.doc.id);
        }
        //khi group bị xóa
        if (change.type == DocumentChangeType.removed) {
          listIdGroup.remove(change.doc.id);
          listMapPlaces
              .removeWhere((mapPlace) => mapPlace.keys.first == change.doc.id);
        }
      }
    });
  }

  Future<void> initPlacesOfGroup(String idGroup) async {
    //lắng nghe list place của từng group
    final List<StorePlace> listPlaceGroup = [];
    fireStoreClient.listenRealtimePlacesChanges(idGroup).listen(
      (QuerySnapshot<Map<String, dynamic>> snapshotPlace) async {
        for (final change in snapshotPlace.docChanges) {
          //place được thêm
          if (change.type == DocumentChangeType.added) {
            StorePlace place = StorePlace.fromJson(change.doc.data()!);
            place = place.copyWith(idPlace: change.doc.id);
            final StoreNotificationPlace? myNotifyPlace =
                await NotificationPlaceManager.myNotificationPlace(
                    idGroup, place.idPlace!);
            place = place.copyWith(myNotificationPlace: myNotifyPlace);

            listPlaceGroup.add(place);
          }
          //place bị xóa
          if (change.type == DocumentChangeType.removed) {
            listPlaceGroup
                .removeWhere((place) => place.idPlace == change.doc.id);
          }

          if (change.type == DocumentChangeType.modified) {
            StorePlace place = StorePlace.fromJson(change.doc.data()!);

            place = place.copyWith(
              idPlace: change.doc.id,
            );

            final index = listPlaceGroup
                .indexWhere((element) => element.idPlace == place.idPlace);
            listPlaceGroup[index] = place.copyWith(
                myNotificationPlace: listPlaceGroup[index].myNotificationPlace);
          }
        }

        listMapPlaces[listIdGroup.indexOf(idGroup)] = {idGroup: listPlaceGroup};
        trackingHistoryPlace();
      },
    );
  }

  Future<void> trackingHistoryPlace() async {
    listMapPlaces.asMap().forEach((index, mapPlace) {
      for (final places in mapPlace.values) {
        places?.forEach((place) async {
          await _handlePlaceNotification(place, listIdGroup[index]);
        });
      }
    });
  }

  Future<void> _handlePlaceNotification(
      StorePlace place, String groupId) async {
    final inRadius = MapHelper.isWithinRadius(
      LatLng(place.location?['lat'], place.location?['lng']),
      Global.instance.currentLocation,
      place.radius,
    );
    //check xem time đến place này có hơn 15phuts kể từ khi rời place hay không

    final lastTime = await SharedPreferencesManager.getString(place.idPlace!);
    bool isSpam = false;
    if (lastTime != null) {
      //true nếu spam
      isSpam = TimerHelper.checkTimeDifferenceCurrent(DateTime.parse(lastTime));
    }
    debugPrint('place:$place');

    if (inRadius && !place.myNotificationPlace!.isSendArrived) {
      if (!isSpam) {
        await _sendNotificationAndMarkAsSent(
          place: place,
          groupId: groupId,
          enter: inRadius,
        );
      }

      //update local
      final List<StorePlace>? places =
          listMapPlaces[listIdGroup.indexOf(groupId)].values.first;
      if (places != null && places.isNotEmpty) {
        final index = places.indexWhere((e) => e.idPlace == place.idPlace);
        if (index != -1) {
          places[index] = places[index].copyWith(
            myNotificationPlace: const StoreNotificationPlace(
              isSendArrived: true,
            ),
          );
          listMapPlaces[listIdGroup.indexOf(groupId)] = {groupId: places};
        }
      }
    } else if (!inRadius &&
        place.myNotificationPlace!.isSendArrived &&
        !place.myNotificationPlace!.isSendLeaved) {
      if (!inRadius &&
          place.myNotificationPlace!.isSendArrived &&
          !place.myNotificationPlace!.isSendLeaved &&
          !isSpam) {
        await _sendNotificationAndMarkAsSent(
          place: place,
          groupId: groupId,
          enter: inRadius,
        );
        //sau khi rời thì lưu lại time lần cuối rời place đó...để trường hợp user spam đi ra đi vào
        //lấy idPlace đó để làm key
        await SharedPreferencesManager.setString(
          place.idPlace!,
          DateTime.now().toIso8601String(),
        );
        //update local
        final List<StorePlace>? places =
            listMapPlaces[listIdGroup.indexOf(groupId)].values.first;
        if (places != null && places.isNotEmpty) {
          final index = places.indexWhere((e) => e.idPlace == place.idPlace);
          places[index] = places[index].copyWith(
            myNotificationPlace: const StoreNotificationPlace(
              isSendLeaved: true,
            ),
          );
          listMapPlaces[listIdGroup.indexOf(groupId)] = {groupId: places};
        }
      }
    }
  }

  Future<void> _sendNotificationAndMarkAsSent({
    required StorePlace place,
    required String groupId,
    required bool enter,
  }) async {
    final message =
        '${Global.instance.user?.userName} ${context?.l10n.has ?? 'has'} ${enter ? context?.l10n.enter ?? 'enter' : context?.l10n.enter ?? 'left'} '
        '${place.namePlace}';
    try {
      FirebaseMessageService().sendPlaceNotification(
        groupName: 'Place: ${place.namePlace}',
        enter: enter,
        message: message,
      );
      //nếu enter == true => isSendArrived =true => đã gửi thông báo khi đến
      //nếu enter ==false => isSendLeaved = true => đã gửi thông báo khi rời

      await NotificationPlaceManager.updateNotificationPlace(
        groupId,
        place.idPlace!,
        StoreNotificationPlace(isSendArrived: enter, isSendLeaved: !enter)
            .toJson(),
      );

      //đi vào place
      if (enter) {
        //tạo mới historyPlace
        final StoreHistoryPlace historyPlace = StoreHistoryPlace(
          idPlace: place.idPlace!,
          enterTime: DateTime.now(),
        );
        await fireStoreClient.createHistoryPlace(
          idGroup: groupId,
          historyPlace: historyPlace,
        );
      } else {
        //rời khỏi place
        // cần kiểm tra xem history place có idPlace && timeLeft == null thì update timeleft
        StoreHistoryPlace? historyPlace = await fireStoreClient
            .getDetailHistoryPlace(idGroup: groupId, idPlace: place.idPlace!);
        if (historyPlace != null) {
          historyPlace = historyPlace.copyWith(leftTime: DateTime.now());
          await fireStoreClient.updateHistoryPlace(
              idGroup: groupId, historyPlace: historyPlace);
        }
      }
    } catch (error) {
      debugPrint('update Place error:$error');
    }
  }
}
