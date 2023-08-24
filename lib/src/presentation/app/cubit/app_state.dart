part of 'app_cubit.dart';

class AppState {
  final Language currentLanguage;
  final String errorMessage;

  const AppState({
    this.currentLanguage = Language.english,
    this.errorMessage = "",
  });

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
