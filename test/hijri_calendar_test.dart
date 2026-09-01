import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/core/services/hijri_calendar_service.dart';

void main() {
  group('Hijri Calendar Tests', () {
    test('Converts Gregorian date to Hijri output with valid format', () {
      final res = HijriCalendarService.gregorianToHijri(DateTime(2026, 8, 28));
      expect(res['year'], greaterThan(1440));
      expect(res['month'], inInclusiveRange(1, 12));
      expect(res['day'], inInclusiveRange(1, 30));
      expect(res['formatted'], contains('AH'));
      expect(res['formattedArabic'], contains('هـ'));
    });

    test('Returns non-empty list of major Islamic events', () {
      final events = HijriCalendarService.getIslamicEvents();
      expect(events.length, greaterThanOrEqualTo(8));
      expect(events.any((e) => e.title.contains('Ramadan')), isTrue);
      expect(events.any((e) => e.title.contains('Eid al-Fitr')), isTrue);
    });
  });
}
