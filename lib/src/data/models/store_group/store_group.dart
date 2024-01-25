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
    required String avatarGroup,
    Map<String, dynamic>? members,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    idGroup,
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
