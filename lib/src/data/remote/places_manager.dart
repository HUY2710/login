import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/logger_utils.dart';
import '../models/store_place/store_place.dart';
import 'collection_store.dart';

class PlacesManager {
  PlacesManager._();

  static Future<void> createPlace(
      {required String idGroup, required StorePlace place}) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(place.idPlace)
        .set(place.toJson())
        .then((_) => LoggerUtils.logInfo('Create new place: $place'))
        .catchError((error) {
      LoggerUtils.logError('Failed to create place: $error');
      throw Exception(error);
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      listenRealtimePlacesChanges(String groupId) {
    return CollectionStore.groups
        .doc(groupId)
        .collection(CollectionStoreConstant.places)
        .snapshots();
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

  // xóa tất cả các place trong group khi xóa group
  static Future<void> removeAllPlaceOfGroup(String idGroup) async {
    final CollectionReference collectionReference = CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places);
    final QuerySnapshot querySnapshot = await collectionReference.get();
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    // Lặp qua từng tài liệu và thêm thao tác xóa vào batch
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    // Thực hiện batch write để xóa tất cả các tài liệu
    await batch.commit();
  }

  //lấy toàn bộ place trong group
  static Future<List<StorePlace>> getListStorePlace(String idGroup) async {
    final snapShot = await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .get();
    final data = snapShot.docs;

    final List<StorePlace> listPlace =
        data.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
      StorePlace place = StorePlace.fromJson(e.data());
      place = place.copyWith(idPlace: e.id);
      return place;
    }).toList();

    return listPlace;
  }

  static Future<void> updatePlace(
      String idGroup, String idPlace, Map<String, dynamic> fields) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .update(fields)
        .then((value) => debugPrint('Update Place success'))
        .catchError((error) {
      debugPrint('Update Place error:$error');
      throw Exception(error);
    });
  }

  static Future<StorePlace?> getDetailPlace(
      {required String idGroup, required String idPlace}) async {
    debugPrint('idGroup:$idGroup');
    debugPrint('idPlace:$idPlace');
    final DocumentSnapshot<Map<String, dynamic>> doc = await CollectionStore
        .groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc(idPlace)
        .get();

    if (doc.data() == null) {
      return null;
    }
    final StorePlace place = StorePlace.fromJson(doc.data()!);
    return place;
  }
}
