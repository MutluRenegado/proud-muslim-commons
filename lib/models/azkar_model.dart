// azkar_model.dart
class AzkarCategoryModel {
  final String categoryId;
  final String categoryTitle;
  final String icon;
  final List<AzkarItemModel> items;
  final Map<String, dynamic>? categoryTitles;

  AzkarCategoryModel({
    required this.categoryId,
    required this.categoryTitle,
    required this.icon,
    required this.items,
    this.categoryTitles,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      categoryId: json['categoryId'] as String,
      categoryTitle: json['categoryTitle'] as String,
      icon: json['icon'] as String,
      categoryTitles: json['categoryTitles'] as Map<String, dynamic>?,
      items: (json['items'] as List<dynamic>)
          .map((e) => AzkarItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String getLocalizedTitle(String langCode) {
    if (categoryTitles != null && categoryTitles!.containsKey(langCode)) {
      return categoryTitles![langCode] as String;
    }
    return categoryTitle;
  }
}

class AzkarItemModel {
  final String id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final int repeat;
  final String reference;
  final String benefit;
  final Map<String, dynamic>? translations;
  final int? quranSurah;
  final int? quranAyahStart;
  final int? quranAyahEnd;

  AzkarItemModel({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.repeat,
    required this.reference,
    required this.benefit,
    this.translations,
    this.quranSurah,
    this.quranAyahStart,
    this.quranAyahEnd,
  });

  factory AzkarItemModel.fromJson(Map<String, dynamic> json) {
    return AzkarItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      repeat: json['repeat'] as int,
      reference: json['reference'] as String,
      benefit: json['benefit'] as String,
      translations: json['translations'] as Map<String, dynamic>?,
      quranSurah: json['quranSurah'] as int?,
      quranAyahStart: json['quranAyahStart'] as int?,
      quranAyahEnd: json['quranAyahEnd'] as int?,
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

  String getLocalizedBenefit(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['benefit'] ?? benefit) as String;
    }
    return benefit;
  }
}
