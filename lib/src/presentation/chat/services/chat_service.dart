import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/store_chat_group/store_chat_group.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/group_manager.dart';
import '../../../shared/helpers/logger_utils.dart';

class ChatService {
  ChatService._privateConstructor();

  static final ChatService instance = ChatService._privateConstructor();

  Future<List<StoreChatGroup>> getMyGroupChat() async {
    final List<StoreChatGroup> result = [];
    try {
      final List<StoreGroup> listGroup =
          await GroupsManager.getMyListGroup() ?? [];
      final List<String> listIdUser = listGroup.map((e) {
        if (e.lastMessage != null) {
          return e.lastMessage!.senderId;
        }
        return '';
      }).toList();
      final userSnapshot = await CollectionStore.users
          .where(FieldPath.documentId, whereIn: listIdUser)
          .get();
      final listStoreUser = userSnapshot.docs
          .map((user) => StoreUser.fromJson(user.data()))
          .toList();
      for (var i = 0; i < listGroup.length; i++) {
        for (var j = 0; j < listStoreUser.length; j++) {
          StoreChatGroup storeChatGroup =
              StoreChatGroup.fromJson(listGroup[i].toJson());

          storeChatGroup = storeChatGroup.copyWith(
              storeUser: StoreUser.fromJson(listStoreUser[j].toJson()));
          result.add(storeChatGroup);
        }
      }
      return result;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
