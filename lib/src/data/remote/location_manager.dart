import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_location/store_location.dart';
import 'collection_store.dart';

class LocationManager {
  LocationManager._();

  static Future<void> createLocation(
      StoreLocation location, String idUser) async {
    return CollectionStore.locations
        .doc(idUser)
        .set(location.toJson())
        .then((_) => LoggerUtils.logInfo('Create new location: $location'))
        .catchError(
          (error) => LoggerUtils.logError('Failed to add location: $error'),
        );
  }

  static Future<void> updateLocation(
    Map<String, dynamic> fields,
  ) async {
    CollectionStore.locations
        .doc(Global.instance.user!.code)
        .update(fields)
        .then((_) {
      LoggerUtils.logInfo('Location Update: $fields');
    }).catchError((error) {
      LoggerUtils.logError('Failed to update location: $error');
      throw Exception(error);
    });
  }

  static Future<StoreLocation?> getLocation() async {
    if (Global.instance.user?.code == null) {
      return null;
    }
    final DocumentSnapshot<Map<String, dynamic>> docLocation =
        await CollectionStore.locations.doc(Global.instance.user!.code).get();
    if (docLocation.data() == null) {
      return null;
    }
    final StoreLocation locations = StoreLocation.fromJson(docLocation.data()!);
    LoggerUtils.logInfo('Fetch location: $locations');
    return locations;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      listenLocationUserChange(String idUser) {
    return CollectionStore.locations.doc(idUser).snapshots();
  }

  static Future<StoreLocation?> getUserLocation(String idUser) async {
    final DocumentSnapshot<Map<String, dynamic>> docLocation =
        await CollectionStore.locations.doc(idUser).get();
    if (docLocation.data() == null) {
      return null;
    }
    final StoreLocation locations = StoreLocation.fromJson(docLocation.data()!);
    LoggerUtils.logInfo('Fetch location: $locations');
    return locations;
  }
}
