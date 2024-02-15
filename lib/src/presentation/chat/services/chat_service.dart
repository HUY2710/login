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

  Future<List<String>?> getIdsMyGroup() async {
    try {
      final String code = Global.instance.user!.code;

      //lấy ra toàn bộ id các group của mình
      final snapShotGroups = await CollectionStore.users
          .doc(code)
          .collection(CollectionStoreConstant.myGroups)
          .get();
      if (snapShotGroups.docs.isNotEmpty) {
        final List<String> myListIdGroup =
            snapShotGroups.docs.map((e) => e.id).toList();

        final List<String> idsCondition = myListIdGroup.map((e) => e).toList();
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
      if (listGroup.isNotEmpty) {
        final List<String> listIdUser = listGroup.map((e) {
          return e.lastMessage!.senderId;
        }).toList();
        return listIdUser;
      }
    } catch (e) {
      logger.e('getListIdUserFromLastMessage $e');
    }
    return [];
  }

  Future<List<StoreUser>> getUserFromListId(List<String> listIdUser) async {
    try {
      if (listIdUser.isEmpty) {
        return [];
      }
      final userSnapshot = await CollectionStore.users
          .where(FieldPath.documentId, whereIn: listIdUser)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        final listStoreUser = userSnapshot.docs
            .map((user) => StoreUser.fromJson(user.data()))
            .toList();
        return listStoreUser;
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
    return [];
  }

  Future<void> sendMessage(
      {required String content, required String idGroup}) async {
    final user = Global.instance.user;
    if (user?.code == null) {
      throw 'User must have';
    } else {
      final message = MessageModel(
          content: content,
          senderId: user?.code ?? '',
          sentAt: DateTime.now().toString());
      try {
        await CollectionStore.chat
            .doc(idGroup)
            .collection(CollectionStoreConstant.messages)
            .add(message.toJson());
        await GroupsManager.updateGroup(
            idGroup: idGroup, fields: {'lastMessage': message.toJson()});
      } catch (e) {
        logger.e(
          'Send Mess Err: $e',
        );
      }
    }
  }

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

  Stream<QuerySnapshot<MessageModel>> streamMessageGroup(
      String idGroup, List<StoreUser> listUser) {
    late Stream<QuerySnapshot<MessageModel>> result;
    try {
      result = CollectionStore.chat
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
    } catch (e) {
      logger.e('ERRROE stream mess $e');
    }
    return result;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyGroupChat2(
      List<String> idsMyGroup) {
    return CollectionStore.groups
        .where(FieldPath.documentId, whereIn: idsMyGroup)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser2() {
    final String code = Global.instance.user!.code;
    return CollectionStore.users
        .doc(code)
        .collection(CollectionStoreConstant.myGroups)
        .snapshots();
  }
}
