import 'dart:async';

import 'package:flutter/material.dart';

import 'app_translation.dart';
import 'application.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const AppTranslationsDelegate({this.newLocale});

  final Locale newLocale;

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    return AppTranslations.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}
