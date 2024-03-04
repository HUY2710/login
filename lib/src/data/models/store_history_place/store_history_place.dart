import 'package:freezed_annotation/freezed_annotation.dart';

import '../store_place/store_place.dart';

part 'store_history_place.freezed.dart';
part 'store_history_place.g.dart';

//save history user check in location
@freezed
class StoreHistoryPlace with _$StoreHistoryPlace {
  const factory StoreHistoryPlace({
    required String idPlace, //để biết thông tin về place đó
    required DateTime enterTime, //time user vào
    DateTime? leftTime, //time user rời khỏi
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? idHistoryPlace,
    @JsonKey(includeToJson: false, includeFromJson: false) StorePlace? place,
    @Default('') String? nameDefault,
  }) = _StoreHistoryPlace;

  factory StoreHistoryPlace.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryPlaceFromJson(json);
}
