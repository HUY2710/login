import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_member.freezed.dart';
part 'store_member.g.dart';

//
@freezed
class StoreMember with _$StoreMember {
  const factory StoreMember({
    required bool isAdmin,
    @Default(true) bool onNotify,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    String? idUser, //lưu idUser vào local
  }) = _StoreMember;

  factory StoreMember.fromJson(Map<String, dynamic> json) =>
      _$StoreMemberFromJson(json);
}
