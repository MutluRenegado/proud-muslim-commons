// names_of_allah_service.dart
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/allah_name_model.dart';

class NamesOfAllahService {
  static List<AllahNameModel>? _cachedNames;
  static Map<int, List<AllahNameQuranReference>>? _cachedReferences;

  static Future<List<AllahNameModel>> loadNames() async {
    if (_cachedNames != null) return _cachedNames!;
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/names_of_allah.json',
      );
      final list = jsonDecode(jsonStr) as List<dynamic>;
      _cachedNames = list
          .map((e) => AllahNameModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cachedNames!;
    } catch (e) {
      return [];
    }
  }

  /// Load Qur'an references for all 99 Names from assets/audio/names/quranReference.js
  static Future<Map<int, List<AllahNameQuranReference>>>
      loadQuranReferences() async {
    if (_cachedReferences != null) return _cachedReferences!;

    final Map<int, List<AllahNameQuranReference>> map = {};
    try {
      final jsContent = await rootBundle.loadString(
        'assets/audio/names/quranReference.js',
      );
      final refRegex = RegExp(r'\{\s*surah:\s*(\d+)\s*,\s*ayah:\s*(\d+)\s*\}');
      final lines = jsContent.split('\n');
      int nameIndex = 1;

      for (final line in lines) {
        final matches = refRegex.allMatches(line);
        if (matches.isNotEmpty) {
          final refs = matches.map((m) {
            final surah = int.parse(m.group(1)!);
            final ayah = int.parse(m.group(2)!);
            return AllahNameQuranReference(surah: surah, ayah: ayah);
          }).toList();
          map[nameIndex] = refs;
          nameIndex++;
          if (nameIndex > 99) break;
        }
      }
    } catch (_) {}

    _cachedReferences = map;
    return _cachedReferences!;
  }

  /// Get Qur'an references for a specific Name (1-99)
  static Future<List<AllahNameQuranReference>> getReferencesForName(
      int nameNumber) async {
    final allRefs = await loadQuranReferences();
    return allRefs[nameNumber] ?? const [];
  }
}
