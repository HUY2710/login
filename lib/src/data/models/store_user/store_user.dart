import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_location/store_location.dart';

part 'store_user.freezed.dart';
part 'store_user.g.dart';

@freezed
class StoreUser with _$StoreUser {
  const factory StoreUser({
    required String code,
    required String avatarUrl,
    required String userName,
    required int batteryLevel,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    Uint8List? marker,
    @JsonKey(includeFromJson: false, includeToJson: false)
    StoreLocation? location,
  }) = _StoreUser;

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);
}
