import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_message/store_message.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/group_manager.dart';
import '../../../global/global.dart';
import '../../../services/firebase_message_service.dart';
import '../../../services/location_service.dart';
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

  Future<void> sendMessage({
    required String content,
    required String idGroup,
    required String groupName,
    bool haveNoti = true,
  }) async {
    final user = Global.instance.user;
    if (user?.code == null) {
      // ignore: only_throw_errors
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
        if (haveNoti) {
          getIt<FirebaseMessageService>().sendChatNotification(
            idGroup,
            groupName,
          );
        }

        await GroupsManager.updateGroup(
            idGroup: idGroup, fields: {'lastMessage': message.toJson()});
      } catch (e) {
        logger.e(
          'Send Mess Err: $e',
        );
      }
    }
  }

  Future<void> sendMessageLocation({
    required String content,
    required String idGroup,
    required double lat,
    required double long,
    required String groupName,
    required BuildContext context,
    bool haveNoti = true,
    bool isCheckin = false,
  }) async {
    final user = Global.instance.user;
    if (user?.code == null) {
      // ignore: only_throw_errors
      throw 'User must have';
    } else {
      final message = MessageModel(
        content: content,
        senderId: user?.code ?? '',
        sentAt: DateTime.now().toString(),
        lat: lat,
        long: long,
      );
      try {
        await CollectionStore.chat
            .doc(idGroup)
            .collection(CollectionStoreConstant.messages)
            .add(message.toJson());
        if (haveNoti) {
          if (isCheckin) {
            final address =
                await LocationService().getCurrentAddress(LatLng(lat, long));
            if (context.mounted) {
              getIt<FirebaseMessageService>()
                  .sendCheckInNotification(idGroup, address, context);
            }
          } else {
            getIt<FirebaseMessageService>().sendChatNotification(
              idGroup,
              groupName,
            );
          }
        }
        await GroupsManager.updateGroup(
            idGroup: idGroup, fields: {'lastMessage': message.toJson()});
      } catch (e) {
        logger.e(
          'Send Mess Location Err: $e',
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
