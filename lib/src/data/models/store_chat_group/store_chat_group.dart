import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_member/store_member.dart';
import '../store_message/store_message.dart';
import '../store_user/store_user.dart';

part 'store_chat_group.freezed.dart';
part 'store_chat_group.g.dart';

@freezed
class StoreChatGroup with _$StoreChatGroup {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory StoreChatGroup({
    required String passCode, //code invite user join group
    required String groupName,
    required String avatarGroup,
    required int countMembers,
    String? idGroup,
    StoreUser? storeUser,
    MessageModel? lastMessage,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    List<StoreMember>? storeMembers,
  }) = _StoreChatGroup;

  factory StoreChatGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreChatGroupFromJson(json);
}
