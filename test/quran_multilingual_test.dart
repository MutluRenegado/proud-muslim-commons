import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/models/ayah_model.dart';
import 'package:deen_path/core/repositories/quran_edition_repository.dart';
import 'package:deen_path/core/services/quran_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await QuranCacheService.init();
  });

  group('Quran 14-Language Edition Repository Tests', () {
    test('Should have exactly 14 supported languages in V1', () {
      final langs = QuranEditionRepository.supportedLanguages;
      expect(langs.length, equals(14));

      final expectedCodes = [
        'ar', 'tr', 'en', 'de', 'fr', 'es', 'ur', 'id', 'ms', 'ru', 'fa', 'bn', 'hi', 'pt'
      ];
      for (final code in expectedCodes) {
        final found = langs.any((l) => l.code == code);
        expect(found, isTrue, reason: 'Language $code must be present');
      }
    });

    test('RTL flags must be correct (ar, ur, fa are RTL; others LTR)', () {
      final rtlCodes = {'ar', 'ur', 'fa'};
      for (final lang in QuranEditionRepository.supportedLanguages) {
        if (rtlCodes.contains(lang.code)) {
          expect(lang.isRtl, isTrue, reason: '${lang.englishName} should be RTL');
        } else {
          expect(lang.isRtl, isFalse, reason: '${lang.englishName} should be LTR');
        }
      }
    });

    test('Every language must have at least one approved and enabled edition', () {
      for (final lang in QuranEditionRepository.supportedLanguages) {
        final defaultEd = QuranEditionRepository.getDefaultEditionForLanguage(lang.code);
        expect(defaultEd, isNotNull, reason: 'Default edition for ${lang.englishName} should exist');
        expect(defaultEd!.approved, isTrue, reason: '${defaultEd.id} must be approved');
        expect(defaultEd.enabled, isTrue, reason: '${defaultEd.id} must be enabled');
        expect(defaultEd.translatorName.isNotEmpty, isTrue);
        expect(defaultEd.source.isNotEmpty, isTrue);
        expect(defaultEd.licenseStatus.isNotEmpty, isTrue);
      }
    });

    test('Turkish editions should be configurable and include Diyanet & Elmalili without Ali Bulac', () {
      final trEditions = QuranEditionRepository.getEditionsForLanguage('tr');
      expect(trEditions.length, greaterThanOrEqualTo(2));

      final diyanet = trEditions.firstWhere((e) => e.id == 'tur-diyanetisleri');
      expect(diyanet.approved, isTrue);
      expect(diyanet.enabled, isTrue);
      expect(diyanet.licenseStatus, contains('Separate Distribution Control'));

      final elmalili = trEditions.firstWhere((e) => e.id == 'tur-muhammedhamdiya');
      expect(elmalili.approved, isTrue);
      expect(elmalili.enabled, isTrue);

      // Verify Ali Bulaç is completely removed
      final bulacList = trEditions.where((e) => e.id == 'tur-alibulac' || e.translatorName.contains('Bulaç'));
      expect(bulacList.isEmpty, isTrue);
    });
  });

  group('Quran Cache Service Tests', () {
    test('Should cache and retrieve Surah verses correctly', () async {
      final sampleVerses = [
        {'chapter': 1, 'verse': 1, 'text': 'Test translation 1'},
        {'chapter': 1, 'verse': 2, 'text': 'Test translation 2'},
      ];

      expect(QuranCacheService.isSurahCached('test-edition', 1), isFalse);
      await QuranCacheService.saveSurahVerses('test-edition', 1, sampleVerses);

      expect(QuranCacheService.isSurahCached('test-edition', 1), isTrue);
      final retrieved = QuranCacheService.getCachedSurahVerses('test-edition', 1);
      expect(retrieved, isNotNull);
      expect(retrieved!.length, equals(2));
      expect(retrieved[0]['text'], equals('Test translation 1'));
    });
  });

  group('AyahModel Tests', () {
    test('AyahModel should carry translator and RTL metadata', () {
      final ayah = AyahModel(
        number: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'Rahman ve Rahim olan Allah\'ın adıyla',
        surahNumber: 1,
        translatorName: 'Diyanet İşleri',
        translationEditionId: 'tur-diyanetisleri',
        isRtlTranslation: false,
      );

      expect(ayah.number, equals(1));
      expect(ayah.translatorName, equals('Diyanet İşleri'));
      expect(ayah.isRtlTranslation, isFalse);

      final copy = ayah.copyWith(isRtlTranslation: true);
      expect(copy.isRtlTranslation, isTrue);
    });
  });
}
