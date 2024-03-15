import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import 'collection_store.dart';

class SosManager {
  SosManager._();

  //tạo 1 cái sos nếu đó là tk cũ
  static Future<void> createSos() async {
    CollectionStore.sos
        .doc(Global.instance.userCode)
        .set({'sos': false})
        .then((_) => LoggerUtils.logInfo('Create new sos for async data'))
        .catchError((error) {
          LoggerUtils.logError('Failed to create sos: $error');
          throw Exception(error);
        });
  }

  static Future<void> updateSos(Map<String, dynamic> fields) async {
    return CollectionStore.sos
        .doc(Global.instance.userCode)
        .update(fields)
        .then((_) {
      LoggerUtils.logInfo('Sos Update: $fields');
    }).catchError((error) {
      LoggerUtils.logError('Failed to update sos: $error');
      throw Exception(error);
    });
  }
}
