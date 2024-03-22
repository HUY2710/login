import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_sos/store_sos.dart';
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

  static Future<StoreSOS?> getSOS(String idUser) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await CollectionStore.sos.doc(idUser).get();
    if (doc.data() == null) {
      return null;
    }
    final StoreSOS sos = StoreSOS.fromJson(doc.data()!);
    LoggerUtils.logInfo('Fetch SOS: $sos');
    return sos;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> listenSOSUser(
      String idUser) {
    return CollectionStore.sos.doc(idUser).snapshots();
  }
}
