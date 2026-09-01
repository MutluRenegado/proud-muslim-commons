// quran_language.dart

class QuranLanguage {
  final String code; // e.g. 'ar', 'tr', 'en'
  final String englishName; // e.g. 'Turkish'
  final String nativeName; // e.g. 'Türkçe'
  final bool isRtl; // true for Arabic, Urdu, Persian

  const QuranLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    this.isRtl = false,
  });

  factory QuranLanguage.fromJson(Map<String, dynamic> json) {
    return QuranLanguage(
      code: json['code'] as String,
      englishName: json['englishName'] as String,
      nativeName: json['nativeName'] as String,
      isRtl: json['isRtl'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'englishName': englishName,
        'nativeName': nativeName,
        'isRtl': isRtl,
      };
}
