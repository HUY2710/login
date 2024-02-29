import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_token.freezed.dart';
part 'store_token.g.dart';

//
@freezed
class StoreToken with _$StoreToken {
  const factory StoreToken({
    required Map userTokens,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    String? groupId,
  }) = _StoreToken;

  factory StoreToken.fromJson(Map<String, dynamic> json) =>
      _$StoreTokenFromJson(json);
}
