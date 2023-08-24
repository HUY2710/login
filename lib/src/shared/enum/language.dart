enum Language {
  english(
    languageName: "English",
    languageCode: "en",
  ),
  spanish(
    languageName: "Spanish",
    languageCode: "es",
  ),
  french(
    languageName: "French",
    languageCode: "fr",
  ),
  hindi(
    languageName: "Hindi",
    languageCode: "hi",
  ),
  portuguese(
    languageName: "Portuguese",
    languageCode: "pt",
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
