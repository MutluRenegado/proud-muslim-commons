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
      _cachedCategories = list
          .map((e) => AzkarCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cachedCategories!;
    } catch (e) {
      return [];
    }
  }
}
