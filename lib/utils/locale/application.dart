import 'dart:ui';

class Application {
  factory Application() {
    return _application;
  }

  Application._internal();

  static final Application _application = Application._internal();

  final List<String> supportedLanguages = <String>[
    'English',
    'Japanese',
  ];

  final List<String> supportedLanguagesCodes = <String>[
    'en',
    'ja',
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() => supportedLanguagesCodes
      .map<Locale>((String language) => Locale(language, ''));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef LocaleChangeCallback = void Function(Locale locale);
