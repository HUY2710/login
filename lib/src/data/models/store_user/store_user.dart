import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_user.freezed.dart';
part 'store_user.g.dart';

@freezed
class StoreUser with _$StoreUser {
  const factory StoreUser({
    required String code,
    String? avatarUrl,
    String? userName,
    int? batteryLevel,
  }) = _StoreUser;

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);
}
