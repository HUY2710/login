import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_location/store_location.dart';

part 'store_place.freezed.dart';
part 'store_place.g.dart';

@freezed
class StorePlace with _$StorePlace {
  const factory StorePlace({
    required String codePlace,
    required String iconPlace,
    required String namePlace,
    required int addressPlace,
    StoreLocation? location,
    required double? radius,
    required bool? onNotify,
  }) = _StorePlace;

  factory StorePlace.fromJson(Map<String, dynamic> json) =>
      _$StorePlaceFromJson(json);
}
