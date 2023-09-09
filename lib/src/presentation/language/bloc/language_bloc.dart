import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../config/di/di.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../shared/enum/language.dart';

part 'language_bloc.freezed.dart';
part 'language_state.dart';

@singleton
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
      : super(LanguageState.loaded(language: Language.english.languageCode));

  Future<void> loadLanguage() async {
    try {
      final String? language =
          await getIt<SharedPreferencesManager>().getCurrentLanguageCode;
      if (language != null) {
        emit(LanguageState.loaded(language: language));
      } else {
        emit(LanguageState.loaded(language: Language.english.languageCode));
      }
    } catch (e) {
      emit(const LanguageState.error(message: 'Failed to load language'));
    }
  }

  Future<void> changeLanguage(String language) async {
    try {
      await getIt<SharedPreferencesManager>().saveCurrentLanguageCode(language);
      emit(LanguageState.loaded(language: language));
    } catch (e) {
      emit(const LanguageState.error(message: 'Failed to change language'));
    }
  }
}
