import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_history_place/store_history_place.dart';
import 'collection_store.dart';
import 'places_manager.dart';

class HistoryPlacesManager {
  HistoryPlacesManager._();

  static Future<void> createHistoryPlace(
      {required String idGroup,
      required StoreHistoryPlace historyPlace}) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.historyPlacesOfUser)
        .doc(Global.instance.user?.code) //lấy iduser để làm doc
        .collection(CollectionStoreConstant.historyPlaces)
        .doc(historyPlace.idHistoryPlace ?? 24.randomString())
        .set(historyPlace.toJson())
        .then((_) =>
            LoggerUtils.logInfo('Create new history place: $historyPlace'))
        .catchError((error) {
      LoggerUtils.logError('Failed to create place: $error');
      throw Exception(error);
    });
  }

  static Future<void> updateHistoryPlace(
      {required String idGroup,
      required StoreHistoryPlace historyPlace,
      Map<String, dynamic>? field}) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.historyPlacesOfUser)
        .doc(Global.instance.user?.code) //lấy iduser để làm doc
        .collection(CollectionStoreConstant.historyPlaces)
        .doc(historyPlace.idHistoryPlace)
        .update(field ?? historyPlace.toJson())
        .then((_) => LoggerUtils.logInfo('Update history place: $historyPlace'))
        .catchError((error) {
      LoggerUtils.logError('Failed to updateHistoryPlace : $error');
      throw Exception(error);
    });
  }

  static Future<StoreHistoryPlace?> getDetailHistoryPlace(
      {required String idGroup, required String idPlace}) async {
    final result = await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.historyPlacesOfUser)
        .doc(Global.instance.user?.code) //lấy iduser để làm doc
        .collection(CollectionStoreConstant.historyPlaces)
        .where('idPlace', isEqualTo: idPlace)
        .where('leftTime', isEqualTo: null)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      final Map<String, dynamic> map = result.docs.first.data();
      final QueryDocumentSnapshot firstDoc = result.docs.first;
      final String docId = firstDoc.id; // Lấy docId của tài liệu
      StoreHistoryPlace historyPlace = StoreHistoryPlace.fromJson(map);
      historyPlace = historyPlace.copyWith(idHistoryPlace: docId);
      return historyPlace;
    }
    return null;
  }

  static Future<List<StoreHistoryPlace>?> getListHistoryPlace(
      {required String idGroup, required String idUser}) async {
    final result = await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.historyPlacesOfUser)
        .doc(idUser)
        .collection(CollectionStoreConstant.historyPlaces)
        .orderBy('enterTime', descending: true)
        .get();

    if (result.docs.isNotEmpty) {
      final List<StoreHistoryPlace> historyPlaces = [];
      await Future.forEach(result.docs, (doc) async {
        final Map<String, dynamic> data = doc.data();
        StoreHistoryPlace historyPlace = StoreHistoryPlace.fromJson(data);
        if (historyPlace.idPlace != '') {
          final place = await PlacesManager.getDetailPlace(
              idGroup: idGroup, idPlace: historyPlace.idPlace);
          historyPlace = historyPlace.copyWith(place: place);
        }

        historyPlaces.add(historyPlace);
      });

      return historyPlaces;
    } else {
      return [];
    }
  }
}
