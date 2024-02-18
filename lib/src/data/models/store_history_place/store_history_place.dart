import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_place/store_place.dart';

part 'store_history_place.freezed.dart';
part 'store_history_place.g.dart';

//save history user check in location
@freezed
class StoreHistoryPlace with _$StoreHistoryPlace {
  const factory StoreHistoryPlace({
    required String idPlace,
    required DateTime createAt,
    @JsonKey(includeToJson: false, includeFromJson: false) StorePlace? place,
  }) = _StoreHistoryPlace;

  factory StoreHistoryPlace.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryPlaceFromJson(json);
}
