// quran_cache_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuranCacheService {
  static SharedPreferences? _prefs;
  static final Map<String, List<Map<String, dynamic>>> _memoryCache = {};

  static Future<void> init([SharedPreferences? prefs]) async {
    _prefs = prefs ?? await SharedPreferences.getInstance();
    try {
      final keysToRemove =
          _prefs!.getKeys().where((k) => k.contains('tur-alibulac')).toList();
      for (final k in keysToRemove) {
        await _prefs!.remove(k);
      }
    } catch (_) {}
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('QuranCacheService not initialized.');
    }
    return _prefs!;
  }

  static String _surahKey(String editionId, int surahNumber) =>
      'quran_trans_${editionId}_s$surahNumber';

  static String _fullEditionKey(String editionId) =>
      'quran_trans_${editionId}_full_downloaded';

  /// Get cached verses for a specific surah & translation edition
  static List<Map<String, dynamic>>? getCachedSurahVerses(
    String editionId,
    int surahNumber,
  ) {
    final key = _surahKey(editionId, surahNumber);

    // 1. Check memory cache
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }

    // 2. Check local disk storage
    try {
      if (_prefs == null) return null;
      final raw = _prefs!.getString(key);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        final list = decoded.cast<Map<String, dynamic>>();
        _memoryCache[key] = list;
        return list;
      }
    } catch (_) {}

    return null;
  }

  /// Save verses for a specific surah & edition to cache
  static Future<void> saveSurahVerses(
    String editionId,
    int surahNumber,
    List<Map<String, dynamic>> verses,
  ) async {
    final key = _surahKey(editionId, surahNumber);
    _memoryCache[key] = verses;

    try {
      if (_prefs != null) {
        await _prefs!.setString(key, jsonEncode(verses));
      }
    } catch (_) {}
  }

  /// Check if a specific surah is cached
  static bool isSurahCached(String editionId, int surahNumber) {
    final key = _surahKey(editionId, surahNumber);
    if (_memoryCache.containsKey(key)) return true;
    if (_prefs == null) return false;
    return _prefs!.containsKey(key);
  }

  /// Check if an edition has been fully downloaded for offline use
  static bool isEditionFullyDownloaded(String editionId) {
    if (_prefs == null) return false;
    return _prefs!.getBool(_fullEditionKey(editionId)) ?? false;
  }

  /// Mark an edition as fully downloaded
  static Future<void> setEditionFullyDownloaded(
    String editionId,
    bool val,
  ) async {
    if (_prefs == null) return;
    await _prefs!.setBool(_fullEditionKey(editionId), val);
  }

  /// Cache a full edition across all 114 surahs
  static Future<void> saveFullEdition(
    String editionId,
    List<Map<String, dynamic>> allVerses,
  ) async {
    // Group by chapter
    final Map<int, List<Map<String, dynamic>>> bySurah = {};
    for (final v in allVerses) {
      final sNum = v['chapter'] as int? ?? 1;
      bySurah.putIfAbsent(sNum, () => []).add(v);
    }

    for (final entry in bySurah.entries) {
      await saveSurahVerses(editionId, entry.key, entry.value);
    }

    await setEditionFullyDownloaded(editionId, true);
  }

  /// Clear cache for a specific edition or all
  static Future<void> clearCache({String? editionId}) async {
    _memoryCache.clear();
    if (_prefs == null) return;

    final keys = _prefs!.getKeys();
    for (final k in keys) {
      if (editionId != null) {
        if (k.startsWith('quran_trans_${editionId}_')) {
          await _prefs!.remove(k);
        }
      } else {
        if (k.startsWith('quran_trans_')) {
          await _prefs!.remove(k);
        }
      }
    }
  }
}
