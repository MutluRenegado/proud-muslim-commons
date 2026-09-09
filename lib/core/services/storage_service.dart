import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../models/prayer_time_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService not initialized.');
    }
    return _prefs!;
  }

  // User Profile
  static String get userName =>
      prefs.getString(AppConstants.keyUserName) ?? 'Servant of Allah';
  static Future<void> setUserName(String name) =>
      prefs.setString(AppConstants.keyUserName, name);

  static String get userEmail =>
      prefs.getString(AppConstants.keyUserEmail) ?? 'user@example.com';
  static Future<void> setUserEmail(String email) =>
      prefs.setString(AppConstants.keyUserEmail, email);

  static String get userAvatar =>
      prefs.getString(AppConstants.keyUserAvatar) ??
      'assets/images/default_avatar.png';
  static Future<void> setUserAvatar(String path) =>
      prefs.setString(AppConstants.keyUserAvatar, path);

  static String? get userProfilePhotoPath =>
      prefs.getString(AppConstants.keyUserProfilePhotoPath);
  static Future<void> setUserProfilePhotoPath(String? path) async {
    if (path == null) {
      await prefs.remove(AppConstants.keyUserProfilePhotoPath);
    } else {
      await prefs.setString(AppConstants.keyUserProfilePhotoPath, path);
    }
  }

  // Theme & Appearance
  static String get appThemeType =>
      prefs.getString(AppConstants.keyAppThemeType) ?? 'theme1';
  static Future<void> setAppThemeType(String type) =>
      prefs.setString(AppConstants.keyAppThemeType, type);

  static bool get isDarkMode =>
      prefs.getBool(AppConstants.keyThemeMode) ?? false;
  static Future<void> setDarkMode(bool val) =>
      prefs.setBool(AppConstants.keyThemeMode, val);

  static String get themePreference =>
      prefs.getString(AppConstants.keyThemePreference) ?? 'theme1';
  static Future<void> setThemePreference(String pref) =>
      prefs.setString(AppConstants.keyThemePreference, pref);

  static String get colorTheme =>
      prefs.getString(AppConstants.keyColorTheme) ?? 'emerald';
  static Future<void> setColorTheme(String theme) =>
      prefs.setString(AppConstants.keyColorTheme, theme);

  static String? get savedLanguageCode =>
      prefs.getString(AppConstants.keyLanguageCode);
  static String get languageCode =>
      prefs.getString(AppConstants.keyLanguageCode) ?? 'en';
  static Future<void> setLanguageCode(String code) =>
      prefs.setString(AppConstants.keyLanguageCode, code);

  static bool get showSecondsInPrayerTimes =>
      prefs.getBool(AppConstants.keyShowSecondsInPrayerTimes) ?? false;
  static Future<void> setShowSecondsInPrayerTimes(bool val) =>
      prefs.setBool(AppConstants.keyShowSecondsInPrayerTimes, val);

  static String get numberFormat =>
      prefs.getString(AppConstants.keyNumberFormat) ?? 'western';
  static Future<void> setNumberFormat(String format) =>
      prefs.setString(AppConstants.keyNumberFormat, format);

  // Location & Timezone
  static String get locationMode =>
      prefs.getString(AppConstants.keyLocationMode) ?? 'auto';
  static Future<void> setLocationMode(String mode) =>
      prefs.setString(AppConstants.keyLocationMode, mode);

  static double get latitude =>
      prefs.getDouble(AppConstants.keyLat) ?? AppConstants.defaultLat;
  static double get longitude =>
      prefs.getDouble(AppConstants.keyLng) ?? AppConstants.defaultLng;
  static double get elevation =>
      prefs.getDouble(AppConstants.keyElevation) ?? 0.0;
  static String get city =>
      prefs.getString(AppConstants.keyCity) ?? AppConstants.defaultCity;
  static String get country =>
      prefs.getString(AppConstants.keyCountry) ?? AppConstants.defaultCountry;
  static String get ianaTimeZone =>
      prefs.getString(AppConstants.keyIanaTimeZone) ??
      AppConstants.defaultIanaTimeZone;

  static Future<void> saveLocation(
    double lat,
    double lng,
    String city,
    String country, {
    String? ianaTimeZone,
    double? elevation,
  }) async {
    await prefs.setDouble(AppConstants.keyLat, lat);
    await prefs.setDouble(AppConstants.keyLng, lng);
    await prefs.setString(AppConstants.keyCity, city);
    await prefs.setString(AppConstants.keyCountry, country);
    if (ianaTimeZone != null && ianaTimeZone.isNotEmpty) {
      await prefs.setString(AppConstants.keyIanaTimeZone, ianaTimeZone);
    }
    if (elevation != null) {
      await prefs.setDouble(AppConstants.keyElevation, elevation);
    }
  }

  static String get homeCity =>
      prefs.getString(AppConstants.keyHomeCity) ?? AppConstants.defaultCity;
  static String get homeCountry =>
      prefs.getString(AppConstants.keyHomeCountry) ??
      AppConstants.defaultCountry;
  static double get homeLat =>
      prefs.getDouble(AppConstants.keyHomeLat) ?? AppConstants.defaultLat;
  static double get homeLng =>
      prefs.getDouble(AppConstants.keyHomeLng) ?? AppConstants.defaultLng;
  static String get homeIanaTimeZone =>
      prefs.getString(AppConstants.keyHomeIanaTimeZone) ??
      AppConstants.defaultIanaTimeZone;

  static Future<void> saveHomeLocation(
    double lat,
    double lng,
    String city,
    String country, {
    String? ianaTimeZone,
  }) async {
    await prefs.setDouble(AppConstants.keyHomeLat, lat);
    await prefs.setDouble(AppConstants.keyHomeLng, lng);
    await prefs.setString(AppConstants.keyHomeCity, city);
    await prefs.setString(AppConstants.keyHomeCountry, country);
    if (ianaTimeZone != null && ianaTimeZone.isNotEmpty) {
      await prefs.setString(AppConstants.keyHomeIanaTimeZone, ianaTimeZone);
    }
  }

  // Prayer & Calculation
  static String get calculationMethodName =>
      prefs.getString(AppConstants.keyCalcMethod) ??
      AppConstants.defaultCalcMethod;
  static Future<void> setCalculationMethodName(String name) =>
      prefs.setString(AppConstants.keyCalcMethod, name);

  static String get juristicMethodName =>
      prefs.getString(AppConstants.keyJuristicMethod) ?? 'standard';
  static Future<void> setJuristicMethodName(String name) =>
      prefs.setString(AppConstants.keyJuristicMethod, name);

  static String get highLatitudeRule =>
      prefs.getString(AppConstants.keyHighLatitudeRule) ?? 'none';
  static Future<void> setHighLatitudeRule(String rule) =>
      prefs.setString(AppConstants.keyHighLatitudeRule, rule);

  static String get roundingMethod =>
      prefs.getString(AppConstants.keyRoundingMethod) ?? 'nearestMinute';
  static Future<void> setRoundingMethod(String method) =>
      prefs.setString(AppConstants.keyRoundingMethod, method);

  // Offline 30-Day Prayer Schedule Cache
  static List<PrayerTimesModel>? getOfflinePrayerSchedule() {
    final raw = prefs.getString(AppConstants.keyOfflinePrayerSchedule);
    if (raw == null || raw.isEmpty) return null;
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
              (item) => PrayerTimesModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveOfflinePrayerSchedule(
      List<PrayerTimesModel> schedule) async {
    final encoded = jsonEncode(schedule.map((item) => item.toJson()).toList());
    await prefs.setString(AppConstants.keyOfflinePrayerSchedule, encoded);
  }

  // Azan & Notifications
  static bool get azanEnabled =>
      prefs.getBool(AppConstants.keyAzanEnabled) ?? true;
  static Future<void> setAzanEnabled(bool val) =>
      prefs.setBool(AppConstants.keyAzanEnabled, val);

  static String get azanSound =>
      prefs.getString(AppConstants.keyAzanSound) ?? 'Makkah Azan';
  static Future<void> setAzanSound(String sound) =>
      prefs.setString(AppConstants.keyAzanSound, sound);

  static double get azanVolume =>
      prefs.getDouble(AppConstants.keyAzanVolume) ?? 0.8;
  static Future<void> setAzanVolume(double volume) =>
      prefs.setDouble(AppConstants.keyAzanVolume, volume);

  static bool get azanNotificationsEnabled =>
      prefs.getBool(AppConstants.keyAzanNotificationsEnabled) ?? true;
  static Future<void> setAzanNotificationsEnabled(bool val) =>
      prefs.setBool(AppConstants.keyAzanNotificationsEnabled, val);

  static bool get vibrateOnAzan =>
      prefs.getBool(AppConstants.keyVibrateOnAzan) ?? true;
  static Future<void> setVibrateOnAzan(bool val) =>
      prefs.setBool(AppConstants.keyVibrateOnAzan, val);

  static bool get silentModeDnd =>
      prefs.getBool(AppConstants.keySilentModeDnd) ?? false;
  static Future<void> setSilentModeDnd(bool val) =>
      prefs.setBool(AppConstants.keySilentModeDnd, val);

  static int get reminderBeforeAzanMinutes =>
      prefs.getInt(AppConstants.keyReminderBeforeAzanMinutes) ?? 15;
  static Future<void> setReminderBeforeAzanMinutes(int min) =>
      prefs.setInt(AppConstants.keyReminderBeforeAzanMinutes, min);

  static int get iqamahReminderMinutes =>
      prefs.getInt(AppConstants.keyIqamahReminderMinutes) ?? 20;
  static Future<void> setIqamahReminderMinutes(int min) =>
      prefs.setInt(AppConstants.keyIqamahReminderMinutes, min);

  static bool get showNotifications =>
      prefs.getBool(AppConstants.keyShowNotifications) ?? true;
  static Future<void> setShowNotifications(bool val) =>
      prefs.setBool(AppConstants.keyShowNotifications, val);

  static Map<String, bool> getPrayerNotificationToggles() {
    final defaults = <String, bool>{
      'fajr': true,
      'sunrise': false,
      'dhuhr': true,
      'asr': true,
      'maghrib': true,
      'isha': true,
    };
    final raw = prefs.getString(AppConstants.keyPrayerNotificationToggles);
    if (raw == null) return defaults;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        defaults[entry.key.toLowerCase()] = entry.value as bool;
      }
      return defaults;
    } catch (_) {
      return defaults;
    }
  }

  static Future<void> savePrayerNotificationToggles(
    Map<String, bool> toggles,
  ) async {
    final normalized = <String, bool>{
      for (final entry in toggles.entries) entry.key.toLowerCase(): entry.value,
    };
    await prefs.setString(
      AppConstants.keyPrayerNotificationToggles,
      jsonEncode(normalized),
    );
  }

  static const Map<String, String> defaultPrayerAdhanAssets = {
    'fajr': 'assets/audio/adhan/fajr/fajr_adhan.mp3',
    'dhuhr': 'assets/audio/adhan/dhuhr/dhuhr_edhan.mp3',
    'asr':
        'assets/audio/adhan/asr/AsrAzanFromMakkah (audio-extractor.net) (1).mp3',
    'maghrib': 'assets/audio/adhan/maghrip/magrib_edhan.mp3',
    'isha': 'assets/audio/adhan/Isha/isha_edhan.mp3',
  };

  static Map<String, String> getPrayerAdhanSelections() {
    final values = Map<String, String>.from(defaultPrayerAdhanAssets);
    final raw = prefs.getString(AppConstants.keyPrayerAdhanSelections);
    if (raw == null) return values;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        values[entry.key.toLowerCase()] = entry.value as String;
      }
    } catch (_) {}
    return values;
  }

  static Future<void> savePrayerAdhanSelections(Map<String, String> values) =>
      prefs.setString(
          AppConstants.keyPrayerAdhanSelections, jsonEncode(values));

  static Map<String, bool> getPrayerAdhanToggles() {
    final values = <String, bool>{
      'fajr': true,
      'dhuhr': true,
      'asr': true,
      'maghrib': true,
      'isha': true,
    };
    final raw = prefs.getString(AppConstants.keyPrayerAdhanToggles);
    if (raw == null) return values;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        values[entry.key.toLowerCase()] = entry.value as bool;
      }
    } catch (_) {}
    return values;
  }

  static Future<void> savePrayerAdhanToggles(Map<String, bool> values) =>
      prefs.setString(AppConstants.keyPrayerAdhanToggles, jsonEncode(values));

  // App Features & Reminders
  static bool get dailyRemindersEnabled =>
      prefs.getBool(AppConstants.keyDailyRemindersEnabled) ?? true;
  static Future<void> setDailyRemindersEnabled(bool val) =>
      prefs.setBool(AppConstants.keyDailyRemindersEnabled, val);

  static bool get dailyHadithEnabled =>
      prefs.getBool(AppConstants.keyDailyHadithEnabled) ?? true;
  static Future<void> setDailyHadithEnabled(bool val) =>
      prefs.setBool(AppConstants.keyDailyHadithEnabled, val);

  static bool get dailyAyahEnabled =>
      prefs.getBool(AppConstants.keyDailyAyahEnabled) ?? true;
  static Future<void> setDailyAyahEnabled(bool val) =>
      prefs.setBool(AppConstants.keyDailyAyahEnabled, val);

  static bool get sunnahFastingReminderEnabled =>
      prefs.getBool(AppConstants.keySunnahFastingReminderEnabled) ?? false;
  static Future<void> setSunnahFastingReminderEnabled(bool val) =>
      prefs.setBool(AppConstants.keySunnahFastingReminderEnabled, val);

  static bool get jumuahSurahKahfReminderEnabled =>
      prefs.getBool(AppConstants.keyJumuahSurahKahfReminderEnabled) ?? true;
  static Future<void> setJumuahSurahKahfReminderEnabled(bool val) =>
      prefs.setBool(AppConstants.keyJumuahSurahKahfReminderEnabled, val);

  // Digital Tasbih
  static int getDhikrCount(String dhikrId) => prefs.getInt('dhikr_count_') ?? 0;
  static Future<void> setDhikrCount(String dhikrId, int count) =>
      prefs.setInt('dhikr_count_', count);

  // Bookmarks
  static List<String> getBookmarks() =>
      prefs.getStringList(AppConstants.keyBookmarks) ?? [];
  static Future<void> setBookmarks(List<String> list) =>
      prefs.setStringList(AppConstants.keyBookmarks, list);

  // Last Read Quran
  static int get lastReadSurah =>
      prefs.getInt(AppConstants.keyLastReadSurah) ?? 1;
  static int get lastReadAyah =>
      prefs.getInt(AppConstants.keyLastReadAyah) ?? 1;
  static Future<void> saveLastRead(int surah, int ayah) async {
    await prefs.setInt(AppConstants.keyLastReadSurah, surah);
    await prefs.setInt(AppConstants.keyLastReadAyah, ayah);
  }

  // Hijri Offset
  static int get hijriOffset => prefs.getInt(AppConstants.keyHijriOffset) ?? 0;
  static Future<void> setHijriOffset(int offset) =>
      prefs.setInt(AppConstants.keyHijriOffset, offset);

  // Font Sizes
  static double get arabicFontSize =>
      prefs.getDouble(AppConstants.keyFontSizeArabic) ?? 24.0;
  static Future<void> setArabicFontSize(double size) =>
      prefs.setDouble(AppConstants.keyFontSizeArabic, size);

  static double get translationFontSize =>
      prefs.getDouble(AppConstants.keyFontSizeTranslation) ?? 16.0;
  static Future<void> setTranslationFontSize(double size) =>
      prefs.setDouble(AppConstants.keyFontSizeTranslation, size);

  // Prayer Offsets
  static Map<String, int> getPrayerOffsets() {
    final raw = prefs.getString(AppConstants.keyPrayerOffsets);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  static Future<void> savePrayerOffsets(Map<String, int> offsets) async {
    await prefs.setString(AppConstants.keyPrayerOffsets, jsonEncode(offsets));
  }

  // Quran Translation System
  static String get quranTranslationLanguage {
    final saved = prefs.getString(AppConstants.keyQuranTranslationLanguage);
    if (saved != null && saved.isNotEmpty) return saved;
    return languageCode == 'tr' ? 'tr' : 'en';
  }

  static Future<void> setQuranTranslationLanguage(String langCode) =>
      prefs.setString(AppConstants.keyQuranTranslationLanguage, langCode);

  static String get quranTranslationEditionId {
    final saved = prefs.getString(AppConstants.keyQuranTranslationEditionId);
    if (saved != null && saved.isNotEmpty && saved != 'tur-alibulac') {
      return saved;
    }
    final lang = quranTranslationLanguage;
    if (lang == 'tr') return 'tur-diyanetisleri';
    return 'eng-mustafakhattaba';
  }

  static Future<void> setQuranTranslationEditionId(String editionId) =>
      prefs.setString(AppConstants.keyQuranTranslationEditionId, editionId);

  static bool get quranShowTranslation =>
      prefs.getBool(AppConstants.keyQuranShowTranslation) ?? true;

  static Future<void> setQuranShowTranslation(bool show) =>
      prefs.setBool(AppConstants.keyQuranShowTranslation, show);

  static String get ttsVoiceGender =>
      prefs.getString(AppConstants.keyTtsVoiceGender) ?? 'male';

  static Future<void> setTtsVoiceGender(String gender) =>
      prefs.setString(AppConstants.keyTtsVoiceGender, gender);

  // Subscriptions & Entitlements (Proud Muslim Ad-Free)
  static bool isPermanentAdFreeEmail(String? email) {
    if (email == null) return false;
    final normalized = email.trim().toLowerCase();
    return AppConstants.permanentProEmails.contains(normalized);
  }

  static bool isViewerAccountEmail(String? email) {
    if (email == null) return false;
    final normalized = email.trim().toLowerCase();
    return AppConstants.testViewerEmails.contains(normalized);
  }

  static bool get isViewerAccount => isViewerAccountEmail(userEmail);

  static bool isPermanentProEmail(String? email) => isPermanentAdFreeEmail(email);

  static bool get isPermanentAdFreeAccount =>
      isPermanentAdFreeEmail(userEmail);

  static bool get isPermanentProAccount => isPermanentAdFreeAccount;

  static bool get isPaidSubscribed =>
      prefs.getBool('is_subscribed') ?? false;

  static Future<void> setIsSubscribed(bool val) =>
      prefs.setBool('is_subscribed', val);

  static bool get hasAdFreeAccess =>
      isPermanentAdFreeAccount || isPaidSubscribed;

  static bool get isSubscribed => hasAdFreeAccess;

  static String get subscriptionStatus =>
      hasAdFreeAccess
          ? 'activeAdFree'
          : (prefs.getString('subscription_status') ?? 'free');

  static Future<void> setSubscriptionStatus(String status) =>
      prefs.setString('subscription_status', status);

  static Future<void> logout() async {
    await prefs.remove(AppConstants.keyUserName);
    await prefs.remove(AppConstants.keyUserEmail);
    await prefs.remove(AppConstants.keyUserAvatar);
    await prefs.remove(AppConstants.keyUserProfilePhotoPath);
  }

  static Future<void> setTrialDates(DateTime start, DateTime end) async {
    await prefs.setString('trial_start_date', start.toIso8601String());
    await prefs.setString('trial_end_date', end.toIso8601String());
  }

  // Bookmarks helper
  static bool isBookmarked(int surah, int ayah) {
    final bookmarks = getBookmarks();
    return bookmarks.contains('$surah:$ayah');
  }

  static Future<void> toggleBookmark(int surah, int ayah) async {
    final bookmarks = getBookmarks().toList();
    final key = '$surah:$ayah';
    if (bookmarks.contains(key)) {
      bookmarks.remove(key);
    } else {
      bookmarks.add(key);
    }
    await setBookmarks(bookmarks);
  }

  // Feature reminder aliases
  static bool get azkarRemindersEnabled =>
      prefs.getBool('azkar_reminders') ?? true;
  static Future<void> setAzkarRemindersEnabled(bool val) =>
      prefs.setBool('azkar_reminders', val);

  static bool get dailyAyahReminder => dailyAyahEnabled;
  static Future<void> setDailyAyahReminder(bool val) =>
      setDailyAyahEnabled(val);

  static bool get dailyHadithReminder => dailyHadithEnabled;
  static Future<void> setDailyHadithReminder(bool val) =>
      setDailyHadithEnabled(val);

  static DateTime? get trialStartDate {
    final str = prefs.getString('trial_start_date');
    return str != null ? DateTime.tryParse(str) : null;
  }

  static DateTime? get trialEndDate {
    final str = prefs.getString('trial_end_date');
    return str != null ? DateTime.tryParse(str) : null;
  }
}
