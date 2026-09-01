// hadith_model.dart
class HadithModel {
  final int id;
  final String title;
  final String arabic;
  final String translation;
  final String narrator;
  final String source;
  final String explanation;
  final Map<String, dynamic>? translations;

  HadithModel({
    required this.id,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.narrator,
    required this.source,
    required this.explanation,
    this.translations,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as int,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      translation: json['translation'] as String,
      narrator: json['narrator'] as String,
      source: json['source'] as String,
      explanation: json['explanation'] as String,
      translations: json['translations'] as Map<String, dynamic>?,
    );
  }

  String getLocalizedTitle(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['title'] ?? title) as String;
    }
    return title;
  }

  String getLocalizedTranslation(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['translation'] ?? translation) as String;
    }
    return translation;
  }

  String getLocalizedNarrator(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['narrator'] ?? narrator) as String;
    }
    return narrator;
  }

  String getLocalizedSource(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['source'] ?? source) as String;
    }
    return source;
  }

  String getLocalizedExplanation(String langCode) {
    if (langCode == 'en' || langCode == 'ar') return explanation;
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['explanation'] ?? '') as String;
    }
    return explanation;
  }
}
