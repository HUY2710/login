part of 'sos_cubit.dart';

@freezed
class SosState with _$SosState {
  const factory SosState.loading() = _Loading;

  const factory SosState.success(bool status) = _Success;

  const factory SosState.error(String message) = _Error;
}
