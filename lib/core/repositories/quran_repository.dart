// quran_repository.dart
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/surah_model.dart';
import '../../models/ayah_model.dart';
import '../../models/quran_edition.dart';
import '../services/quran_api_client.dart';
import '../services/quran_cache_service.dart';
import 'quran_edition_repository.dart';

class QuranRepository {
  static List<SurahModel>? _cachedSurahs;
  static Map<String, dynamic>? _offlineArabicVerses;

  /// Load all 114 Surahs metadata
  static Future<List<SurahModel>> loadSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/quran_surahs.json',
      );
      final list = jsonDecode(jsonStr) as List<dynamic>;
      _cachedSurahs = list
          .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cachedSurahs!;
    } catch (_) {
      return [];
    }
  }

  /// Get Surah by number
  static Future<SurahModel?> getSurah(int surahNumber) async {
    final surahs = await loadSurahs();
    try {
      return surahs.firstWhere((s) => s.number == surahNumber);
    } catch (_) {
      return null;
    }
  }

  /// Get specific Ayah (Arabic text + Translation in active language with English fallback)
  static Future<AyahModel?> getAyah(
    int surahNumber,
    int ayahNumber, {
    required String languageCode,
  }) async {
    final edition = QuranEditionRepository.getDefaultEditionForLanguage(
          languageCode,
        ) ??
        QuranEditionRepository.getDefaultEditionForLanguage('en');
    final editionId = edition?.id ?? 'eng-mustafakhattaba';
    final verses = await getSurahVerses(
      surahNumber,
      editionId: editionId,
      showTranslation: true,
    );
    try {
      final match = verses.firstWhere((a) => a.numberInSurah == ayahNumber);
      if (match.translation.trim().isEmpty ||
          match.translation == 'Translation temporarily unavailable.') {
        if (languageCode != 'en') {
          final enEdition =
              QuranEditionRepository.getDefaultEditionForLanguage('en');
          final enVerses = await getSurahVerses(
            surahNumber,
            editionId: enEdition?.id ?? 'eng-mustafakhattaba',
            showTranslation: true,
          );
          try {
            final enMatch =
                enVerses.firstWhere((a) => a.numberInSurah == ayahNumber);
            return AyahModel(
              number: match.number,
              text: match.text,
              translation: enMatch.translation,
              isRtlTranslation: false,
              audioUrl: match.audioUrl,
              surahNumber: surahNumber,
              translationEditionId: enMatch.translationEditionId,
              translatorName: enMatch.translatorName,
            );
          } catch (_) {}
        }
      }
      return match;
    } catch (_) {
      return null;
    }
  }

  /// Load canonical Arabic Quran verses for a surah
  static Future<List<Map<String, dynamic>>> _loadArabicVerses(
    int surahNumber,
  ) async {
    // 1. Check offline bundled asset
    try {
      if (_offlineArabicVerses == null) {
        final jsonStr = await rootBundle.loadString(
          'assets/data/quran_verses_offline.json',
        );
        _offlineArabicVerses = jsonDecode(jsonStr) as Map<String, dynamic>;
      }
      if (_offlineArabicVerses!.containsKey(surahNumber.toString())) {
        final list =
            _offlineArabicVerses![surahNumber.toString()] as List<dynamic>;
        return list
            .map(
              (e) => {
                'chapter': surahNumber,
                'verse': (e['number'] ?? e['numberInSurah'] ?? 1) as int,
                'text': (e['text'] ?? e['arabic'] ?? '') as String,
              },
            )
            .toList();
      }
    } catch (_) {}

    // 2. Check local cache for Arabic text
    final cachedArabic = QuranCacheService.getCachedSurahVerses(
      'ara-quranacademy',
      surahNumber,
    );
    if (cachedArabic != null && cachedArabic.isNotEmpty) {
      return cachedArabic;
    }

    // 3. Fetch canonical Arabic from API
    try {
      final remoteArabic = await QuranApiClient.fetchSurahVerses(
        'ara-quranacademy',
        surahNumber,
      );
      if (remoteArabic != null && remoteArabic.isNotEmpty) {
        await QuranCacheService.saveSurahVerses(
          'ara-quranacademy',
          surahNumber,
          remoteArabic,
        );
        return remoteArabic;
      }
    } catch (_) {}

    // 4. Fallback if completely offline & not bundled
    final surahMeta = await getSurah(surahNumber);
    final count = surahMeta?.numberOfAyahs ?? 7;
    return List.generate(
      count,
      (i) => {
        'chapter': surahNumber,
        'verse': i + 1,
        'text': i == 0 && surahNumber != 1 && surahNumber != 9
            ? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'
            : 'آية ${i + 1}',
      },
    );
  }

  /// Load Surah Verses with Arabic canonical text and selected translation
  static Future<List<AyahModel>> getSurahVerses(
    int surahNumber, {
    required String editionId,
    bool showTranslation = true,
  }) async {
    // 1. Load canonical Arabic Quran text (NEVER FAILS / NEVER HIDDEN)
    final arabicVerses = await _loadArabicVerses(surahNumber);

    // 2. Resolve Translation Edition
    QuranEdition? edition = QuranEditionRepository.getEditionById(editionId);
    if (edition == null || !edition.approved) {
      edition = QuranEditionRepository.getDefaultEditionForLanguage('en');
    }

    final isRtlTrans = edition?.isRtl ?? false;
    final translatorLabel = edition?.translatorName;

    // 3. If translation is disabled or language is Arabic (canonical only), return with empty translation
    if (!showTranslation || edition?.languageCode == 'ar') {
      return _combineVerses(
        surahNumber: surahNumber,
        arabicList: arabicVerses,
        translationMap: {},
        isRtlTrans: isRtlTrans,
        translatorName: null,
        editionId: edition?.id,
        fallbackMessage: '',
      );
    }

    // 4. Check local cache for translation
    final currentEditionId = edition?.apiEditionId ?? editionId;
    List<Map<String, dynamic>>? translationVerses =
        QuranCacheService.getCachedSurahVerses(currentEditionId, surahNumber);

    // 5. If not cached, fetch from Fawaz Ahmed Quran API
    if (translationVerses == null || translationVerses.isEmpty) {
      try {
        translationVerses = await QuranApiClient.fetchSurahVerses(
          currentEditionId,
          surahNumber,
        );

        if (translationVerses != null && translationVerses.isNotEmpty) {
          // Cache locally for offline resilience
          await QuranCacheService.saveSurahVerses(
            currentEditionId,
            surahNumber,
            translationVerses,
          );
        }
      } catch (_) {}
    }

    // 6. Build translation lookup map
    final Map<int, String> transMap = {};
    if (translationVerses != null) {
      for (final v in translationVerses) {
        final verseNum = v['verse'] as int? ?? 1;
        final text = (v['text'] ?? '').toString();
        transMap[verseNum] = text;
      }
    }

    // 7. Combine Arabic & Translation
    return _combineVerses(
      surahNumber: surahNumber,
      arabicList: arabicVerses,
      translationMap: transMap,
      isRtlTrans: isRtlTrans,
      translatorName: translatorLabel,
      editionId: currentEditionId,
      fallbackMessage:
          transMap.isEmpty ? 'Translation temporarily unavailable.' : '',
    );
  }

  /// Combine Arabic and translation verses
  static List<AyahModel> _combineVerses({
    required int surahNumber,
    required List<Map<String, dynamic>> arabicList,
    required Map<int, String> translationMap,
    required bool isRtlTrans,
    required String? translatorName,
    required String? editionId,
    required String fallbackMessage,
  }) {
    final List<AyahModel> results = [];

    for (int i = 0; i < arabicList.length; i++) {
      final a = arabicList[i];
      final verseNum = a['verse'] as int? ?? (i + 1);
      final arabicText = (a['text'] ?? '').toString();
      final translationText = translationMap[verseNum] ?? fallbackMessage;

      // Islamic Network global audio indexing fallback
      final globalAudio =
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/${_getGlobalAyahIndex(surahNumber, verseNum)}.mp3';

      results.add(
        AyahModel(
          number: verseNum,
          text: arabicText,
          translation: translationText,
          audioUrl: globalAudio,
          surahNumber: surahNumber,
          translatorName: translatorName,
          translationEditionId: editionId,
          isRtlTranslation: isRtlTrans,
        ),
      );
    }

    return results;
  }

  /// Pre-fetch full language edition for offline use
  static Future<bool> downloadLanguageForOffline(
    String languageCode, {
    String? editionId,
    void Function(double progress)? onProgress,
  }) async {
    final requestedEdition = editionId == null
        ? null
        : QuranEditionRepository.getEditionById(editionId);
    final edition = requestedEdition?.languageCode == languageCode
        ? requestedEdition
        : QuranEditionRepository.getDefaultEditionForLanguage(languageCode);
    if (edition == null) return false;

    // The complete canonical Arabic text ships inside the application and is
    // therefore already available offline. Mark it consistently in settings.
    if (languageCode == 'ar') {
      for (var surah = 1; surah <= 114; surah++) {
        await _loadArabicVerses(surah);
        onProgress?.call(surah / 114);
      }
      await QuranCacheService.setEditionFullyDownloaded(
        edition.apiEditionId,
        true,
      );
      return true;
    }

    // Check if already fully downloaded
    if (QuranCacheService.isEditionFullyDownloaded(edition.apiEditionId)) {
      onProgress?.call(1.0);
      return true;
    }

    try {
      // 1. Try full edition bulk download
      final fullList = await QuranApiClient.fetchFullEdition(
        edition.apiEditionId,
      );
      if (fullList != null && fullList.isNotEmpty) {
        await QuranCacheService.saveFullEdition(edition.apiEditionId, fullList);
        onProgress?.call(1.0);
        return true;
      }

      // 2. Otherwise download surah by surah (1 to 114)
      var completedSurahs = 0;
      for (int s = 1; s <= 114; s++) {
        if (!QuranCacheService.isSurahCached(edition.apiEditionId, s)) {
          final verses = await QuranApiClient.fetchSurahVerses(
            edition.apiEditionId,
            s,
          );
          if (verses != null && verses.isNotEmpty) {
            await QuranCacheService.saveSurahVerses(
              edition.apiEditionId,
              s,
              verses,
            );
          } else {
            return false;
          }
        }
        completedSurahs++;
        onProgress?.call(s / 114.0);
      }

      final complete = completedSurahs == 114;
      if (complete) {
        await QuranCacheService.setEditionFullyDownloaded(
          edition.apiEditionId,
          true,
        );
      }
      return complete;
    } catch (_) {
      return false;
    }
  }

  /// Search across Surah names, Arabic verses, and cached translations
  static Future<List<AyahModel>> searchQuran(
    String query, {
    required String editionId,
  }) async {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.trim().toLowerCase();
    final List<AyahModel> results = [];

    // Search in offline bundled verses and cached translations
    try {
      if (_offlineArabicVerses == null) {
        final jsonStr = await rootBundle.loadString(
          'assets/data/quran_verses_offline.json',
        );
        _offlineArabicVerses = jsonDecode(jsonStr) as Map<String, dynamic>;
      }

      _offlineArabicVerses!.forEach((sNumStr, verses) {
        final sNum = int.tryParse(sNumStr) ?? 1;
        for (var v in (verses as List<dynamic>)) {
          final text = (v['text'] ?? '').toString();
          final trans = (v['translation'] ?? '').toString();

          if (text.contains(query) ||
              trans.toLowerCase().contains(cleanQuery)) {
            results.add(AyahModel.fromJson(v as Map<String, dynamic>, sNum));
          }
        }
      });
    } catch (_) {}

    return results;
  }

  /// Approximate global ayah index for Alafasy audio
  static int _getGlobalAyahIndex(int surahNumber, int ayahNumber) {
    const List<int> cumulativeAyahs = [
      0,
      7,
      293,
      493,
      669,
      789,
      954,
      1160,
      1235,
      1364,
      1473,
      1596,
      1707,
      1750,
      1802,
      1901,
      2029,
      2140,
      2250,
      2348,
      2483,
      2595,
      2673,
      2791,
      2855,
      2932,
      3159,
      3252,
      3340,
      3409,
      3469,
      3503,
      3533,
      3606,
      3660,
      3705,
      3788,
      3970,
      4058,
      4133,
      4218,
      4272,
      4325,
      4414,
      4473,
      4510,
      4545,
      4583,
      4612,
      4630,
      4675,
      4735,
      4784,
      4846,
      4901,
      4979,
      5075,
      5104,
      5126,
      5150,
      5163,
      5177,
      5188,
      5199,
      5217,
      5229,
      5241,
      5271,
      5323,
      5375,
      5419,
      5447,
      5475,
      5495,
      5551,
      5591,
      5622,
      5672,
      5712,
      5754,
      5796,
      5825,
      5833,
      5869,
      5894,
      5916,
      5935,
      5954,
      5980,
      6010,
      6030,
      6045,
      6056,
      6064,
      6072,
      6080,
      6099,
      6104,
      6112,
      6120,
      6131,
      6142,
      6145,
      6148,
      6151,
      6156,
      6160,
      6164,
      6170,
      6173,
      6176,
      6181,
      6186,
      6192,
      6236,
    ];

    if (surahNumber >= 1 && surahNumber <= 114) {
      final base = cumulativeAyahs[surahNumber - 1];
      return base + ayahNumber;
    }
    return ayahNumber;
  }
}
