import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_message.freezed.dart';
part 'store_message.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String content,
    required String senderId,
    required String sentAt,
  }) = _MessageModel;
  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}
