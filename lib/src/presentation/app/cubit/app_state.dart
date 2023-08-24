part of 'app_cubit.dart';

class AppState {

  const AppState({
    this.currentLanguage = Language.english,
    this.errorMessage = '',
  });
  final Language currentLanguage;
  final String errorMessage;

  AppState copyWith({
    Language? currentLanguage,
    String? errorMessage,
  }) {
    return AppState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Locale get locale => Locale(currentLanguage.languageCode, '');
}
