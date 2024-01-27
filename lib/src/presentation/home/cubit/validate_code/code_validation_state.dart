part of 'code_validation_cubit.dart';

@freezed
class CodeValidationState with _$CodeValidationState {
  const factory CodeValidationState.initial() = _Initial;

  const factory CodeValidationState.loading() = _Loading;

  const factory CodeValidationState.valid(StoreGroup group) = _Valid;

  const factory CodeValidationState.inValid(String error) = _InValid;
}
