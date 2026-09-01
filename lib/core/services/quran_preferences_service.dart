// quran_preferences_service.dart
import 'storage_service.dart';
import '../repositories/quran_edition_repository.dart';

class QuranPreferencesService {
  /// Get user's preferred Quran translation language
  static String getSelectedLanguageCode() {
    return StorageService.quranTranslationLanguage;
  }

  /// Set user's preferred Quran translation language
  static Future<void> setSelectedLanguageCode(String code) async {
    await StorageService.setQuranTranslationLanguage(code);

    // Ensure edition matches language
    final currentEdition = QuranEditionRepository.getEditionById(
      getSelectedEditionId(code),
    );
    if (currentEdition == null || currentEdition.languageCode != code) {
      final defaultEdition =
          QuranEditionRepository.getDefaultEditionForLanguage(code);
      if (defaultEdition != null) {
        await setSelectedEditionId(defaultEdition.id);
      }
    }
  }

  /// Get user's selected translation edition ID
  static String getSelectedEditionId([String? languageCode]) {
    final lang = languageCode ?? getSelectedLanguageCode();
    final saved = StorageService.quranTranslationEditionId;

    final edition = QuranEditionRepository.getEditionById(saved);
    if (edition != null &&
        edition.languageCode == lang &&
        edition.approved &&
        edition.enabled) {
      return edition.id;
    }

    final def = QuranEditionRepository.getDefaultEditionForLanguage(lang);
    return def?.id ?? 'eng-mustafakhattaba';
  }

  /// Set user's selected translation edition ID
  static Future<void> setSelectedEditionId(String editionId) async {
    await StorageService.setQuranTranslationEditionId(editionId);
  }

  /// Get show translation toggle
  static bool getShowTranslation() {
    return StorageService.quranShowTranslation;
  }

  /// Set show translation toggle
  static Future<void> setShowTranslation(bool show) async {
    await StorageService.setQuranShowTranslation(show);
  }

  /// Font sizes
  static double getArabicFontSize() => StorageService.arabicFontSize;
  static Future<void> setArabicFontSize(double size) =>
      StorageService.setArabicFontSize(size);

  static double getTranslationFontSize() => StorageService.translationFontSize;
  static Future<void> setTranslationFontSize(double size) =>
      StorageService.setTranslationFontSize(size);
}
