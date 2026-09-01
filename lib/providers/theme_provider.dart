import 'package:flutter/material.dart';

import '../core/constants/app_theme.dart';
import '../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const List<String> supportedLanguages = [
    'en',
    'tr',
    'ar',
    'de',
    'fr',
    'es',
    'pt',
    'ru',
    'id',
    'ur',
    'ms',
  ];

  late AppThemeType _themeType;
  String _themePreference = StorageService.themePreference;
  String _colorTheme = StorageService.colorTheme;
  late String _languageCode;
  bool _showSeconds = StorageService.showSecondsInPrayerTimes;
  String _numberFormat = StorageService.numberFormat;
  double _arabicFontSize = StorageService.arabicFontSize;
  double _translationFontSize = StorageService.translationFontSize;

  ThemeProvider() {
    _loadThemeType();
    _loadLanguage();
  }

  void _loadLanguage() {
    final saved = StorageService.savedLanguageCode;
    if (saved != null && supportedLanguages.contains(saved)) {
      _languageCode = saved;
    } else {
      try {
        final deviceCode = WidgetsBinding
            .instance.platformDispatcher.locale.languageCode
            .toLowerCase();
        if (supportedLanguages.contains(deviceCode)) {
          _languageCode = deviceCode;
        } else {
          _languageCode = 'en';
        }
      } catch (_) {
        _languageCode = 'en';
      }
      StorageService.setLanguageCode(_languageCode);
    }
  }

  void _loadThemeType() {
    final raw = StorageService.appThemeType;
    _themeType = AppThemeType.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemeType.theme1,
    );
  }

  AppThemeType get currentThemeType => _themeType;
  ThemeData get activeTheme => AppTheme.getTheme(_themeType);
  Locale get activeLocale => Locale(_languageCode);
  bool get isRTL => _languageCode == 'ar' || _languageCode == 'ur';

  String get themePreference => _themePreference;
  String get colorTheme => _colorTheme;
  String get languageCode => _languageCode;
  bool get showSeconds => _showSeconds;
  String get numberFormat => _numberFormat;
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;

  bool get isDarkMode => _themeType.isDark;

  ThemeMode get themeMode =>
      _themeType.isDark ? ThemeMode.dark : ThemeMode.light;

  void setAppThemeType(AppThemeType type) {
    _themeType = type;
    _themePreference = type.name;
    StorageService.setAppThemeType(type.name);
    StorageService.setThemePreference(type.name);
    StorageService.setDarkMode(type.isDark);
    notifyListeners();
  }

  void setThemePreference(String pref) {
    _themePreference = pref;
    StorageService.setThemePreference(pref);
    final matched = AppThemeType.values.firstWhere(
      (e) => e.name == pref,
      orElse: () => pref == 'dark' ? AppThemeType.theme3 : AppThemeType.theme1,
    );
    _themeType = matched;
    StorageService.setAppThemeType(matched.name);
    StorageService.setDarkMode(matched.isDark);
    notifyListeners();
  }

  void toggleTheme() {
    if (isDarkMode) {
      setAppThemeType(AppThemeType.theme1);
    } else {
      setAppThemeType(AppThemeType.theme3);
    }
  }

  void setColorTheme(String theme) {
    _colorTheme = theme;
    StorageService.setColorTheme(theme);
    notifyListeners();
  }

  void setLanguageCode(String code) {
    _languageCode = code;
    StorageService.setLanguageCode(code);
    notifyListeners();
  }

  void setShowSeconds(bool val) {
    _showSeconds = val;
    StorageService.setShowSecondsInPrayerTimes(val);
    notifyListeners();
  }

  void setNumberFormat(String format) {
    _numberFormat = format;
    StorageService.setNumberFormat(format);
    notifyListeners();
  }

  void setArabicFontSize(double size) {
    _arabicFontSize = size;
    StorageService.setArabicFontSize(size);
    notifyListeners();
  }

  void setTranslationFontSize(double size) {
    _translationFontSize = size;
    StorageService.setTranslationFontSize(size);
    notifyListeners();
  }
}
