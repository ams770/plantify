import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/language_manager.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  /* -------------------------------------------------------------------------- */
  /*                                App Language                                */
  /* -------------------------------------------------------------------------- */
  Future<String> getAppLanguage() async {
    String? language =
        _sharedPreferences.getString(PreferencesKeys.appLanguageKey);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      /* ------------------------- Return Device Language ------------------------- */
      bool isAr = Platform.localeName.contains("ar");
      return isAr
          ? LanguageType.ARABIC.getValue()
          : LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLanguage = await getAppLanguage();

    if (currentLanguage == LanguageType.ARABIC.getValue()) {
      //set english
      _sharedPreferences.setString(
          PreferencesKeys.appLanguageKey, LanguageType.ENGLISH.getValue());
    } else {
      //set arabic
      _sharedPreferences.setString(
          PreferencesKeys.appLanguageKey, LanguageType.ARABIC.getValue());
    }
  }

  /* ----------------------------- Device Locality ---------------------------- */
  Future<Locale> getLocale() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.ARABIC.getValue()) {
      //set english
      return ARABIC_LOCALE;
    } else {
      //set arabic
      return ENGLISH_LOCALE;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                 First Open                                 */
  /* -------------------------------------------------------------------------- */
  setFirstOpen() =>
      _sharedPreferences.setBool(PreferencesKeys.firstOpenKey, true);
  bool get isFirstOpen => _sharedPreferences.getBool(PreferencesKeys.firstOpenKey)?? true;
}

class PreferencesKeys {
  static const String appLanguageKey = "App Language Key";
  static const String firstOpenKey = "First Open Key";
}
