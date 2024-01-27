import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_member/store_member.dart';
import '../store_message/store_message.dart';
import '../store_user/store_user.dart';

part 'store_chat_group.freezed.dart';
part 'store_chat_group.g.dart';

//save history user check in location
@freezed
class StoreChatGroup with _$StoreChatGroup {
  const factory StoreChatGroup({
    required String passCode, //code invite user join group
    required String groupName,
    required String avatarGroup,
    required int countMembers,
    // @JsonKey(
    //   includeFromJson: true,
    //   includeToJson: false,
    // )
    String? idGroup,
    MessageModel? lastMessage,
    StoreUser? storeUser,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    List<StoreMember>? storeMembers,
  }) = _StoreChatGroup;

  factory StoreChatGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreChatGroupFromJson(json);
}
