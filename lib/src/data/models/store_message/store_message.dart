import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_message.freezed.dart';
part 'store_message.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String content,
    required String senderId,
    required String sentAt,
    double? lat,
    double? long,
    @JsonKey(includeToJson: false, includeFromJson: false) String? avatarUrl,
    @JsonKey(includeToJson: false, includeFromJson: false) String? userName,
  }) = _MessageModel;
  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}
