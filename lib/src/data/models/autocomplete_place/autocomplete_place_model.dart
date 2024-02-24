import 'package:freezed_annotation/freezed_annotation.dart';

part 'autocomplete_place_model.freezed.dart';
part 'autocomplete_place_model.g.dart';

@freezed
class AutoCompletePlaceModel with _$AutoCompletePlaceModel {
  const factory AutoCompletePlaceModel({
    required List<Prediction> predictions,
    required String status,
  }) = _AutoCompletePlaceModel;

  factory AutoCompletePlaceModel.fromJson(Map<String, dynamic> json) =>
      _$AutoCompletePlaceModelFromJson(json);
}

@freezed
class Prediction with _$Prediction {
  const factory Prediction({
    required String description,
    required String place_id,
  }) = _Prediction;

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);
}
