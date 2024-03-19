part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.loading() = _Loading;
  const factory SignUpState.signUpSccess() = _SignUpSccess;
  const factory SignUpState.saveCodeSccess() = _SaveCodeSuccess;
  const factory SignUpState.error({required String message}) = _Error;
}
