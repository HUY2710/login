import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import 'collection_store.dart';

class SosManager {
  SosManager._();

  static Future<void> updateSos(Map<String, dynamic> fields) async {
    return CollectionStore.sos
        .doc(Global.instance.userCode)
        .set(fields, SetOptions(merge: true))
        .then((_) {
      LoggerUtils.logInfo('Sos Update: $fields');
    }).catchError((error) {
      LoggerUtils.logError('Failed to update sos: $error');
      throw Exception(error);
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> listenSOSUser(
      String idUser) {
    return CollectionStore.sos.doc(idUser).snapshots();
  }
}
