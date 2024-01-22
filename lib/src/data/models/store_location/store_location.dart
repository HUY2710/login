import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_location.freezed.dart';
part 'store_location.g.dart';

//save history user check in location
@freezed
class StoreLocation with _$StoreLocation {
  const factory StoreLocation({
    required String address,
    required double lat,
    required double lng,
    required DateTime updatedAt,
  }) = _StoreLocation;

  factory StoreLocation.fromJson(Map<String, dynamic> json) =>
      _$StoreLocationFromJson(json);
}
