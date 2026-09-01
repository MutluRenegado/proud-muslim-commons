// tasbih_model.dart
class DhikrPreset {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final int defaultTarget;

  const DhikrPreset({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.defaultTarget,
  });
}

// zakat_model.dart
class ZakatCalculation {
  final double cash;
  final double goldGrams;
  final double goldPricePerGram;
  final double silverGrams;
  final double silverPricePerGram;
  final double stocksAndInvestments;
  final double businessGoods;
  final double moneyOwedToYou;
  final double immediateDebts;
  final double expenses;
  final String currency;

  ZakatCalculation({
    this.cash = 0,
    this.goldGrams = 0,
    this.goldPricePerGram = 75.0,
    this.silverGrams = 0,
    this.silverPricePerGram = 0.95,
    this.stocksAndInvestments = 0,
    this.businessGoods = 0,
    this.moneyOwedToYou = 0,
    this.immediateDebts = 0,
    this.expenses = 0,
    this.currency = 'USD',
  });

  double get goldNisabThreshold => 87.48 * goldPricePerGram;
  double get silverNisabThreshold => 612.36 * silverPricePerGram;

  double get totalAssets =>
      cash +
      (goldGrams * goldPricePerGram) +
      (silverGrams * silverPricePerGram) +
      stocksAndInvestments +
      businessGoods +
      moneyOwedToYou;

  double get totalDeductions => immediateDebts + expenses;

  double get netZakatableWealth {
    final net = totalAssets - totalDeductions;
    return net > 0 ? net : 0;
  }

  bool get isNisabReached => netZakatableWealth >= goldNisabThreshold;

  double get zakatPayable => isNisabReached ? netZakatableWealth * 0.025 : 0.0;
}

// islamic_event_model.dart
class IslamicEventModel {
  final String title;
  final String titleArabic;
  final String hijriDate;
  final String description;
  final String category;
  final int month;
  final int day;
  final Map<String, dynamic>? translations;

  IslamicEventModel({
    required this.title,
    this.titleArabic = '',
    required this.hijriDate,
    required this.description,
    required this.category,
    required this.month,
    required this.day,
    this.translations,
  });

  String getLocalizedTitle(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['title'] ?? title) as String;
    }
    return title;
  }

  String getLocalizedDescription(String langCode) {
    if (translations != null && translations!.containsKey(langCode)) {
      final t = translations![langCode] as Map<String, dynamic>;
      return (t['description'] ?? description) as String;
    }
    return description;
  }
}

// masjid_model.dart
class MasjidModel {
  final String name;
  final String address;
  final double distanceKm;
  final String prayerTimesInfo;
  final bool hasWuduArea;
  final bool hasWomenSection;
  final bool hasParking;
  final double rating;

  MasjidModel({
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.prayerTimesInfo,
    this.hasWuduArea = true,
    this.hasWomenSection = true,
    this.hasParking = true,
    this.rating = 4.9,
  });
}
