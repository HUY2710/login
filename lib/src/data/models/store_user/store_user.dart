import 'dart:async';

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
    @Default('UNKNOWN') String activityType,
    @Default(0) int steps,
    @Default(true) bool online,
    @Default(true) bool shareLocation,
    @Default('') String fcmToken,
    @JsonKey(includeFromJson: false, includeToJson: false) Uint8List? marker,
    @JsonKey(includeFromJson: false, includeToJson: false)
    StoreLocation? location,
    @JsonKey(includeFromJson: false, includeToJson: false)
    StreamSubscription? subscriptionLocation,
    @JsonKey(includeFromJson: false, includeToJson: false)
    StreamSubscription? subscriptionUser,
  }) = _StoreUser;

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);
}
