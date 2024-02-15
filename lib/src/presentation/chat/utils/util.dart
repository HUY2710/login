import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/store_message/store_message.dart';
import '../../../global/global.dart';

class Utils {
  Utils._();
  static bool checkLastMessage(
      {required String code, required bool isLastMessage}) {
    final userCode = Global.instance.user!.code;
    return userCode == code && isLastMessage;
  }

  static bool checkIsUser({required String code}) {
    return Global.instance.user!.code == code;
  }

  static bool checkLastMessByUser(
      int index, List<QueryDocumentSnapshot<MessageModel>> chats) {
    return index < chats.length - 1 &&
        chats[index].data().senderId == chats[index + 1].data().senderId;
    // &&
    // chats[index].data().senderId == chats.last.data().senderId;
  }

  static bool compareUserCode(
      int index, List<QueryDocumentSnapshot<MessageModel>> chats) {
    if (index == 0) {
      return false;
    }
    return chats[index - 1].data().senderId == chats[index].data().senderId;
  }

  static bool checkSeen(String? timeLastSeenString, String timeOfMessage) {
    if (timeLastSeenString == null) {
      return false;
    }
    final timeLastSeen = DateTime.parse(timeLastSeenString);
    return timeLastSeen.isBefore(DateTime.parse(timeOfMessage));
  }

  // static void findUserByCode(String code) {
  //   final userSnapshot = CollectionStore.users
  //       .where(FieldPath.documentId, isEqualTo: code)
  //       .get();
  //   final listStoreUser = userSnapshot.docs
  //       .map((user) => StoreUser.fromJson(user.data()))
  //       .toList();
  //   return listStoreUser.firstWhere((user) => user.code == code);
  // }
}
