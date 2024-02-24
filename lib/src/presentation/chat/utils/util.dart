import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/local/shared_preferences_manager.dart';
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

  static Future<bool> getSeenMess(String idGroup, String lastSeen) async {
    final String timeLastSeenLocal =
        await SharedPreferencesManager.getTimeSeenChat(idGroup) ??
            DateTime.now().toString();
    final dateTimeLastSeenLocal = DateTime.parse(timeLastSeenLocal);
    final dateTimeLastSeen = DateTime.parse(lastSeen);
    return dateTimeLastSeenLocal.isBefore(dateTimeLastSeen);
  }
}
