import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/core/services/prayer_calculation_service.dart';
import 'package:deen_path/models/prayer_time_model.dart';

void main() {
  group('Prayer Calculation Tests', () {
    test('Calculates valid prayer times for Makkah', () {
      final date = DateTime(2026, 8, 28);
      const lat = 21.4225;
      const lng = 39.8262;

      final times = PrayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: lat,
        longitude: lng,
        method: CalculationMethod.ummAlQuraMakkah,
      );

      expect(times.fajr.isBefore(times.sunrise), isTrue);
      expect(times.sunrise.isBefore(times.dhuhr), isTrue);
      expect(times.dhuhr.isBefore(times.asr), isTrue);
      expect(times.asr.isBefore(times.maghrib), isTrue);
      expect(times.maghrib.isBefore(times.isha), isTrue);
    });

    test('Hanafi juristic method delays Asr prayer time', () {
      final date = DateTime(2026, 8, 28);
      const lat = 51.5074;
      const lng = -0.1278;

      final standardTimes = PrayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: lat,
        longitude: lng,
        juristic: JuristicMethod.standard,
      );

      final hanafiTimes = PrayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: lat,
        longitude: lng,
        juristic: JuristicMethod.hanafi,
      );

      expect(hanafiTimes.asr.isAfter(standardTimes.asr), isTrue);
    });
  });
}
