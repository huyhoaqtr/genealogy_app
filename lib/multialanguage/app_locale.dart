import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage/hive_manager.dart';

class AppLocale {
  factory AppLocale() {
    _instance ??= AppLocale._();

    return _instance!;
  }

  AppLocale._();

  static AppLocale? _instance;

  Map<String, Locale> listLanguages = {
    'en': const Locale('en', 'US'),
    'vi': const Locale('vi', 'VN'),
    'fr': const Locale('fr', 'FR'),
    'zh': const Locale('zh', 'CN'),
    'pt': const Locale('pt', 'PT'),
    'de': const Locale('de', 'DE'),
  };

  String getLanguageName(item) {
    switch (item) {
      case 'en':
        return 'english'.tr;
      case 'vi':
        return 'vietnamese'.tr;
      case 'fr':
        return 'french'.tr;
      case 'zh':
        return 'chinese'.tr;
      case 'pt':
        return 'portuguese'.tr;
      case 'de':
        return 'german'.tr;
      default:
        return 'united_states'.tr;
    }
  }

  void changeLanguage(String value) {
    Get.updateLocale(
        AppLocale().listLanguages[value] ?? const Locale('vi', 'VN'));
    HiveManager.shared.saveAppLanguage(value);
  }
}
