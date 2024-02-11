import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/utils/logger_utils.dart';
import '../models/store_place/store_place.dart';
import 'collection_store.dart';

class PlacesManager {
  PlacesManager._();

  static Future<void> createPlace(
      {required String idGroup, required StorePlace place}) async {
    return CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.places)
        .doc()
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
}
