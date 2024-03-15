import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_sos.freezed.dart';
part 'store_sos.g.dart';

@freezed
class StoreSOS with _$StoreSOS {
  const factory StoreSOS({
    @Default(false) bool sos,
  }) = _StoreSOS;

  factory StoreSOS.fromJson(Map<String, dynamic> json) =>
      _$StoreSOSFromJson(json);
}
