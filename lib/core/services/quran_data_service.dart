// quran_data_service.dart
import '../../models/surah_model.dart';
import '../../models/ayah_model.dart';
import '../repositories/quran_repository.dart';
import 'quran_preferences_service.dart';

class QuranDataService {
  static Future<List<SurahModel>> loadSurahs() async {
    return QuranRepository.loadSurahs();
  }

  static Future<List<AyahModel>> loadSurahVerses(
    int surahNumber, {
    String? editionId,
    bool? showTranslation,
  }) async {
    final effectiveEditionId =
        editionId ?? QuranPreferencesService.getSelectedEditionId();
    final effectiveShowTranslation =
        showTranslation ?? QuranPreferencesService.getShowTranslation();

    return QuranRepository.getSurahVerses(
      surahNumber,
      editionId: effectiveEditionId,
      showTranslation: effectiveShowTranslation,
    );
  }

  static Future<List<AyahModel>> searchQuran(
    String query, {
    String? editionId,
  }) async {
    final effectiveEditionId =
        editionId ?? QuranPreferencesService.getSelectedEditionId();
    return QuranRepository.searchQuran(query, editionId: effectiveEditionId);
  }
}
