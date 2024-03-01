import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_notification_place.freezed.dart';
part 'store_notification_place.g.dart';

@freezed
class StoreNotificationPlacePlace with _$StoreNotificationPlacePlace {
  const factory StoreNotificationPlacePlace({
    @Default(false) bool isSendLeaved,
    @Default(false) bool isSendArrived,
    @JsonKey(includeFromJson: false, includeToJson: false) String? idUser,
  }) = _StoreNotificationPlacePlace;

  factory StoreNotificationPlacePlace.fromJson(Map<String, dynamic> json) =>
      _$StoreNotificationPlacePlaceFromJson(json);
}
