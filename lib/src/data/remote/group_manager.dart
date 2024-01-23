import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/di/di.dart';
import '../../global/global.dart';
import '../../presentation/map/cubit/select_group_cubit.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_group/store_group.dart';
import '../models/store_user/store_user.dart';
import 'collection_store.dart';

class GroupsManager {
  GroupsManager._();

  static Future<void> createGroup(StoreGroup newGroup) async {
    final generateIdGroup = 20.randomString(); //Id of document group

    //create new document depend above code
    CollectionStore.groups
        .doc(generateIdGroup)
        .set(newGroup.copyWith().toJson())
        .then((value) {
      //if success => add Id document into Collection groups of User
      if (Global.instance.user != null) {
        CollectionStore.users
            .doc(Global.instance.user!.code)
            .collection(CollectionStoreConstant.myGroups)
            .doc(generateIdGroup)
            .set({'idGroup': generateIdGroup});
      }
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
  }

  //snapshot data for each member in group
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchTrackingMemberStream(
      List<String> memberCode) {
    //get info current group
    final snapshot =
        CollectionStore.users.where('code', whereIn: memberCode).snapshots();

    return snapshot;
  }

  static Future<StoreGroup?> getDetailGroup(
    String idGroup,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await CollectionStore.groups.doc(idGroup).get();
    if (doc.data() == null) {
      return null;
    }
    final StoreGroup group = StoreGroup.fromJson(doc.data()!);
    LoggerUtils.logInfo('Fetch User: ${Global.instance.user}');
    return group;
  }
}
