import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_notification_place.freezed.dart';
part 'store_notification_place.g.dart';

@freezed
class StoreNotificationPlace with _$StoreNotificationPlace {
  const factory StoreNotificationPlace({
    @Default(false) bool isSendLeaved,
    @Default(false) bool isSendArrived,
    @JsonKey(includeFromJson: false, includeToJson: false) String? idUser,
  }) = _StoreNotificationPlace;

  factory StoreNotificationPlace.fromJson(Map<String, dynamic> json) =>
      _$StoreNotificationPlaceFromJson(json);
}
