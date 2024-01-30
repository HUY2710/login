import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream<QuerySnapshot<StoreGroup>> getMyGroupChat(
    List<String> idsMyGroup,
    List<StoreUser> listStoreUser,
  ) {
    return CollectionStore.groups
        .where(FieldPath.documentId, whereIn: idsMyGroup)
        .withConverter(
            fromFirestore: (snapshot, _) {
              StoreGroup storeGroup = StoreGroup.fromJson(snapshot.data()!);
              storeGroup = storeGroup.copyWith(
                  storeUser: listStoreUser.firstWhere(
                      (user) => user.code == storeGroup.lastMessage!.senderId));
              return storeGroup;
            },
            toFirestore: (message, _) => message.toJson())
        .snapshots();
  }

  Future<List<String>?> getIdsMyGroup() async {
    try {
      final String code = Global.instance.user!.code;

      //lấy ra toàn bộ id các group của mình
      final snapShotGroups = await CollectionStore.users
          .doc(code)
          .collection(CollectionStoreConstant.myGroups)
          .get();
      if (snapShotGroups.docs.isNotEmpty) {
        final List<MyIdGroup> myListIdGroup = snapShotGroups.docs
            .map((e) => MyIdGroup.fromJson(e.data()))
            .toList();

        final List<String> idsCondition =
            myListIdGroup.map((e) => e.idGroup).toList();
        return idsCondition;
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<List<String>> getListIdUserFromLastMessage() async {
    try {
      final List<StoreGroup> listGroup =
          await GroupsManager.getMyListGroup() ?? [];
      final List<String> listIdUser = listGroup.map((e) {
        return e.lastMessage!.senderId;
      }).toList();
      return listIdUser;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<List<StoreUser>> getUserFromListId(List<String> listIdUser) async {
    try {
      final userSnapshot = await CollectionStore.users
          .where(FieldPath.documentId, whereIn: listIdUser)
          .get();
      final listStoreUser = userSnapshot.docs
          .map((user) => StoreUser.fromJson(user.data()))
          .toList();
      return listStoreUser;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Stream<QuerySnapshot<MessageModel>> streamMessageGroup(
      String idGroup, List<StoreUser> listUser) {
    return CollectionStore.chat
        .doc(idGroup)
        .collection(CollectionStoreConstant.messages)
        .orderBy('sentAt')
        .withConverter(
            fromFirestore: (snapshot, _) {
              MessageModel message = MessageModel.fromJson(snapshot.data()!);
              message = message.copyWith(
                  avatarUrl: listUser
                      .firstWhere((user) => user.code == message.senderId)
                      .avatarUrl,
                  userName: listUser
                      .firstWhere((user) => user.code == message.senderId)
                      .userName);
              return message;
            },
            toFirestore: (message, _) => message.toJson())
        .snapshots();
  }
}
