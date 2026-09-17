// azkar_data_service.dart
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/azkar_model.dart';

class AzkarDataService {
  static List<AzkarCategoryModel>? _cachedCategories;

  static Future<List<AzkarCategoryModel>> loadAzkar() async {
    if (_cachedCategories != null) return _cachedCategories!;
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/azkar_hisn.json',
      );
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final categories = list
          .map((e) => AzkarCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Keep the original Hisn al-Muslim dataset intact and layer the
      // prayer-specific Qur'an readings into the existing After Salah section.
      final afterSalahJson = await rootBundle.loadString(
        'assets/data/after_salah_quran.json',
      );
      final afterSalahList = jsonDecode(afterSalahJson) as List<dynamic>;
      final afterSalahItems = afterSalahList
          .map((e) => AzkarItemModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final categoryIndex = categories.indexWhere(
        (category) => category.categoryId == 'after_salah',
      );
      if (categoryIndex >= 0) {
        final category = categories[categoryIndex];
        categories[categoryIndex] = AzkarCategoryModel(
          categoryId: category.categoryId,
          categoryTitle: category.categoryTitle,
          icon: category.icon,
          categoryTitles: category.categoryTitles,
          items: [...afterSalahItems, ...category.items],
        );
      }

      _cachedCategories = categories;
      return _cachedCategories!;
    } catch (e) {
      return [];
    }
  }
}
