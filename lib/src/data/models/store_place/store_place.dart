import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

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
    required double? radius,
    @JsonKey(includeFromJson: false, includeToJson: false) Uint8List? marker,
    @Default(true) bool onNotify,
    @Default(false) bool isSendLeaved,
    @Default(false) bool isSendArrived,
    @JsonKey(includeFromJson: false, includeToJson: false) String? idPlace,
  }) = _StorePlace;

  factory StorePlace.fromJson(Map<String, dynamic> json) =>
      _$StorePlaceFromJson(json);
}
