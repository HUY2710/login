part of 'app_cubit.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(Language.english) Language currentLanguage,
    @Default('') String errorMessage,
  }) = _AppState;
}
