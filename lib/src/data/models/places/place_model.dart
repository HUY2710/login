import 'package:freezed_annotation/freezed_annotation.dart';

import '../location/location_model.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

@freezed
abstract class PlaceModel with _$PlaceModel {
  factory PlaceModel({
    required List<Place> places,
  }) = _PlaceModel;

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);
}

@freezed
abstract class Place with _$Place {
  factory Place({
    required String formattedAddress,
    required LocationModel location,
    required DisplayName displayName,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@freezed
abstract class DisplayName with _$DisplayName {
  factory DisplayName({
    required String text,
    required String languageCode,
  }) = _DisplayName;

  factory DisplayName.fromJson(Map<String, dynamic> json) =>
      _$DisplayNameFromJson(json);
}
