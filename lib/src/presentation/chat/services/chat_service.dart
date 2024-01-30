import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/store_chat_group/store_chat_group.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_message/store_message.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/group_manager.dart';
import '../../../global/global.dart';
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
        return Global.instance.user!.code;
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
              storeUser: StoreUser.fromJson(
                listStoreUser[j].toJson(),
              ),
              storeMembers: listGroup[i].storeMembers);
          result.add(storeChatGroup);
        }
      }
      return result;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Stream<QuerySnapshot<MessageModel>> streamMessageGroup(String idGroup) {
    final message = CollectionStore.chat
        .doc(idGroup)
        .collection(CollectionStoreConstant.messages)
        .orderBy('sentAt')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                MessageModel.fromJson(snapshot.data()!),
            toFirestore: (message, _) => message.toJson())
        .snapshots();

    return message;
  }
}
