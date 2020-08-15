import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  AppTranslations(this.locale);
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    final AppTranslations appTranslations = AppTranslations(locale);
    final String jsonContent = await rootBundle
        .loadString('assets/locale/localization_${locale.languageCode}.json');
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  String get currentLanguage => locale.languageCode;

  String getString(String key) {
    return _localisedValues[key] ?? '$key not found';
  }
}
