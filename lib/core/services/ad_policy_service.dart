import 'storage_service.dart';

/// Centralized ad policy service enforcing Proud Muslim monetization & ad display rules.
///
/// ADVERTISING RULES MATRIX:
/// -------------------------------------------------------------
/// User / Section               | Advertising
/// -------------------------------------------------------------
/// Any user — Quran Reading     | NO ADS (100% Free & Ad-Free Forever)
/// Any user — Esmaul Husna      | NO ADS (100% Free & Ad-Free Forever)
/// Normal free user — Other     | ADS (Free with ads)
/// Paid Ad-Free subscriber      | NO ADS (Entire app)
/// akgnmutlu@gmail.com          | NO ADS (Entire app permanent)
/// testingisamust32@gmail.com   | NO ADS (Entire app permanent)
/// -------------------------------------------------------------
class AdPolicyService {
  // Defined section identifiers
  static const String sectionQuran = 'quran';
  static const String sectionNamesOfAllah = 'names_of_allah';
  static const String sectionHome = 'home';
  static const String sectionPrayer = 'prayer';
  static const String sectionQibla = 'qibla';
  static const String sectionAzkar = 'azkar';
  static const String sectionHadith = 'hadith';
  static const String sectionCalendar = 'calendar';
  static const String sectionZakat = 'zakat';
  static const String sectionLearn = 'learn';
  static const String sectionSettings = 'settings';
  static const String sectionGeneral = 'general';

  /// Evaluates whether an ad (banner, interstitial, rewarded, native, open) is allowed to be shown.
  ///
  /// Parameters:
  /// - [section]: The section of the application where the ad would be displayed.
  /// - [customUserEmail]: Optional email override for unit testing entitlement evaluation.
  /// - [customIsPaidSubscribed]: Optional subscription override for unit testing.
  static bool shouldShowAds({
    required String section,
    String? customUserEmail,
    bool? customIsPaidSubscribed,
  }) {
    // RULE 1: Reading Quran is permanently FREE and AD-FREE for ALL users.
    if (section == sectionQuran || section.toLowerCase().contains('quran')) {
      return false;
    }

    // RULE 2: Esmaul Husna / 99 Names of Allah is permanently FREE and AD-FREE for ALL users.
    if (section == sectionNamesOfAllah ||
        section.toLowerCase().contains('names_of_allah') ||
        section.toLowerCase().contains('esmaul_husna') ||
        section.toLowerCase().contains('asmaul_husna')) {
      return false;
    }

    // Check Ad-Free Entitlement (Paid subscriber or authorized permanent account)
    final bool isSpecialAccount = customUserEmail != null
        ? StorageService.isPermanentAdFreeEmail(customUserEmail)
        : StorageService.isPermanentAdFreeAccount;

    final bool isPaidSubscribed =
        customIsPaidSubscribed ?? StorageService.isPaidSubscribed;

    final bool hasAdFreeEntitlement = isSpecialAccount || isPaidSubscribed;

    // RULE 3: Valid Ad-Free subscribers and authorized special accounts never see ads.
    if (hasAdFreeEntitlement) {
      return false;
    }

    // RULE 4: Normal free users receive ads on all other app features.
    return true;
  }
}
