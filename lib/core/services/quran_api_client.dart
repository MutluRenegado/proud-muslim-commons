// quran_api_client.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranApiClient {
  /// Base CDN URLs for resilience
  static const List<String> _cdnBases = [
    'https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1',
    'https://raw.githubusercontent.com/fawazahmed0/quran-api/1',
    'https://al-quran.pages.dev',
  ];

  static const Duration _requestTimeout = Duration(seconds: 10);

  /// Fetch verses for a single Surah from an edition
  static Future<List<Map<String, dynamic>>?> fetchSurahVerses(
    String editionId,
    int surahNumber,
  ) async {
    for (final base in _cdnBases) {
      // 1. Try minified JSON
      try {
        final uri = Uri.parse(
          '$base/editions/$editionId/$surahNumber.min.json',
        );
        final response = await http.get(uri).timeout(_requestTimeout);
        if (response.statusCode == 200) {
          final verses = _parseAndValidateSurahResponse(
            response.body,
            surahNumber,
          );
          if (verses != null && verses.isNotEmpty) {
            return verses;
          }
        }
      } catch (_) {}

      // 2. Fallback to unminified JSON on same base
      try {
        final uri = Uri.parse('$base/editions/$editionId/$surahNumber.json');
        final response = await http.get(uri).timeout(_requestTimeout);
        if (response.statusCode == 200) {
          final verses = _parseAndValidateSurahResponse(
            response.body,
            surahNumber,
          );
          if (verses != null && verses.isNotEmpty) {
            return verses;
          }
        }
      } catch (_) {}
    }

    return null;
  }

  /// Fetch full Quran translation edition (all 114 surahs)
  static Future<List<Map<String, dynamic>>?> fetchFullEdition(
    String editionId,
  ) async {
    for (final base in _cdnBases) {
      try {
        final uri = Uri.parse('$base/editions/$editionId.min.json');
        final response =
            await http.get(uri).timeout(const Duration(seconds: 25));
        if (response.statusCode == 200) {
          final parsed = jsonDecode(response.body);
          if (parsed is Map<String, dynamic> && parsed['quran'] is List) {
            final list = (parsed['quran'] as List).cast<Map<String, dynamic>>();
            if (list.length >= 6000) {
              return list;
            }
          }
        }
      } catch (_) {}

      try {
        final uri = Uri.parse('$base/editions/$editionId.json');
        final response =
            await http.get(uri).timeout(const Duration(seconds: 25));
        if (response.statusCode == 200) {
          final parsed = jsonDecode(response.body);
          if (parsed is Map<String, dynamic> && parsed['quran'] is List) {
            final list = (parsed['quran'] as List).cast<Map<String, dynamic>>();
            if (list.length >= 6000) {
              return list;
            }
          }
        }
      } catch (_) {}
    }

    return null;
  }

  /// Parse and validate surah response payload
  static List<Map<String, dynamic>>? _parseAndValidateSurahResponse(
    String responseBody,
    int expectedSurahNumber,
  ) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) return null;

      final chapterList = decoded['chapter'];
      if (chapterList is! List || chapterList.isEmpty) return null;

      final List<Map<String, dynamic>> validated = [];
      for (int i = 0; i < chapterList.length; i++) {
        final item = chapterList[i];
        if (item is! Map<String, dynamic>) return null;

        final chapter = item['chapter'];
        final verse = item['verse'];
        final text = item['text'];

        if (chapter == null || verse == null || text == null) return null;
        if (chapter is! int || chapter != expectedSurahNumber) return null;
        if (verse is! int || verse <= 0) return null;
        if (text is! String || text.trim().isEmpty) return null;

        validated.add({
          'chapter': chapter,
          'verse': verse,
          'text': text.trim(),
        });
      }

      return validated;
    } catch (_) {
      return null;
    }
  }
}
