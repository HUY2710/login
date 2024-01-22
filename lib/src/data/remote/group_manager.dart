import '../../global/global.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_group/store_group.dart';
import 'collection_store.dart';

class GroupsManager {
  GroupsManager._();

  static Future<void> createGroup(StoreGroup newGroup) async {
    final generateIdGroup = 20.randomString(); //Id of document group

    //create new document depend above code
    CollectionStore.groups
        .doc(generateIdGroup)
        .set(newGroup.toJson())
        .then((value) {
      //if success => add Id document into Collection groups of User
      if (Global.instance.user != null) {
        CollectionStore.users
            .doc(Global.instance.user!.code)
            .collection(CollectionStoreConstant.groupsOfUser)
            .doc(generateIdGroup)
            .set({'idGroup': generateIdGroup});
      }
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
  }
}
