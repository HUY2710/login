import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_unit_id_model.freezed.dart';
part 'ad_unit_id_model.g.dart';

@freezed
abstract class AdUnitIdModel with _$AdUnitIdModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AdUnitIdModel({
    required String adOpen,
    required String inter,
    required String banner,
    required String native,
    required String collapseBanner,
  }) = _AdUnitIdModel;

  factory AdUnitIdModel.fromJson(Map<String, dynamic> json) =>
      _$AdUnitIdModelFromJson(json);
}
