part of 'language_bloc.dart';

@freezed
class LanguageState with _$LanguageState {
  const factory LanguageState.initial() = _Initial;
  const factory LanguageState.loaded({required String language}) = _Loaded;
  const factory LanguageState.error({required String message}) = _Error;
}
