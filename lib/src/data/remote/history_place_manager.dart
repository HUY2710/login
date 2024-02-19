import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_history_place/store_history_place.dart';
import 'collection_store.dart';

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
        .doc(historyPlace.idPlace)
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
      required StoreHistoryPlace historyPlace}) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.historyPlacesOfUser)
        .doc(Global.instance.user?.code) //lấy iduser để làm doc
        .collection(CollectionStoreConstant.historyPlaces)
        .doc(historyPlace.idPlace)
        .update(historyPlace.toJson())
        .then((_) =>
            LoggerUtils.logInfo('Create new history place: $historyPlace'))
        .catchError((error) {
      LoggerUtils.logError('Failed to create place: $error');
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
      final StoreHistoryPlace historyPlace = StoreHistoryPlace.fromJson(map);
      return historyPlace;
    }
    return null;
  }
}
