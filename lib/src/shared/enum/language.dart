import '../../gen/gens.dart';

enum Language {
  english(
    languageName: 'English',
    languageCode: 'en',
  ),
  spanish(
    languageName: 'Spanish',
    languageCode: 'es',
  ),
  french(
    languageName: 'French',
    languageCode: 'fr',
  ),
  hindi(
    languageName: 'Hindi',
    languageCode: 'hi',
  ),
  portuguese(
    languageName: 'Portuguese',
    languageCode: 'pr',
  ),
  german(
    languageName: 'German',
    languageCode: 'de',
  ),
  indonesia(
    languageName: 'Indonesia',
    languageCode: 'id',
  ),
  korean(
    languageName: 'Korean',
    languageCode: 'ko',
  ),
  ;

  const Language({
    required this.languageCode,
    required this.languageName,
  });

  final String languageCode;
  final String languageName;
  @override
  String toString() => languageName;
}

extension LanguageExtension on Language {
  String get flagPath {
    switch (this) {
      case Language.english:
        return Assets.images.languages.en.path;
      case Language.french:
        return Assets.images.languages.fr.path;
      case Language.spanish:
        return Assets.images.languages.es.path;
      case Language.hindi:
        return Assets.images.languages.hi.path;
      case Language.portuguese:
        return Assets.images.languages.pr.path;
      case Language.german:
        return Assets.images.languages.de.path;
      case Language.indonesia:
        return Assets.images.languages.id.path;
      case Language.korean:
        return Assets.images.languages.ko.path;
    }
  }
}
