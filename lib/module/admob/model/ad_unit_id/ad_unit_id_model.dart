import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_unit_id_model.freezed.dart';
part 'ad_unit_id_model.g.dart';

@freezed
abstract class AdUnitIdModel with _$AdUnitIdModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AdUnitIdModel({
    required String interSplash,
    required String appopenResume,
    required String nativeLanguage,
    required String nativeLanguageSetting,
    required String bannerCollapseHome,
    required String bannerAll,
    required String interMessage,
    required String interAddPlace,
    required String nativeMap,
    required String interEditProfile,
    required String nativeEdit,
  }) = _AdUnitIdModel;

  factory AdUnitIdModel.fromJson(Map<String, dynamic> json) =>
      _$AdUnitIdModelFromJson(json);
}
