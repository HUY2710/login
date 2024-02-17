import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
class RouteModel with _$RouteModel {
  factory RouteModel({
    required int distanceMeters,
    required String duration,
    required PolylineModel polyline,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}

@freezed
class PolylineModel with _$PolylineModel {
  factory PolylineModel({
    required String encodedPolyline,
  }) = _PolylineModel;

  factory PolylineModel.fromJson(Map<String, dynamic> json) =>
      _$PolylineModelFromJson(json);
}
