part of 'sign_in_cubit.dart';

enum SignInStepEnum {
  inputEmail,
  verifyCode,
}

enum SignInStatus {
  initial,
  loading,
  success,
  sendSuccess,
  error,
}

@freezed
class SignInState with _$SignInState {
  const factory SignInState({
    @Default(SignInStepEnum.inputEmail) SignInStepEnum signInStepEnum,
    @Default(SignInStatus.initial) SignInStatus signInStatus,
    @Default('') String errorMessage,
    @Default('') String email,
    @Default('') String password,
    @Default(null) bool? isVerified,
    @Default(false) bool isResendCode,
  }) = _SignInState;
}
