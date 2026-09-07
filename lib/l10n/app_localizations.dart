import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ms'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('ur')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Proud Muslim'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// No description provided for @navQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get navQibla;

  /// No description provided for @navAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get navAzkar;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get gotIt;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @exploreDeen.
  ///
  /// In en, this message translates to:
  /// **'Explore Proud Muslim'**
  String get exploreDeen;

  /// No description provided for @todayPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayers'**
  String get todayPrayers;

  /// No description provided for @fullTimetable.
  ///
  /// In en, this message translates to:
  /// **'Full Timetable'**
  String get fullTimetable;

  /// No description provided for @dailyHadithGem.
  ///
  /// In en, this message translates to:
  /// **'Daily Hadith Gem'**
  String get dailyHadithGem;

  /// No description provided for @ayahOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Ayah of the Day'**
  String get ayahOfTheDay;

  /// No description provided for @countdownTo.
  ///
  /// In en, this message translates to:
  /// **'Countdown to next prayer'**
  String get countdownTo;

  /// No description provided for @inTime.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get inTime;

  /// No description provided for @holyQuran.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get holyQuran;

  /// No description provided for @qiblaFinder.
  ///
  /// In en, this message translates to:
  /// **'Qibla Finder'**
  String get qiblaFinder;

  /// No description provided for @dailyAzkar.
  ///
  /// In en, this message translates to:
  /// **'Daily Azkar'**
  String get dailyAzkar;

  /// No description provided for @digitalTasbih.
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih'**
  String get digitalTasbih;

  /// No description provided for @hadith40.
  ///
  /// In en, this message translates to:
  /// **'Hadith 40'**
  String get hadith40;

  /// No description provided for @hijriCalendar.
  ///
  /// In en, this message translates to:
  /// **'Hijri Calendar'**
  String get hijriCalendar;

  /// No description provided for @zakatCalculator.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatCalculator;

  /// No description provided for @salahAnd99Names.
  ///
  /// In en, this message translates to:
  /// **'Salah & 99 Names'**
  String get salahAnd99Names;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @prayerTimesAndSchedule.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times & Schedule'**
  String get prayerTimesAndSchedule;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// No description provided for @monthlyTimetable.
  ///
  /// In en, this message translates to:
  /// **'Monthly Timetable'**
  String get monthlyTimetable;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @qiyam.
  ///
  /// In en, this message translates to:
  /// **'Qiyam (Tahajjud)'**
  String get qiyam;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethod;

  /// No description provided for @juristicSchool.
  ///
  /// In en, this message translates to:
  /// **'Juristic School (Asr)'**
  String get juristicSchool;

  /// No description provided for @qiblaCompass.
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get qiblaCompass;

  /// No description provided for @distanceToKaaba.
  ///
  /// In en, this message translates to:
  /// **'km to Holy Kaaba (Makkah)'**
  String get distanceToKaaba;

  /// No description provided for @qiblaBearing.
  ///
  /// In en, this message translates to:
  /// **'QIBLA BEARING'**
  String get qiblaBearing;

  /// No description provided for @phoneHeading.
  ///
  /// In en, this message translates to:
  /// **'PHONE HEADING'**
  String get phoneHeading;

  /// No description provided for @trueNorthAngle.
  ///
  /// In en, this message translates to:
  /// **'True North Angle'**
  String get trueNorthAngle;

  /// No description provided for @alignedWithKaaba.
  ///
  /// In en, this message translates to:
  /// **'✓ ALIGNED WITH HOLY KAABA'**
  String get alignedWithKaaba;

  /// No description provided for @sensorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Compass Sensor Not Available'**
  String get sensorNotAvailable;

  /// No description provided for @sensorNotAvailableDesc.
  ///
  /// In en, this message translates to:
  /// **'This device does not have a physical magnetometer/compass sensor. Your true Qibla direction is clockwise from geographic North.'**
  String get sensorNotAvailableDesc;

  /// No description provided for @compassAccuracyLow.
  ///
  /// In en, this message translates to:
  /// **'Compass accuracy is low. Move your phone in a figure-eight (∞) motion to calibrate.'**
  String get compassAccuracyLow;

  /// No description provided for @magneticInterferenceNotice.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat horizontally. Magnetic cases, metal surfaces, and nearby electronics can affect magnetic sensor accuracy.'**
  String get magneticInterferenceNotice;

  /// No description provided for @searchSurahHint.
  ///
  /// In en, this message translates to:
  /// **'Search Surah by name or number...'**
  String get searchSurahHint;

  /// No description provided for @adjustTypography.
  ///
  /// In en, this message translates to:
  /// **'Adjust Typography'**
  String get adjustTypography;

  /// No description provided for @arabicFontSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic Font Size'**
  String get arabicFontSize;

  /// No description provided for @translationFontSize.
  ///
  /// In en, this message translates to:
  /// **'Translation Font Size'**
  String get translationFontSize;

  /// No description provided for @versesCount.
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get versesCount;

  /// No description provided for @toggleVibration.
  ///
  /// In en, this message translates to:
  /// **'Toggle Vibration'**
  String get toggleVibration;

  /// No description provided for @resetCounter.
  ///
  /// In en, this message translates to:
  /// **'Reset Count'**
  String get resetCounter;

  /// No description provided for @resetCounterConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the current dhikr count back to zero?'**
  String get resetCounterConfirm;

  /// No description provided for @completedLaps.
  ///
  /// In en, this message translates to:
  /// **'Completed Sets (Laps)'**
  String get completedLaps;

  /// No description provided for @tasbihInstruction.
  ///
  /// In en, this message translates to:
  /// **'Tap the circular counter to perform dhikr. You will feel a haptic pulse on each count and set completion.'**
  String get tasbihInstruction;

  /// No description provided for @imamNawawi40Hadith.
  ///
  /// In en, this message translates to:
  /// **'Imam Nawawi\'s 40 Hadith'**
  String get imamNawawi40Hadith;

  /// No description provided for @searchHadithHint.
  ///
  /// In en, this message translates to:
  /// **'Search hadith by keyword, narrator...'**
  String get searchHadithHint;

  /// No description provided for @narrator.
  ///
  /// In en, this message translates to:
  /// **'Narrator'**
  String get narrator;

  /// No description provided for @benefit.
  ///
  /// In en, this message translates to:
  /// **'Benefit'**
  String get benefit;

  /// No description provided for @islamicHijriCalendar.
  ///
  /// In en, this message translates to:
  /// **'Islamic Hijri Calendar'**
  String get islamicHijriCalendar;

  /// No description provided for @sunnahFastingOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Sunnah Fasting Opportunities'**
  String get sunnahFastingOpportunities;

  /// No description provided for @whiteDaysDesc.
  ///
  /// In en, this message translates to:
  /// **'White Days (Ayyam al-Bidh): 13th, 14th, 15th of every Lunar Month'**
  String get whiteDaysDesc;

  /// No description provided for @weeklySunnahFastsDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly Sunnah Fasts: Every Monday & Thursday'**
  String get weeklySunnahFastsDesc;

  /// No description provided for @keyIslamicEvents.
  ///
  /// In en, this message translates to:
  /// **'Key Islamic Events & Holidays'**
  String get keyIslamicEvents;

  /// No description provided for @zakatCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator (حاسبة الزكاة)'**
  String get zakatCalculatorTitle;

  /// No description provided for @totalZakatPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Zakat Payable (2.5%):'**
  String get totalZakatPayable;

  /// No description provided for @nisabMet.
  ///
  /// In en, this message translates to:
  /// **'Nisab Met'**
  String get nisabMet;

  /// No description provided for @belowNisab.
  ///
  /// In en, this message translates to:
  /// **'Below Nisab'**
  String get belowNisab;

  /// No description provided for @netZakatableWealth.
  ///
  /// In en, this message translates to:
  /// **'Net Zakatable Wealth'**
  String get netZakatableWealth;

  /// No description provided for @goldNisabThreshold.
  ///
  /// In en, this message translates to:
  /// **'Gold Nisab Threshold (87.48g)'**
  String get goldNisabThreshold;

  /// No description provided for @assetsEligibleForZakat.
  ///
  /// In en, this message translates to:
  /// **'Assets Eligible for Zakat'**
  String get assetsEligibleForZakat;

  /// No description provided for @cashInHandBank.
  ///
  /// In en, this message translates to:
  /// **'Cash in Hand & Bank Accounts (\$)'**
  String get cashInHandBank;

  /// No description provided for @goldWeightGrams.
  ///
  /// In en, this message translates to:
  /// **'Gold Weight (Grams)'**
  String get goldWeightGrams;

  /// No description provided for @silverWeightGrams.
  ///
  /// In en, this message translates to:
  /// **'Silver Weight (Grams)'**
  String get silverWeightGrams;

  /// No description provided for @stocksInvestments.
  ///
  /// In en, this message translates to:
  /// **'Stocks, Mutual Funds & Crypto (\$)'**
  String get stocksInvestments;

  /// No description provided for @businessInventory.
  ///
  /// In en, this message translates to:
  /// **'Business Inventory & Trading Goods (\$)'**
  String get businessInventory;

  /// No description provided for @liabilitiesImmediateDebts.
  ///
  /// In en, this message translates to:
  /// **'Liabilities & Immediate Deductions'**
  String get liabilitiesImmediateDebts;

  /// No description provided for @immediateDebtsBills.
  ///
  /// In en, this message translates to:
  /// **'Immediate Debts & Unpaid Bills (\$)'**
  String get immediateDebtsBills;

  /// No description provided for @zakatNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Zakat is an obligatory pillar of Islam payable at 2.5% on wealth that has met or exceeded the Nisab threshold and remained in your possession for a full lunar year (Hawl).'**
  String get zakatNote;

  /// No description provided for @profileAndSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileAndSettings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @prayerAndTimetable.
  ///
  /// In en, this message translates to:
  /// **'PRAYER & TIMETABLE'**
  String get prayerAndTimetable;

  /// No description provided for @prayerAzanSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Azan Settings'**
  String get prayerAzanSettings;

  /// No description provided for @calculationJuristicMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation & Juristic Method'**
  String get calculationJuristicMethod;

  /// No description provided for @locationAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Location & Privacy'**
  String get locationAndPrivacy;

  /// No description provided for @customizationFeatures.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMIZATION & FEATURES'**
  String get customizationFeatures;

  /// No description provided for @appearanceAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Language'**
  String get appearanceAndLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @displayLanguage.
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get displayLanguage;

  /// No description provided for @appFeaturesReminders.
  ///
  /// In en, this message translates to:
  /// **'App Features & Reminders'**
  String get appFeaturesReminders;

  /// No description provided for @subscriptionAndBilling.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Billing'**
  String get subscriptionAndBilling;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY'**
  String get community;

  /// No description provided for @communityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Community features coming soon'**
  String get communityComingSoon;

  /// No description provided for @supportAndLegal.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & LEGAL'**
  String get supportAndLegal;

  /// No description provided for @helpFaqSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ / Support'**
  String get helpFaqSupport;

  /// No description provided for @legalAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Legal & About'**
  String get legalAndAbout;

  /// No description provided for @freeTrial.
  ///
  /// In en, this message translates to:
  /// **'3-Day Free Trial'**
  String get freeTrial;

  /// No description provided for @monthlyPremiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Premium Plan'**
  String get monthlyPremiumPlan;

  /// No description provided for @unlockPremiumAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Access'**
  String get unlockPremiumAccess;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @start3DayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 3-Day Free Trial'**
  String get start3DayFreeTrial;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore In-App Purchases'**
  String get restorePurchases;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccess;

  /// No description provided for @enableLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location for Accurate Prayer Times'**
  String get enableLocationTitle;

  /// No description provided for @locationPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'We only access your device location to provide accurate prayer times and location-based features. Your personal data remains private. You can safely enable location services.'**
  String get locationPrivacyNotice;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Using manual location.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. You can enable it from system App Settings or select a city manually.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @enableAzanAudio.
  ///
  /// In en, this message translates to:
  /// **'Enable Azan Audio'**
  String get enableAzanAudio;

  /// No description provided for @enableAzanAudioDesc.
  ///
  /// In en, this message translates to:
  /// **'Play authentic Adhan call at prayer times'**
  String get enableAzanAudioDesc;

  /// No description provided for @azanSoundMuezzin.
  ///
  /// In en, this message translates to:
  /// **'Azan Sound / Muezzin'**
  String get azanSoundMuezzin;

  /// No description provided for @azanVolume.
  ///
  /// In en, this message translates to:
  /// **'Azan Volume'**
  String get azanVolume;

  /// No description provided for @vibrateOnAzan.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on Azan'**
  String get vibrateOnAzan;

  /// No description provided for @reminderBeforeAzan.
  ///
  /// In en, this message translates to:
  /// **'Reminder Before Azan'**
  String get reminderBeforeAzan;

  /// No description provided for @iqamahReminder.
  ///
  /// In en, this message translates to:
  /// **'Iqamah Reminder'**
  String get iqamahReminder;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'FREQUENTLY ASKED QUESTIONS (FAQ)'**
  String get frequentlyAskedQuestions;

  /// No description provided for @quranForeverFree.
  ///
  /// In en, this message translates to:
  /// **'Quran in any language is forever free.'**
  String get quranForeverFree;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully.'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile photo removed.'**
  String get profilePhotoRemoved;

  /// No description provided for @arabicPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Arabic Pronunciation'**
  String get arabicPronunciation;

  /// No description provided for @turkishPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Turkish Pronunciation'**
  String get turkishPronunciation;

  /// No description provided for @listenArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic Pronunciation'**
  String get listenArabic;

  /// No description provided for @listenTurkish.
  ///
  /// In en, this message translates to:
  /// **'Listen (Turkish)'**
  String get listenTurkish;

  /// No description provided for @stopAudio.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopAudio;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @audioError.
  ///
  /// In en, this message translates to:
  /// **'Audio could not be loaded. Please check your connection.'**
  String get audioError;

  /// No description provided for @namesOfAllah.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get namesOfAllah;

  /// No description provided for @namesOfAllahDesc.
  ///
  /// In en, this message translates to:
  /// **'The Most Beautiful Names of Allah (Asmaul Husna) with authentic meanings and audio pronunciation.'**
  String get namesOfAllahDesc;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @helpPrayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times & Calculations'**
  String get helpPrayerTimesTitle;

  /// No description provided for @helpPrayerTimesDesc.
  ///
  /// In en, this message translates to:
  /// **'Prayer times are calculated based on your precise geographical coordinates using astronomical solar formulas and your selected calculation authority.'**
  String get helpPrayerTimesDesc;

  /// No description provided for @helpQiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction & Compass'**
  String get helpQiblaTitle;

  /// No description provided for @helpQiblaDesc.
  ///
  /// In en, this message translates to:
  /// **'The Qibla compass uses your phone\'s built-in magnetometer sensor to point directly towards the Holy Kaaba in Makkah. Keep your device flat and away from magnetic objects for maximum precision.'**
  String get helpQiblaDesc;

  /// No description provided for @helpQuranTranslationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Multilingual Quran Translations'**
  String get helpQuranTranslationsTitle;

  /// No description provided for @helpQuranTranslationsDesc.
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran\'s original Arabic text is canonical and protected. Translations are scholarly human interpretations in 14 world languages. Quran reading in every language is forever free.'**
  String get helpQuranTranslationsDesc;

  /// No description provided for @helpEzanTitle.
  ///
  /// In en, this message translates to:
  /// **'Adhan (Ezan) Notifications'**
  String get helpEzanTitle;

  /// No description provided for @helpEzanDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen to authentic calls to prayer from Makkah, Madinah, and Al-Aqsa, and preview each Muezzin directly from the settings.'**
  String get helpEzanDesc;

  /// No description provided for @helpTasbihTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih (Dhikr)'**
  String get helpTasbihTitle;

  /// No description provided for @helpTasbihDesc.
  ///
  /// In en, this message translates to:
  /// **'Perform daily remembrance of Allah with tactile haptic pulses on each count and set completion.'**
  String get helpTasbihDesc;

  /// No description provided for @helpNamesOfAllahTitle.
  ///
  /// In en, this message translates to:
  /// **'Asmaul Husna (99 Names)'**
  String get helpNamesOfAllahTitle;

  /// No description provided for @helpNamesOfAllahDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn and listen to the divine names of Allah with authentic Arabic and Turkish pronunciation guides and detailed spiritual meanings.'**
  String get helpNamesOfAllahDesc;

  /// No description provided for @helpSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Proud Muslim PRO'**
  String get helpSubscriptionTitle;

  /// No description provided for @helpSubscriptionDesc.
  ///
  /// In en, this message translates to:
  /// **'All Quran reading, prayer times, Qibla compass, and core religious features are 100% free forever. PRO membership supports continuous development and unlocks premium custom themes and advanced customization.'**
  String get helpSubscriptionDesc;

  /// No description provided for @helpThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Islamic Themes'**
  String get helpThemesTitle;

  /// No description provided for @helpThemesDesc.
  ///
  /// In en, this message translates to:
  /// **'Select between 4 hand-crafted spiritual themes with automatic light and dark mode support.'**
  String get helpThemesDesc;

  /// No description provided for @shareHadith.
  ///
  /// In en, this message translates to:
  /// **'Share Hadith'**
  String get shareHadith;

  /// No description provided for @shareAyah.
  ///
  /// In en, this message translates to:
  /// **'Share Ayah'**
  String get shareAyah;

  /// No description provided for @reciteAyah.
  ///
  /// In en, this message translates to:
  /// **'Recite Ayah'**
  String get reciteAyah;

  /// No description provided for @copyAyah.
  ///
  /// In en, this message translates to:
  /// **'Copy Ayah'**
  String get copyAyah;

  /// No description provided for @ayahCopied.
  ///
  /// In en, this message translates to:
  /// **'Ayah copied to clipboard.'**
  String get ayahCopied;

  /// No description provided for @readNow.
  ///
  /// In en, this message translates to:
  /// **'Read Now'**
  String get readNow;

  /// No description provided for @updateGpsLocation.
  ///
  /// In en, this message translates to:
  /// **'Update GPS Location'**
  String get updateGpsLocation;

  /// No description provided for @quranTranslationSources.
  ///
  /// In en, this message translates to:
  /// **'Quran Translation Sources'**
  String get quranTranslationSources;

  /// No description provided for @quranTranslationSourcesDesc.
  ///
  /// In en, this message translates to:
  /// **'Translators, publishers, and licensing information'**
  String get quranTranslationSourcesDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'How we protect and handle your location data'**
  String get privacyPolicyDesc;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service & EULA'**
  String get termsOfService;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Terms governing subscriptions and app usage'**
  String get termsOfServiceDesc;

  /// No description provided for @dataAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Data & Account Deletion'**
  String get dataAccountDeletion;

  /// No description provided for @dataAccountDeletionDesc.
  ///
  /// In en, this message translates to:
  /// **'Request full deletion of locally stored data & preferences'**
  String get dataAccountDeletionDesc;

  /// No description provided for @supportAndContact.
  ///
  /// In en, this message translates to:
  /// **'Support & Contact'**
  String get supportAndContact;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportAnIssue;

  /// No description provided for @issueReceived.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your feedback has been received.'**
  String get issueReceived;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @billingProvider.
  ///
  /// In en, this message translates to:
  /// **'Billing Provider'**
  String get billingProvider;

  /// No description provided for @trialExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'Trial Expiration Date'**
  String get trialExpirationDate;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get monthlyPlan;

  /// No description provided for @trialStarts.
  ///
  /// In en, this message translates to:
  /// **'Trial Starts'**
  String get trialStarts;

  /// No description provided for @trialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial Ends'**
  String get trialEnds;

  /// No description provided for @fullAccess.
  ///
  /// In en, this message translates to:
  /// **'Full Access'**
  String get fullAccess;

  /// No description provided for @shuruqReminder.
  ///
  /// In en, this message translates to:
  /// **'Shuruq Reminder (Sunrise)'**
  String get shuruqReminder;

  /// No description provided for @shuruqReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Optional notification before sunrise'**
  String get shuruqReminderDesc;

  /// No description provided for @azanAudioActive.
  ///
  /// In en, this message translates to:
  /// **'Azan Audio Active'**
  String get azanAudioActive;

  /// No description provided for @silent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get silent;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'PRO Plan'**
  String get proPlan;

  /// No description provided for @trialPlan.
  ///
  /// In en, this message translates to:
  /// **'Trial Plan'**
  String get trialPlan;

  /// No description provided for @standardJuristic.
  ///
  /// In en, this message translates to:
  /// **'Standard (Shafi, Maliki, Hanbali)'**
  String get standardJuristic;

  /// No description provided for @hanafiJuristic.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get hanafiJuristic;

  /// No description provided for @westernNumerals.
  ///
  /// In en, this message translates to:
  /// **'Western Arabic (1, 2, 3...)'**
  String get westernNumerals;

  /// No description provided for @easternNumerals.
  ///
  /// In en, this message translates to:
  /// **'Eastern Arabic (١, ٢, ٣...)'**
  String get easternNumerals;

  /// No description provided for @listenExplanation.
  ///
  /// In en, this message translates to:
  /// **'Listen to Explanation'**
  String get listenExplanation;

  /// No description provided for @listenTurkishPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Turkish Pronunciation'**
  String get listenTurkishPronunciation;

  /// No description provided for @listenTurkishExplanation.
  ///
  /// In en, this message translates to:
  /// **'Turkish Explanation'**
  String get listenTurkishExplanation;

  /// No description provided for @audioLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading audio...'**
  String get audioLoading;

  /// No description provided for @audioPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'Unable to play audio. Please try again.'**
  String get audioPlaybackError;

  /// No description provided for @fourDynamicThemes.
  ///
  /// In en, this message translates to:
  /// **'4 Dynamic Themes'**
  String get fourDynamicThemes;

  /// No description provided for @typographyAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Typography & Accessibility'**
  String get typographyAccessibility;

  /// No description provided for @qiblaTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass Calibration & Tips'**
  String get qiblaTipsTitle;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting location...'**
  String get detectingLocation;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @locationSource.
  ///
  /// In en, this message translates to:
  /// **'Location Source'**
  String get locationSource;

  /// No description provided for @gpsAuto.
  ///
  /// In en, this message translates to:
  /// **'GPS (Auto)'**
  String get gpsAuto;

  /// No description provided for @manualSelected.
  ///
  /// In en, this message translates to:
  /// **'Manually Selected'**
  String get manualSelected;

  /// No description provided for @savedLocation.
  ///
  /// In en, this message translates to:
  /// **'Saved Location'**
  String get savedLocation;

  /// No description provided for @timeZoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timeZoneLabel;

  /// No description provided for @currentLocationStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocationStatus;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Proud Muslim Pro'**
  String get upgradeToPro;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Proud Muslim Pro Active'**
  String get premiumActive;

  /// No description provided for @appearanceAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Theme'**
  String get appearanceAndTheme;

  /// No description provided for @prayerAndAzan.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Adhan'**
  String get prayerAndAzan;

  /// No description provided for @calculationAndJuristic.
  ///
  /// In en, this message translates to:
  /// **'Calculation & Juristic Method'**
  String get calculationAndJuristic;

  /// No description provided for @locationSettings.
  ///
  /// In en, this message translates to:
  /// **'Location & GPS'**
  String get locationSettings;

  /// No description provided for @appFeatures.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Reminders & Sharing'**
  String get appFeatures;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndSupport;

  /// No description provided for @salahGuide.
  ///
  /// In en, this message translates to:
  /// **'Salah Guide'**
  String get salahGuide;

  /// No description provided for @wuduGuide.
  ///
  /// In en, this message translates to:
  /// **'Wudu Guide'**
  String get wuduGuide;

  /// No description provided for @playAdhan.
  ///
  /// In en, this message translates to:
  /// **'Play Adhan'**
  String get playAdhan;

  /// No description provided for @previewAdhan.
  ///
  /// In en, this message translates to:
  /// **'Preview Adhan'**
  String get previewAdhan;

  /// No description provided for @selectAdhanSound.
  ///
  /// In en, this message translates to:
  /// **'Select Adhan Sound'**
  String get selectAdhanSound;

  /// No description provided for @prePrayerReminder.
  ///
  /// In en, this message translates to:
  /// **'Pre-Prayer Reminder'**
  String get prePrayerReminder;

  /// No description provided for @customMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get customMinutes;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesCount(Object count);

  /// No description provided for @minBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String minBefore(Object minutes);

  /// No description provided for @minAfterAzan.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min after Azan'**
  String minAfterAzan(Object minutes);

  /// No description provided for @prePrayerAndIqamahReminders.
  ///
  /// In en, this message translates to:
  /// **'PRE-PRAYER & IQAMAH REMINDERS'**
  String get prePrayerAndIqamahReminders;

  /// No description provided for @individualPrayerAlerts.
  ///
  /// In en, this message translates to:
  /// **'INDIVIDUAL PRAYER ALERTS'**
  String get individualPrayerAlerts;

  /// No description provided for @adhanOn.
  ///
  /// In en, this message translates to:
  /// **'Adhan ON'**
  String get adhanOn;

  /// No description provided for @adhanOff.
  ///
  /// In en, this message translates to:
  /// **'Adhan OFF'**
  String get adhanOff;

  /// No description provided for @fajrAdhan.
  ///
  /// In en, this message translates to:
  /// **'Fajr Adhan'**
  String get fajrAdhan;

  /// No description provided for @dhuhrAdhan.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr Adhan'**
  String get dhuhrAdhan;

  /// No description provided for @asrAdhan.
  ///
  /// In en, this message translates to:
  /// **'Asr Adhan'**
  String get asrAdhan;

  /// No description provided for @maghribAdhan.
  ///
  /// In en, this message translates to:
  /// **'Maghrib Adhan'**
  String get maghribAdhan;

  /// No description provided for @ishaAdhan.
  ///
  /// In en, this message translates to:
  /// **'Isha Adhan'**
  String get ishaAdhan;

  /// No description provided for @vibrateOnScheduledAdhan.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when the scheduled Adhan begins'**
  String get vibrateOnScheduledAdhan;

  /// No description provided for @silentModeDndOverride.
  ///
  /// In en, this message translates to:
  /// **'Silent Mode / DND Override'**
  String get silentModeDndOverride;

  /// No description provided for @respectSystemSilentMode.
  ///
  /// In en, this message translates to:
  /// **'Respect system silent mode settings'**
  String get respectSystemSilentMode;

  /// No description provided for @languageAndRegionalSettings.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE & REGIONAL SETTINGS'**
  String get languageAndRegionalSettings;

  /// No description provided for @showSecondsInCountdown.
  ///
  /// In en, this message translates to:
  /// **'Show Seconds in Countdown'**
  String get showSecondsInCountdown;

  /// No description provided for @displayLiveSecondTicking.
  ///
  /// In en, this message translates to:
  /// **'Display live second ticking on next prayer card'**
  String get displayLiveSecondTicking;

  /// No description provided for @numeralFormat.
  ///
  /// In en, this message translates to:
  /// **'Numeral Format'**
  String get numeralFormat;

  /// No description provided for @westernArabicNumerals.
  ///
  /// In en, this message translates to:
  /// **'Western Arabic (1, 2, 3...)'**
  String get westernArabicNumerals;

  /// No description provided for @smokedGraphiteThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Smoked graphite glass with cool ice-silver accents'**
  String get smokedGraphiteThemeDesc;

  /// No description provided for @emeraldNightThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Rich emerald velvet with warm golden Islamic geometry'**
  String get emeraldNightThemeDesc;

  /// No description provided for @royalOudThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep obsidian crystal with champagne amber highlights'**
  String get royalOudThemeDesc;

  /// No description provided for @bismillahQuote.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, the Entirely Merciful, the Especially Merciful.'**
  String get bismillahQuote;

  /// No description provided for @dailySpiritualReminders.
  ///
  /// In en, this message translates to:
  /// **'DAILY SPIRITUAL REMINDERS'**
  String get dailySpiritualReminders;

  /// No description provided for @masterDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Master Daily Reminders'**
  String get masterDailyReminders;

  /// No description provided for @masterDailyRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable all app notifications and spiritual alerts'**
  String get masterDailyRemindersDesc;

  /// No description provided for @dailyAyahInspiration.
  ///
  /// In en, this message translates to:
  /// **'Daily Ayah Inspiration'**
  String get dailyAyahInspiration;

  /// No description provided for @dailyAyahInspirationDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive a daily Quranic verse reflection in the morning'**
  String get dailyAyahInspirationDesc;

  /// No description provided for @dailyHadithGemDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive an authentic prophetic Hadith narration daily'**
  String get dailyHadithGemDesc;

  /// No description provided for @morningEveningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Morning & Evening Azkar'**
  String get morningEveningAzkar;

  /// No description provided for @morningEveningAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for Hisn al-Muslim morning and evening adhkar'**
  String get morningEveningAzkarDesc;

  /// No description provided for @spreadTheMessage.
  ///
  /// In en, this message translates to:
  /// **'SPREAD THE MESSAGE (SADAQAH JARIYAH)'**
  String get spreadTheMessage;

  /// No description provided for @shareProudMuslimTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Proud Muslim with Family & Friends'**
  String get shareProudMuslimTitle;

  /// No description provided for @shareHadithQuote.
  ///
  /// In en, this message translates to:
  /// **'The one who guides to good is like the one who does it (Hadith)'**
  String get shareHadithQuote;

  /// No description provided for @shareAppText.
  ///
  /// In en, this message translates to:
  /// **'Proud Muslim: Quran, Prayer Times, Qibla & Azkar - Live your Deen every day. Download now: https://proudmuslim.app'**
  String get shareAppText;

  /// No description provided for @istanbulTurkeyGps.
  ///
  /// In en, this message translates to:
  /// **'Istanbul, Turkey (GPS)'**
  String get istanbulTurkeyGps;

  /// No description provided for @prayerTimeDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Time Diagnostics'**
  String get prayerTimeDiagnostics;

  /// No description provided for @inspectUtcIanaSolar.
  ///
  /// In en, this message translates to:
  /// **'Inspect UTC, IANA timezone & solar timestamps'**
  String get inspectUtcIanaSolar;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I ensure prayer times are 100% accurate for my location?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Ensure GPS location permission is granted to allow automatic coordinate calculation, or manually select your regional calculation authority (e.g., Diyanet for Turkey, MWL for Europe/Americas, ISNA for North America, Egypt General Authority, or Umm al-Qura for Saudi Arabia).'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How does the Qibla compass work and how is it calibrated?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'The Qibla compass combines your device magnetometer sensor and GPS location with the Great Circle formula pointing to the Holy Kaaba in Makkah. If sensor accuracy is low, wave your phone in a figure-eight motion away from magnetic interference.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How does the 3-Day Free Trial work?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'When starting a Proud Muslim Pro trial, you receive 3 full days of complimentary premium access to all adhan sounds, themes, and spiritual features. You can manage or cancel anytime via Google Play Subscriptions.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Are the Quran translations and Hadith authentic?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Yes, all translations, Quran verses, Hadith collections (including Imam Nawawi\'s 40 Hadith), and Hisn al-Muslim supplications are sourced from verified and recognized Islamic scholarly sources.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How does offline reading and audio playback work?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'The Arabic Quran text, 99 Names, and daily Azkar are bundled offline inside the app. Full translation editions can be downloaded for offline use directly in the Quran reader settings.'**
  String get faqA5;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'ABOUT THE APP'**
  String get aboutTheApp;

  /// No description provided for @aboutAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Proud Muslim is your premium Islamic companion for daily worship, Quran study, accurate prayer times, and spiritual growth. Built with high architectural fidelity, privacy-by-design, and respectful Islamic aesthetics.'**
  String get aboutAppDesc;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developerInfo;

  /// No description provided for @companyInfo.
  ///
  /// In en, this message translates to:
  /// **'ANM Digital Labs'**
  String get companyInfo;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @featurePrayerTimesDesc.
  ///
  /// In en, this message translates to:
  /// **'Astronomical precision prayer schedules with worldwide calculation methods and regional tuning.'**
  String get featurePrayerTimesDesc;

  /// No description provided for @featureQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Full 114 Surahs with Uthmani Arabic script, multi-language translations, word-by-word audio, and offline reading.'**
  String get featureQuranDesc;

  /// No description provided for @featureQiblaDesc.
  ///
  /// In en, this message translates to:
  /// **'Real-time 3D magnetic Qibla compass with Kaaba alignment haptic feedback.'**
  String get featureQiblaDesc;

  /// No description provided for @featureAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Authentic Hisn al-Muslim supplications for morning, evening, and daily remembrance.'**
  String get featureAzkarDesc;

  /// No description provided for @feature99NamesDesc.
  ///
  /// In en, this message translates to:
  /// **'99 Beautiful Names of Allah with meanings, Quran references, and audio pronunciation.'**
  String get feature99NamesDesc;

  /// No description provided for @featureZakatDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Islamic Zakat calculator with Nisab valuation and detailed asset categories.'**
  String get featureZakatDesc;

  /// No description provided for @copyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'© 2026 ANM Digital Labs. All rights reserved.'**
  String get copyrightNotice;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @legalInformation.
  ///
  /// In en, this message translates to:
  /// **'Legal Information'**
  String get legalInformation;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @unableToOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Unable to Open Page'**
  String get unableToOpenPage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @dataDeletionInfo.
  ///
  /// In en, this message translates to:
  /// **'For account and telemetry data deletion requests, contact support@proudmuslim.app.'**
  String get dataDeletionInfo;

  /// No description provided for @ghuslGuide.
  ///
  /// In en, this message translates to:
  /// **'Ghusl Guide'**
  String get ghuslGuide;

  /// No description provided for @ghuslOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Boy Abdesti (Gusül) / Full Purification'**
  String get ghuslOverviewTitle;

  /// No description provided for @ghuslOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Ghusl is the complete ritual purification required after major ritual impurity (Janabah, post-menstruation, post-partum) and recommended before Friday (Jummuah) prayers.'**
  String get ghuslOverviewDesc;

  /// No description provided for @whenGhuslRequired.
  ///
  /// In en, this message translates to:
  /// **'When Ghusl is Required'**
  String get whenGhuslRequired;

  /// No description provided for @ghuslObligatoryFarz.
  ///
  /// In en, this message translates to:
  /// **'Obligatory Elements (Farz): Rinsing the mouth thoroughly, rinsing the nose, and washing the entire body leaving no dry spot.'**
  String get ghuslObligatoryFarz;

  /// No description provided for @ghuslRecommendedSunnah.
  ///
  /// In en, this message translates to:
  /// **'Complete Sunnah Practice: Intention, washing hands, cleansing private parts, performing complete Wudu, pouring water over head 3 times, and washing right then left sides of the body.'**
  String get ghuslRecommendedSunnah;

  /// No description provided for @translationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Translation Language'**
  String get translationLanguage;

  /// No description provided for @translatorEdition.
  ///
  /// In en, this message translates to:
  /// **'Translator Edition'**
  String get translatorEdition;

  /// No description provided for @narrationVoice.
  ///
  /// In en, this message translates to:
  /// **'Narration Voice'**
  String get narrationVoice;

  /// No description provided for @voiceMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get voiceMale;

  /// No description provided for @voiceFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get voiceFemale;

  /// No description provided for @downloadForOfflineUse.
  ///
  /// In en, this message translates to:
  /// **'Download for Offline Use'**
  String get downloadForOfflineUse;

  /// No description provided for @downloadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading ({percent}%)...'**
  String downloadingProgress(Object percent);

  /// No description provided for @downloadSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{language} downloaded for offline use.'**
  String downloadSuccessMessage(Object language);

  /// No description provided for @downloadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not download translation. Please check connection.'**
  String get downloadErrorMessage;

  /// No description provided for @offlineAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Offline'**
  String get offlineAvailable;

  /// No description provided for @playFullSurah.
  ///
  /// In en, this message translates to:
  /// **'Play Full Surah'**
  String get playFullSurah;

  /// No description provided for @listenInLang.
  ///
  /// In en, this message translates to:
  /// **'Listen in {lang}'**
  String listenInLang(Object lang);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'id',
        'ms',
        'pt',
        'ru',
        'tr',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ms':
      return AppLocalizationsMs();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
