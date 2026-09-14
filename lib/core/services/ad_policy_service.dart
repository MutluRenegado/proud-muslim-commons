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

  /// Evaluates whether an ad is allowed to be shown.
  /// 100% Ad-Free across the entire application for all users.
  static bool shouldShowAds({
    required String section,
    String? customUserEmail,
    bool? customIsPaidSubscribed,
  }) {
    return false;
  }
}
