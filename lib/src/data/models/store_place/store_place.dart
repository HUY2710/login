import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_notification_place/store_notification_place.dart';

part 'store_place.freezed.dart';
part 'store_place.g.dart';

@freezed
class StorePlace with _$StorePlace {
  const factory StorePlace({
    required String iconPlace,
    required String namePlace,
    required String idCreator,
    Map<String, dynamic>? location,
    required int colorPlace,
    @Default(100) double radius,
    @JsonKey(includeFromJson: false, includeToJson: false) Uint8List? marker,
    @JsonKey(includeFromJson: false, includeToJson: false) String? idPlace,
    @JsonKey(includeFromJson: false, includeToJson: false)
    StoreNotificationPlace? myNotificationPlace,
  }) = _StorePlace;

  factory StorePlace.fromJson(Map<String, dynamic> json) =>
      _$StorePlaceFromJson(json);
}
