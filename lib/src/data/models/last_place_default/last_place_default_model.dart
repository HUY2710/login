import 'package:freezed_annotation/freezed_annotation.dart';
part 'last_place_default_model.freezed.dart';
part 'last_place_default_model.g.dart';

@freezed
abstract class LastPlaceDefault with _$LastPlaceDefault {
  factory LastPlaceDefault({
    required double latitude,
    required double longitude,
    required DateTime lastTime,
    required String idHistoryPlace,
  }) = _LastPlaceDefault;

  factory LastPlaceDefault.fromJson(Map<String, dynamic> json) =>
      _$LastPlaceDefaultFromJson(json);
}
