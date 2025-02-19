import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_notification_place/store_notification_place.dart';
import 'collection_store.dart';

class NotificationPlaceManager {
  NotificationPlaceManager._();

  static Future<void> createNotificationPlace(
      {required String idGroup,
      required String idPlace,
      required String idDocNotification,
      required StoreNotificationPlace storeNotificationPlace}) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .collection(CollectionStoreConstant.notificationPlace)
        .doc(idDocNotification)
        .set(storeNotificationPlace.toJson())
        .then((_) {
      LoggerUtils.logInfo(
          'Create new notification place: $storeNotificationPlace');
    }).catchError((error) {
      LoggerUtils.logError('Failed to create notification place: $error');
      throw Exception(error);
    });
  }

  //remove place
  static Future<void> removePlace(
      {required String idGroup, required String idPlace}) async {
    await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .delete()
        .then((_) {
      LoggerUtils.logInfo('remove place success');
    }).catchError((error) {
      LoggerUtils.logError('Failed to remove place: $error');
      throw Exception(error);
    });
  }

  // xóa tất cả các notification trong place đó nếu place đó bị xóa
  static Future<void> removeAllNotificationPlace(
    String idGroup,
    String idPlace,
  ) async {
    final CollectionReference collectionReference = CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .collection(CollectionStoreConstant.notificationPlace);
    final QuerySnapshot querySnapshot = await collectionReference.get();
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  static Future<StoreNotificationPlace?> myNotificationPlace(
      String idGroup, String idPlace) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await CollectionStore
        .groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .collection(CollectionStoreConstant.notificationPlace)
        .doc(Global.instance.userCode)
        .get();
    if (doc.data() == null) {
      return null;
    }
    final StoreNotificationPlace notificationPlace =
        StoreNotificationPlace.fromJson(doc.data()!);
    LoggerUtils.logInfo('Fetch notificationPlace: $notificationPlace');
    return notificationPlace;
  }

  static Future<void> updateNotificationPlace(
      String idGroup, String idPlace, Map<String, dynamic> fields) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .collection(CollectionStoreConstant.notificationPlace)
        .doc(Global.instance.userCode)
        .update(fields)
        .then((value) => debugPrint('Update Notification Place success'))
        .catchError((error) {
      debugPrint('Update Notification Place error:$error');
      throw Exception(error);
    });
  }
}
