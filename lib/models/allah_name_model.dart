// allah_name_model.dart

class AllahNameQuranReference {
  final int surah;
  final int ayah;

  const AllahNameQuranReference({
    required this.surah,
    required this.ayah,
  });

  @override
  String toString() => '$surah:$ayah';
}

class AllahNameModel {
  final int number;
  final String arabic;
  final String transliteration;
  final String pronunciation;
  final String turkish;
  final String meaning;
  final String explanation;
  final Map<String, String> localizedMeaning;
  final Map<String, String> localizedExplanation;
  final String? arabicNativeAudio;
  final String? turkishPronunciationAudio;
  final String? turkishExplanationAudio;
  final Map<String, String> localizedExplanationAudio;

  // Legacy compatibility getters
  String? get arabicAudio => arabicNativeAudio;
  String? get turkishAudio => turkishExplanationAudio;

  AllahNameModel({
    required this.number,
    required this.arabic,
    required this.transliteration,
    this.pronunciation = '',
    this.turkish = '',
    required this.meaning,
    required this.explanation,
    this.localizedMeaning = const {},
    this.localizedExplanation = const {},
    this.arabicNativeAudio,
    this.turkishPronunciationAudio,
    this.turkishExplanationAudio,
    this.localizedExplanationAudio = const {},
  });

  factory AllahNameModel.fromJson(Map<String, dynamic> json) {
    // Parse localized mappings
    final locMeaning = <String, String>{};
    if (json['localizedMeaning'] is Map) {
      (json['localizedMeaning'] as Map).forEach((k, v) {
        locMeaning[k.toString()] = v.toString();
      });
    } else if (json['turkishMeaning'] != null) {
      locMeaning['tr'] = json['turkishMeaning'].toString();
    }

    final locExplanation = <String, String>{};
    if (json['localizedExplanation'] is Map) {
      (json['localizedExplanation'] as Map).forEach((k, v) {
        locExplanation[k.toString()] = v.toString();
      });
    } else if (json['turkishExplanation'] != null) {
      locExplanation['tr'] = json['turkishExplanation'].toString();
    }

    final locExplAudio = <String, String>{};
    if (json['localizedExplanationAudio'] is Map) {
      (json['localizedExplanationAudio'] as Map).forEach((k, v) {
        locExplAudio[k.toString()] = v.toString();
      });
    }

    final num = json['number'] as int? ?? 1;
    final numPadded = num.toString().padLeft(3, '0');

    final arAudio = 'assets/audio/names/arabic_pronunciation/$num.mp3';

    final trPronAudio = (json['turkishPronunciationAudio'] != null &&
            json['turkishPronunciationAudio'].toString().startsWith('assets/'))
        ? json['turkishPronunciationAudio'] as String
        : 'assets/audio/names/turkish_pronunciation/$numPadded.mp3';

    final trExplAudio = json['turkishExplanationAudio'] as String? ??
        json['turkishAudio'] as String? ??
        'assets/audio/names/turkish_explanation/${4000 + num}.mp3';

    return AllahNameModel(
      number: num,
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? '',
      turkish: json['turkish'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      localizedMeaning: locMeaning,
      localizedExplanation: locExplanation,
      arabicNativeAudio: arAudio,
      turkishPronunciationAudio: trPronAudio,
      turkishExplanationAudio: trExplAudio,
      localizedExplanationAudio: locExplAudio,
    );
  }

  /// Get localized meaning for given language code with English fallback
  String getMeaning(String langCode) {
    if (localizedMeaning.containsKey(langCode) &&
        localizedMeaning[langCode]!.isNotEmpty) {
      return localizedMeaning[langCode]!;
    }
    return meaning;
  }

  /// Get localized explanation for given language code with English fallback
  String getExplanation(String langCode) {
    if (localizedExplanation.containsKey(langCode) &&
        localizedExplanation[langCode]!.isNotEmpty) {
      return localizedExplanation[langCode]!;
    }
    return explanation;
  }

  /// Get audio path for localized explanation
  String? getExplanationAudio(String langCode) {
    if (localizedExplanationAudio.containsKey(langCode) &&
        localizedExplanationAudio[langCode]!.isNotEmpty) {
      return localizedExplanationAudio[langCode];
    }
    if (langCode == 'tr') return turkishExplanationAudio;
    if (langCode == 'en') {
      final enPath =
          'assets/audio/names/english_explanation/${1000 + number}.mp3';
      return enPath;
    }
    return null;
  }
}
