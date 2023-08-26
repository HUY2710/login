import 'package:freezed_annotation/freezed_annotation.dart';
part 'ad_unit_id_model.freezed.dart';
part 'ad_unit_id_model.g.dart';

@freezed
abstract class AdUnitIdModel with _$AdUnitIdModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AdUnitIdModel({
    required String interSplash,
    required String appOpenOnResume,
    required String nativeLanguage,
    required String nativeLanguage2,
    required String nativeLanguage3,
    required String nativeIntro,
    required String interIntro,
    required String nativePermission,
    required String interItem,
    required String nativeShare,
    required String nativeFindFriend,
    required String nativeAdd,
    required String nativeLocation,
    required String nativeTrackingUserList,
    required String bannerCollabHome,
    required String bannerAll,
    required String interAddAccount,
    required String nativeUser,
  }) = _AdUnitIdModel;

  factory AdUnitIdModel.fromJson(Map<String, dynamic> json) =>
      _$AdUnitIdModelFromJson(json);
}
