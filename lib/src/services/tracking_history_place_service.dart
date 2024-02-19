import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../config/di/di.dart';
import '../config/navigation/app_router.dart';
import '../data/models/store_place/store_place.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';
import '../shared/extension/context_extension.dart';
import '../shared/helpers/map_helper.dart';
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
    fireStoreClient
        .listenRealtimePlacesChanges(idGroup)
        .listen((QuerySnapshot<Map<String, dynamic>> snapshotPlace) {
      for (final change in snapshotPlace.docChanges) {
        //place được thêm
        if (change.type == DocumentChangeType.added) {
          StorePlace place = StorePlace.fromJson(change.doc.data()!);
          place = place.copyWith(idPlace: change.doc.id);
          listPlaceGroup.add(place);
        }
        //place bị xóa
        if (change.type == DocumentChangeType.removed) {
          listPlaceGroup.removeWhere((place) => place.idPlace == change.doc.id);
        }

        if (change.type == DocumentChangeType.modified) {
          StorePlace place = StorePlace.fromJson(change.doc.data()!);
          place = place.copyWith(idPlace: change.doc.id);
          final index = listPlaceGroup
              .indexWhere((element) => element.idPlace == place.idPlace);
          listPlaceGroup[index] = place;
        }
      }

      listMapPlaces[listIdGroup.indexOf(idGroup)] = {idGroup: listPlaceGroup};
    });
  }

  Future<void> trackingHistoryPlace() async {
    debugPrint('listMapPlaces:${listMapPlaces.length}');
    listMapPlaces.asMap().forEach((index, mapPlace) {
      for (final places in mapPlace.values) {
        places?.forEach((place) {
          _handlePlaceNotification(place, listIdGroup[index]);
        });
      }
    });
  }

  Future<void> _handlePlaceNotification(
      StorePlace place, String groupId) async {
    final inRadius = MapHelper.isWithinRadius(
      LatLng(place.location?['lat'], place.location?['lng']),
      Global.instance.currentLocation,
      100,
    );

    if (inRadius && !place.isSendArrived) {
      await _sendNotificationAndMarkAsSent(
        place: place,
        groupId: groupId,
        enter: inRadius,
      );
      //update local
      final List<StorePlace>? places =
          listMapPlaces[listIdGroup.indexOf(groupId)].values.first;
      if (places != null && places.isNotEmpty) {
        final index = places.indexWhere((e) => e.idPlace == place.idPlace);
        places[index] = places[index]
            .copyWith(isSendArrived: inRadius, isSendLeaved: !inRadius);
        listMapPlaces[listIdGroup.indexOf(groupId)] = {groupId: places};
      }
      debugPrint(
          'listMapPlaces:${listMapPlaces[listIdGroup.indexOf(groupId)]}');
    } else if (!inRadius && place.isSendArrived && !place.isSendLeaved) {
      await _sendNotificationAndMarkAsSent(
        place: place,
        groupId: groupId,
        enter: inRadius,
      );
      //update local
      final List<StorePlace>? places =
          listMapPlaces[listIdGroup.indexOf(groupId)].values.first;
      if (places != null && places.isNotEmpty) {
        final index = places.indexWhere((e) => e.idPlace == place.idPlace);
        places[index] = places[index]
            .copyWith(isSendArrived: inRadius, isSendLeaved: !inRadius);
        listMapPlaces[listIdGroup.indexOf(groupId)] = {groupId: places};
        debugPrint(
            'listMapPlaces:${listMapPlaces[listIdGroup.indexOf(groupId)]}');
      }
    }
  }

  Future<void> _sendNotificationAndMarkAsSent(
      {required StorePlace place,
      required String groupId,
      required bool enter}) async {
    final message =
        '${Global.instance.user?.userName} ${context?.l10n ?? 'has'} ${enter ? context?.l10n.enter ?? 'enter' : context?.l10n.enter ?? 'left'} '
        '${place.namePlace}';
    try {
      FirebaseMessageService().sendPlaceNotification(
        groupId: groupId,
        enter: enter,
        message: message,
      );
      await fireStoreClient.updatePlace(groupId, place.idPlace!, {
        'isSendArrived': enter,
        'isSendLeaved': !enter,
      });
    } catch (error) {
      debugPrint('update Place error:$error');
    }
  }
}
