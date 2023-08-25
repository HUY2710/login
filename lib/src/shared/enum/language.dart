import '../../gen/gens.dart';

enum Language {
  english(
    languageName: 'English',
    languageCode: 'en',
  ),
  french(
    languageName: 'French',
    languageCode: 'fr',
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
    }
  }
}
