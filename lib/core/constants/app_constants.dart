class AppConstants {
  static const String appName = 'Proud Muslim';
  static const String appTagline = 'Your daily spiritual companion';
  static const String appVersion = '1.0.4';
  static const String appBuildNumber = '5';
  static const String communityName = 'Proud Muslim Global Ummah';
  static const String supportEmail = 'support@proudmuslim.app';
  static const String privacyPolicyUrl =
      'https://anm-digital.github.io/proud-muslim-legal/privacy-terms.html';
  static const String termsOfUseUrl =
      'https://anm-digital.github.io/proud-muslim-legal/privacy-terms.html';
  static const String licensesUrl =
      'https://anm-digital.github.io/proud-muslim-legal/licenses.html';

  // Permanent Free Ad-Free Accounts
  static const Set<String> permanentProEmails = {
    'akgnmutlu@gmail.com',
    'testingisamust32@gmail.com',
  };
  static const Set<String> permanentAdFreeEmails = permanentProEmails;

  // Subscriptions & Plans (Ad-Free Annual Subscription)
  static const String subscriptionProductId = 'proud_muslim_ad_free_annual';
  static const String basePlanIdAnnual = 'yearly-auto-renewing';
  static const String offerIdIntroUsaEurope = 'intro-first-year-tier1';
  static const String offerIdIntroRow = 'intro-first-year-tier2';
  static const String productIdAnnualAdFree = 'proud_muslim_ad_free_annual';
  static const String legacyProductIdPremium = 'proud_muslim_premium';

  // Regular Annual Pricing (12-Month Billing Period: US$12.59/year)
  static const double priceAnnualRegularUsd = 12.59;
  static const double priceAnnualRegularEur = 12.59;
  static const double priceAnnualRegularTry = 399.99;
  static const String formattedPriceAnnualRegularUsd = '\$12.59/year';
  static const String formattedPriceAnnualRegularEur = '€12.59/year';
  static const String formattedPriceAnnualRegularTry = '₺399.99/year';

  // First-Year Introductory Pricing Tiers (First 12 Months)
  // USA & Europe: US$4.59 target equivalent
  static const double priceIntroUsaEuropeUsd = 4.59;
  static const double priceIntroEuropeEur = 4.59;
  static const String formattedPriceIntroUsa = '\$4.59';
  static const String formattedPriceIntroEurope = '€4.59';

  // Rest of World: US$2.59 target equivalent
  static const double priceIntroRowUsd = 2.59;
  static const String formattedPriceIntroRow = '\$2.59';

  // Turkey Introductory (Local currency equivalent)
  static const double priceIntroTurkeyTry = 149.99;
  static const String formattedPriceIntroTurkey = '₺149.99';

  // Defaults
  static const double defaultLat = 41.0082; // Istanbul default
  static const double defaultLng = 28.9784;
  static const String defaultCity = 'Istanbul';
  static const String defaultCountry = 'Turkey';
  static const String defaultIanaTimeZone = 'Europe/Istanbul';
  static const String defaultCalcMethod = 'turkeyDiyanet';

  // Storage Keys
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserAvatar = 'user_avatar';
  static const String keyUserProfilePhotoPath = 'user_profile_photo_path';
  static const String keyAppThemeType = 'app_theme_type';
  static const String keyThemeMode = 'theme_mode';
  static const String keyThemePreference = 'theme_preference';
  static const String keyColorTheme = 'color_theme';
  static const String keyLanguageCode = 'language_code';
  static const String keyShowSecondsInPrayerTimes =
      'show_seconds_in_prayer_times';
  static const String keyNumberFormat = 'number_format';
  static const String keyLocationMode = 'location_mode';
  static const String keyLat = 'latitude';
  static const String keyLng = 'longitude';
  static const String keyElevation = 'elevation';
  static const String keyCity = 'city';
  static const String keyCountry = 'country';
  static const String keyIanaTimeZone = 'iana_time_zone';
  static const String keyHomeCity = 'home_city';
  static const String keyHomeCountry = 'home_country';
  static const String keyHomeLat = 'home_latitude';
  static const String keyHomeLng = 'home_longitude';
  static const String keyHomeIanaTimeZone = 'home_iana_time_zone';
  static const String keyCalcMethod = 'calc_method';
  static const String keyJuristicMethod = 'juristic_method';
  static const String keyHighLatitudeRule = 'high_latitude_rule';
  static const String keyRoundingMethod = 'rounding_method';
  static const String keyOfflinePrayerSchedule = 'offline_prayer_schedule_json';
  static const String keyAzanEnabled = 'azan_enabled';
  static const String keyAzanSound = 'azan_sound';
  static const String keyAzanVolume = 'azan_volume';
  static const String keyAzanNotificationsEnabled =
      'azan_notifications_enabled';
  static const String keyVibrateOnAzan = 'vibrate_on_azan';
  static const String keySilentModeDnd = 'silent_mode_dnd';
  static const String keyReminderBeforeAzanMinutes =
      'reminder_before_azan_minutes';
  static const String keyIqamahReminderMinutes = 'iqamah_reminder_minutes';
  static const String keyShowNotifications = 'show_notifications';
  static const String keyPrayerNotificationToggles =
      'prayer_notification_toggles';
  static const String keyPrayerAdhanSelections = 'prayer_adhan_selections';
  static const String keyTtsVoiceGender = 'tts_voice_gender';
  static const String keyPrayerAdhanToggles = 'prayer_adhan_toggles';
  static const String keyDailyRemindersEnabled = 'daily_reminders_enabled';
  static const String keyDailyHadithEnabled = 'daily_hadith_enabled';
  static const String keyDailyAyahEnabled = 'daily_ayah_enabled';
  static const String keySunnahFastingReminderEnabled =
      'sunnah_fasting_reminder_enabled';
  static const String keyJumuahSurahKahfReminderEnabled =
      'jumuah_surah_kahf_reminder_enabled';
  static const String keyBookmarks = 'bookmarks';
  static const String keyLastReadSurah = 'last_read_surah';
  static const String keyLastReadAyah = 'last_read_ayah';
  static const String keyHijriOffset = 'hijri_offset';
  static const String keyFontSizeArabic = 'font_size_arabic';
  static const String keyFontSizeTranslation = 'font_size_translation';
  static const String keyPrayerOffsets = 'prayer_offsets';
  static const String keyQuranTranslationLanguage =
      'quran_translation_language';
  static const String keyQuranTranslationEditionId =
      'quran_translation_edition_id';
  static const String keyQuranShowTranslation = 'quran_show_translation';

  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;
}
