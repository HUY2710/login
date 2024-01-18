import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../src/shared/cubit/value_cubit.dart';
import '../../src/shared/enum/language.dart';

class LanguageCubit extends ValueCubit<Language> with HydratedMixin {
  LanguageCubit() : super(Language.english){
    hydrate();
  }

  @override
  Language fromJson(Map<String, dynamic> json) {
    for (final element in Language.values) {
      if (element.languageCode == json['languageCode']) {
        return element;
      }
    }
    return Language.english;
  }

  @override
  Map<String, dynamic> toJson(Language state) {
    return {
      'languageCode': state.languageCode,
    };
  }
}
