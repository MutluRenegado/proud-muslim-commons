import 'dart:convert';

import 'package:flutter/services.dart';

class PrayerExplanationContent {
  const PrayerExplanationContent({
    required this.title,
    required this.intro,
    required this.note,
    required this.sourcesTitle,
    required this.names,
    required this.shortTexts,
    required this.longTexts,
    required this.references,
    required this.sources,
  });

  final String title;
  final String intro;
  final String note;
  final String sourcesTitle;
  final List<String> names;
  final List<String> shortTexts;
  final List<String> longTexts;
  final List<String> references;
  final List<PrayerExplanationSource> sources;
}

class PrayerExplanationSource {
  const PrayerExplanationSource(this.label, this.url);
  final String label;
  final String url;
}

class PrayerExplanationService {
  PrayerExplanationService._();

  static const supportedLanguages = {
    'en', 'tr', 'ar', 'de', 'fr', 'es', 'pt', 'ru', 'id', 'ur', 'ms',
  };

  static Map<String, dynamic>? _data;

  static Future<void> preload() async {
    if (_data != null) return;
    final raw = await rootBundle.loadString(
      'assets/data/prayer_time_explanations.json',
    );
    _data = jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<PrayerExplanationContent> forLanguage(String language) async {
    await preload();
    final selected = supportedLanguages.contains(language) ? language : 'en';
    final languages = _data!['languages'] as Map<String, dynamic>;
    final value = languages[selected] as Map<String, dynamic>;
    final sourceRows = _data!['sources'] as List<dynamic>;
    return PrayerExplanationContent(
      title: value['title'] as String,
      intro: value['intro'] as String,
      note: value['note'] as String,
      sourcesTitle: value['sourcesTitle'] as String,
      names: List<String>.from(value['names'] as List<dynamic>),
      shortTexts: List<String>.from(value['shortTexts'] as List<dynamic>),
      longTexts: List<String>.from(value['longTexts'] as List<dynamic>),
      references: List<String>.from(_data!['references'] as List<dynamic>),
      sources: sourceRows.map((row) {
        final values = row as List<dynamic>;
        return PrayerExplanationSource(values[0] as String, values[1] as String);
      }).toList(growable: false),
    );
  }
}
