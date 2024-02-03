import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_member/store_member.dart';

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
  }) = _StoreGroup;

  factory StoreGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreGroupFromJson(json);
}

@freezed
class MyIdGroup with _$MyIdGroup {
  const factory MyIdGroup({
    required String idGroup, //code invite user join group
  }) = _MyIdGroup;

  factory MyIdGroup.fromJson(Map<String, dynamic> json) =>
      _$MyIdGroupFromJson(json);
}
