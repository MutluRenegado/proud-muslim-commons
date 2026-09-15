import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offline prayer explanations cover 18 entries in all 11 languages', () {
    final file = File('assets/data/prayer_time_explanations.json');
    expect(file.existsSync(), isTrue);
    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final languages = data['languages'] as Map<String, dynamic>;
    expect(languages.keys.toSet(), equals({
      'en', 'tr', 'ar', 'de', 'fr', 'es', 'pt', 'ru', 'id', 'ur', 'ms',
    }));
    for (final value in languages.values) {
      final content = value as Map<String, dynamic>;
      expect(content['names'], hasLength(18));
      expect(content['shortTexts'], hasLength(18));
      expect(content['longTexts'], hasLength(18));
    }
    expect(data['references'], hasLength(18));
    expect(data['sources'], hasLength(15));
  });
}
