import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../../config/di/di.dart';
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


// import 'package:intl/intl.dart';

// List<Object> calculateChatMessages(
//   List<types.Message> messages,
//   types.User user, {
//   String Function(DateTime)? customDateHeaderText,
//   DateFormat? dateFormat,
//   required int dateHeaderThreshold,
//   bool dateIsUtc = false,
//   String? dateLocale,
//   required int groupMessagesThreshold,
//   String? lastReadMessageId,
//   required bool showUserNames,
//   DateFormat? timeFormat,
// }) {
//   final chatMessages = <Object>[];
//   final gallery = <PreviewImage>[];

//   var shouldShowName = false;

//   for (var i = messages.length - 1; i >= 0; i--) {
//     final isFirst = i == messages.length - 1;
//     final isLast = i == 0;
//     final message = messages[i];
//     final messageHasCreatedAt = message.createdAt != null;
//     final nextMessage = isLast ? null : messages[i - 1];
//     final nextMessageHasCreatedAt = nextMessage?.createdAt != null;
//     final nextMessageSameAuthor = message.author.id == nextMessage?.author.id;
//     final notMyMessage = message.author.id != user.id;

//     var nextMessageDateThreshold = false;
//     var nextMessageDifferentDay = false;
//     var nextMessageInGroup = false;
//     var showName = false;

//     if (showUserNames) {
//       final previousMessage = isFirst ? null : messages[i + 1];

//       final isFirstInGroup = notMyMessage &&
//           ((message.author.id != previousMessage?.author.id) ||
//               (messageHasCreatedAt &&
//                   previousMessage?.createdAt != null &&
//                   message.createdAt! - previousMessage!.createdAt! >
//                       groupMessagesThreshold));

//       if (isFirstInGroup) {
//         shouldShowName = false;
//         if (message.type == types.MessageType.text) {
//           showName = true;
//         } else {
//           shouldShowName = true;
//         }
//       }

//       if (message.type == types.MessageType.text && shouldShowName) {
//         showName = true;
//         shouldShowName = false;
//       }
//     }

//     if (messageHasCreatedAt && nextMessageHasCreatedAt) {
//       nextMessageDateThreshold =
//           nextMessage!.createdAt! - message.createdAt! >= dateHeaderThreshold;

//       nextMessageDifferentDay = DateTime.fromMillisecondsSinceEpoch(
//             message.createdAt!,
//             isUtc: dateIsUtc,
//           ).day !=
//           DateTime.fromMillisecondsSinceEpoch(
//             nextMessage.createdAt!,
//             isUtc: dateIsUtc,
//           ).day;

//       nextMessageInGroup = nextMessageSameAuthor &&
//           message.id != lastReadMessageId &&
//           nextMessage.createdAt! - message.createdAt! <= groupMessagesThreshold;
//     }

//     if (isFirst && messageHasCreatedAt) {
//       chatMessages.insert(
//         0,
//         DateHeader(
//           dateTime: DateTime.fromMillisecondsSinceEpoch(
//             message.createdAt!,
//             isUtc: dateIsUtc,
//           ),
//           text: customDateHeaderText != null
//               ? customDateHeaderText(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     message.createdAt!,
//                     isUtc: dateIsUtc,
//                   ),
//                 )
//               : getVerboseDateTimeRepresentation(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     message.createdAt!,
//                     isUtc: dateIsUtc,
//                   ),
//                   dateFormat: dateFormat,
//                   dateLocale: dateLocale,
//                   timeFormat: timeFormat,
//                 ),
//         ),
//       );
//     }

//     chatMessages.insert(0, {
//       'message': message,
//       'nextMessageInGroup': nextMessageInGroup,
//       'showName': notMyMessage && showUserNames && showName,
//       'showStatus': message.showStatus ?? true,
//     });

//     if (!nextMessageInGroup && message.type != types.MessageType.system) {
//       chatMessages.insert(
//         0,
//         MessageSpacer(
//           height: 12,
//           id: message.id,
//         ),
//       );
//     }

//     if (nextMessageDifferentDay || nextMessageDateThreshold) {
//       chatMessages.insert(
//         0,
//         DateHeader(
//           dateTime: DateTime.fromMillisecondsSinceEpoch(
//             nextMessage!.createdAt!,
//             isUtc: dateIsUtc,
//           ),
//           text: customDateHeaderText != null
//               ? customDateHeaderText(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     nextMessage.createdAt!,
//                     isUtc: dateIsUtc,
//                   ),
//                 )
//               : getVerboseDateTimeRepresentation(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     nextMessage.createdAt!,
//                     isUtc: dateIsUtc,
//                   ),
//                   dateFormat: dateFormat,
//                   dateLocale: dateLocale,
//                   timeFormat: timeFormat,
//                 ),
//         ),
//       );
//     }

//     if (message.id == lastReadMessageId && !isLast) {
//       chatMessages.insert(
//         0,
//         UnreadHeaderData(
//           marginTop:
//               nextMessageDifferentDay || nextMessageDateThreshold ? 0 : 8,
//         ),
//       );
//     }

//     if (message is types.ImageMessage) {
//       if (kIsWeb) {
//         if (message.uri.startsWith('http') || message.uri.startsWith('blob')) {
//           gallery.add(PreviewImage(id: message.id, uri: message.uri));
//         }
//       } else {
//         gallery.add(PreviewImage(id: message.id, uri: message.uri));
//       }
//     }
//   }

//   return [chatMessages, gallery];
// }


