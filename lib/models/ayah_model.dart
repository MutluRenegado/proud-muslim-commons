// ayah_model.dart
class AyahModel {
  final int number;
  final String text;
  final String translation;
  final String? audioUrl;
  final int? surahNumber;
  final int? juz;
  final int? page;
  final String? translatorName;
  final String? translationEditionId;
  final bool isRtlTranslation;

  String get arabicText => text;
  int get numberInSurah => number;

  AyahModel({
    required this.number,
    required this.text,
    required this.translation,
    this.audioUrl,
    this.surahNumber,
    this.juz,
    this.page,
    this.translatorName,
    this.translationEditionId,
    this.isRtlTranslation = false,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json, [int? surahNum]) {
    return AyahModel(
      number: json['number'] as int? ??
          json['numberInSurah'] as int? ??
          json['verse'] as int? ??
          1,
      text: json['text'] as String? ?? json['arabic'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? json['audio'] as String?,
      surahNumber: surahNum ??
          (json['surahNumber'] as int?) ??
          (json['chapter'] as int?),
      juz: json['juz'] as int?,
      page: json['page'] as int?,
      translatorName: json['translatorName'] as String?,
      translationEditionId: json['translationEditionId'] as String?,
      isRtlTranslation: json['isRtlTranslation'] as bool? ?? false,
    );
  }

  AyahModel copyWith({
    int? number,
    String? text,
    String? translation,
    String? audioUrl,
    int? surahNumber,
    int? juz,
    int? page,
    String? translatorName,
    String? translationEditionId,
    bool? isRtlTranslation,
  }) {
    return AyahModel(
      number: number ?? this.number,
      text: text ?? this.text,
      translation: translation ?? this.translation,
      audioUrl: audioUrl ?? this.audioUrl,
      surahNumber: surahNumber ?? this.surahNumber,
      juz: juz ?? this.juz,
      page: page ?? this.page,
      translatorName: translatorName ?? this.translatorName,
      translationEditionId: translationEditionId ?? this.translationEditionId,
      isRtlTranslation: isRtlTranslation ?? this.isRtlTranslation,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'text': text,
        'translation': translation,
        'audioUrl': audioUrl,
        'surahNumber': surahNumber,
        'juz': juz,
        'page': page,
        'translatorName': translatorName,
        'translationEditionId': translationEditionId,
        'isRtlTranslation': isRtlTranslation,
      };
}
