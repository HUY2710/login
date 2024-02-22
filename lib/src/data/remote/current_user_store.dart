import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/utils/logger_utils.dart';
import '../models/store_user/store_user.dart';
import 'collection_store.dart';

class CurrentUserManager {
  CurrentUserManager._();

  static Future<void> createUser(StoreUser user) async {
    return CollectionStore.users
        .doc(user.code)
        .set(user.toJson())
        .then((_) => LoggerUtils.logInfo('Create new User: $user'))
        .catchError(
          (error) => LoggerUtils.logError('Failed to add user: $error'),
        );
  }

  static Future<void> updateUser(
    String code,
    Map<String, dynamic> fields,
  ) async {
    return CollectionStore.users.doc(code).update(fields).then((_) {
      LoggerUtils.logInfo('User Update: $fields');
    }).catchError((error) {
      LoggerUtils.logError('Failed to update user: $error');
      throw Exception(error);
    });
  }

  static Future<StoreUser?> getUser(
    String code,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await CollectionStore.users.doc(code).get();
    if (doc.data() == null) {
      return null;
    }
    final StoreUser user = StoreUser.fromJson(doc.data()!);
    LoggerUtils.logInfo('Fetch User: $user');
    return user;
  }
}
