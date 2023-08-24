import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../service/services.dart';
import '../../../shared/enum/language.dart';

part 'app_state.dart';

@singleton
class AppCubit extends Cubit<AppState> {
  AppCubit(super.initialState);

  Future<void> init() async {
    try {
      final languageCode =
          await SharedPreferencesManager.getCurrentLanguageCode;

      final currentLanguage = languageCode != null
          ? Language.values.firstWhere(
              (element) => element.languageCode == languageCode,
            )
          : Language.english;
      debugPrint('currentLanguage: $currentLanguage');
      emit(
        state.copyWith(
          currentLanguage: currentLanguage,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> changeLanguage(Language language) async {
    try {
      await SharedPreferencesManager.saveCurrentLanguageCode(
          language.languageCode);
      emit(
        state.copyWith(
          currentLanguage: language,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
