import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/group_manager.dart';
import '../../../shared/helpers/logger_utils.dart';

class ChatSercive {
  ChatSercive._privateConstructor();

  static final ChatSercive instance = ChatSercive._privateConstructor();

  Future<dynamic> getMyGroupChat() async {
    final List<ChatGroupModel> result = [];
    try {
      final List<StoreGroup> listGroup =
          await GroupsManager.getMyListGroup() ?? [];
      final List<String> listIdUser = listGroup.map((e) {
        if (e.lastMessage != null) {
          return e.lastMessage!.senderId;
        }
        return '';
      }).toList();
      logger.d(listIdUser);
      final snapshot = await CollectionStore.users
          .where(FieldPath.documentId, whereIn: listIdUser)
          .get();
      final List<StoreGroup> userList = snapshot.docs.map((e) {
        logger.e(e.data());
        return StoreGroup.fromJson(e.data());
      }).toList();

      // late StoreUser user;
      // if (listGroup != null) {
      //   listGroup.forEach((group) {
      //     if (group.lastMessage != null) {
      //       CollectionStore.users
      //           .where('code', isEqualTo: group.lastMessage!.senderId)
      //           .get();

      //       user = StoreUser.fromJson();
      //     }
      //   });
      // }
    } catch (e) {}
  }
}

class ChatGroupModel {
  ChatGroupModel({required this.group, required this.user});

  final StoreGroup group;
  final StoreUser user;
}
