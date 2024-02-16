import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_member/store_member.dart';
import '../store_message/store_message.dart';
import '../store_user/store_user.dart';

part 'store_group.freezed.dart';
part 'store_group.g.dart';

//save history user check in location
@freezed
class StoreGroup with _$StoreGroup {
  @JsonSerializable(explicitToJson: true)
  const factory StoreGroup({
    required String passCode, //code invite user join group
    required String groupName,
    required String avatarGroup,
    // @JsonKey(
    //   includeFromJson: true,
    //   includeToJson: false,
    // )
    String? idGroup,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    StoreUser? storeUser,
    MessageModel? lastMessage,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    bool? seen,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    List<StoreMember>? storeMembers,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default(false)
    bool? isEdit,
  }) = _StoreGroup;

  factory StoreGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreGroupFromJson(json);
}
