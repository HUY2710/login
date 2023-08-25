import 'package:freezed_annotation/freezed_annotation.dart';
part 'ad_unit_id_model.freezed.dart';
part 'ad_unit_id_model.g.dart';

@freezed
abstract class AdUnitIdModel with _$AdUnitIdModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AdUnitIdModel({
    required String interSplash,
  }) = _AdUnitIdModel;

  factory AdUnitIdModel.fromJson(Map<String, dynamic> json) =>
      _$AdUnitIdModelFromJson(json);
}
