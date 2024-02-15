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
}
