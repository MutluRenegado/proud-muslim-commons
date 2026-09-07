import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/models/allah_name_model.dart';
import 'package:deen_path/core/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('99 Names of Allah Audio & Data System Tests', () {
    late List<AllahNameModel> names;
    late List<dynamic> rawJson;

    setUpAll(() {
      final file = File('assets/data/names_of_allah.json');
      expect(file.existsSync(), isTrue, reason: 'assets/data/names_of_allah.json must exist');
      final jsonStr = file.readAsStringSync();
      rawJson = jsonDecode(jsonStr) as List<dynamic>;
      names = rawJson.map((e) => AllahNameModel.fromJson(e as Map<String, dynamic>)).toList();
    });

    test('Must have exactly 99 Names of Allah', () {
      expect(names.length, equals(99));
    });

    test('Every Name from 1 to 99 must have complete data and audio fields', () {
      for (int i = 0; i < 99; i++) {
        final name = names[i];
        final num = i + 1;

        expect(name.number, equals(num), reason: 'Name index $i should have number $num');
        expect(name.arabic.isNotEmpty, isTrue, reason: 'Name #$num arabic text cannot be empty');
        expect(name.transliteration.isNotEmpty, isTrue, reason: 'Name #$num transliteration cannot be empty');
        expect(name.meaning.isNotEmpty, isTrue, reason: 'Name #$num master English meaning cannot be empty');
        expect(name.explanation.isNotEmpty, isTrue, reason: 'Name #$num master English explanation cannot be empty');

        // Check Audio 1 (Native Arabic Pronunciation)
        expect(name.arabicNativeAudio, isNotNull);
        expect(name.arabicNativeAudio!.contains('arabic_pronunciation'), isTrue);

        // Check Audio 3 (Turkish Pronunciation identifier)
        expect(name.turkishPronunciationAudio, isNotNull);

        // Check Audio 2 & 4 (Localized explanations)
        expect(name.getMeaning('en').isNotEmpty, isTrue);
        expect(name.getExplanation('en').isNotEmpty, isTrue);
        expect(name.getMeaning('tr').isNotEmpty, isTrue);
        expect(name.getExplanation('tr').isNotEmpty, isTrue);

        // Check localized mapping for all supported app languages
        for (final lang in ['en', 'tr', 'ar', 'de', 'fr', 'es', 'id', 'ms', 'pt', 'ru', 'ur']) {
          expect(name.getMeaning(lang).isNotEmpty, isTrue, reason: 'Meaning for $lang in #$num cannot be empty');
          expect(name.getExplanation(lang).isNotEmpty, isTrue, reason: 'Explanation for $lang in #$num cannot be empty');
        }
      }
    });

    test('Verify Name #84 (Malik-ul-Mulk) Data Integrity', () {
      final name84 = names.firstWhere((n) => n.number == 84);
      expect(name84.arabic, contains('مَالِكُ الْمُلْكِ'));
      expect(name84.transliteration, contains('Mālik'));
      expect(name84.meaning.toLowerCase(), anyOf([contains('dominion'), contains('sovereignty'), contains('owner')]));
      expect(name84.getMeaning('tr').toLowerCase(), contains('mülk'));
      expect(name84.arabicNativeAudio, contains('84.mp3'));
    });

    test('Verify Name #85 (Dhul-Jalali wal-Ikram) Data Integrity', () {
      final name85 = names.firstWhere((n) => n.number == 85);
      expect(name85.arabic, contains('ذُو الْجَلَالِ'));
      expect(name85.transliteration, contains('Jalāl'));
      expect(name85.meaning.toLowerCase(), anyOf([contains('majesty'), contains('generosity'), contains('honor')]));
      expect(name85.getMeaning('tr').toLowerCase(), anyOf([contains('azamet'), contains('celal'), contains('ikram')]));
      expect(name85.arabicNativeAudio, contains('85.mp3'));
    });

    test('Verify physical existence of all 99 Native Arabic Pronunciation audio assets', () {
      for (int i = 1; i <= 99; i++) {
        final path = 'assets/audio/names/arabic_pronunciation/$i.mp3';
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: 'Asset $path must physically exist on disk');
        expect(file.lengthSync(), greaterThan(1000), reason: 'Audio file $path should not be empty');
      }
    });

    test('Verify physical existence of all 99 English Explanation narration audio assets', () {
      for (int i = 1; i <= 99; i++) {
        final num = 1000 + i;
        final path = 'assets/audio/names/english_explanation/$num.mp3';
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: 'Asset $path must physically exist on disk');
        expect(file.lengthSync(), greaterThan(1000), reason: 'Audio file $path should not be empty');
      }
    });

    test('AudioService single-stream state transitions & stop method', () async {
      expect(AudioService.isPlaying, isFalse);
      expect(AudioService.currentPlayingIdNotifier.value, isNull);

      await AudioService.stop();
      expect(AudioService.isPlaying, isFalse);
      expect(AudioService.currentAudioId, isNull);
    });

    test('TTS Locale resolution matches 11 supported languages', () {
      expect(AudioService.getTtsLocale('en'), equals('en-US'));
      expect(AudioService.getTtsLocale('tr'), equals('tr-TR'));
      expect(AudioService.getTtsLocale('ar'), equals('ar-SA'));
      expect(AudioService.getTtsLocale('de'), equals('de-DE'));
      expect(AudioService.getTtsLocale('fr'), equals('fr-FR'));
      expect(AudioService.getTtsLocale('es'), equals('es-ES'));
      expect(AudioService.getTtsLocale('ru'), equals('ru-RU'));
      expect(AudioService.getTtsLocale('ur'), equals('ur-PK'));
      expect(AudioService.getTtsLocale('id'), equals('id-ID'));
      expect(AudioService.getTtsLocale('ms'), equals('ms-MY'));
      expect(AudioService.getTtsLocale('pt'), equals('pt-PT'));
    });
  });
}
