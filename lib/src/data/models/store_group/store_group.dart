import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_group.freezed.dart';
part 'store_group.g.dart';

//save history user check in location
@freezed
class StoreGroup with _$StoreGroup {
  const factory StoreGroup({
    required String code, //code invite user join group
    required String groupName,
    required String iconGroup,
    List<MembersGroup>? members,
  }) = _StoreGroup;

  factory StoreGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreGroupFromJson(json);
}

@freezed
class MembersGroup with _$MembersGroup {
  const factory MembersGroup({
    Map<String, dynamic>? isAdmin,
  }) = _MembersGroup;

  factory MembersGroup.fromJson(Map<String, dynamic> json) =>
      _$MembersGroupFromJson(json);
}
