import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../src/config/di/di.dart';
import '../../src/data/local/shared_preferences_manager.dart';
import '../../src/shared/enum/language.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

@singleton
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  Future<void> init() async {
    try {
      final languageCode =
          await getIt<SharedPreferencesManager>().getCurrentLanguageCode;
      final Language currentLanguage = Language.values.firstWhere(
        (element) => element.languageCode == languageCode,
        orElse: () => Language.english,
      );
      emit(
        state.copyWith(
          currentLanguage: currentLanguage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> changeLanguage(Language language) async {
    try {
      await getIt<SharedPreferencesManager>()
          .saveCurrentLanguageCode(language.languageCode);
      emit(
        state.copyWith(
          currentLanguage: language,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
