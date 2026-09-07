import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_path/core/constants/app_theme.dart';
import 'package:deen_path/core/services/storage_service.dart';
import 'package:deen_path/core/services/prayer_calculation_service.dart';
import 'package:deen_path/core/services/subscription_service.dart';
import 'package:deen_path/models/prayer_time_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:deen_path/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({
      AppConstants.keyUserName: 'Ahmad',
      AppConstants.keyUserEmail: 'ahmad@example.com',
      AppConstants.keyThemeMode: true,
      AppConstants.keyThemePreference: 'dark',
      AppConstants.keyAzanEnabled: true,
      AppConstants.keyAzanSound: 'Makkah Azan',
      AppConstants.keyAzanVolume: 0.9,
      AppConstants.keyLat: 51.5074,
      AppConstants.keyLng: -0.1278,
      AppConstants.keyCity: 'London',
      AppConstants.keyCountry: 'United Kingdom',
      AppConstants.keyLocationMode: 'auto',
      AppConstants.keyHighLatitudeRule: 'middleOfTheNight',
      AppConstants.keyRoundingMethod: 'nearestMinute',
      AppConstants.keyPrayerNotificationToggles: '{"Fajr": true, "Sunrise": false}',
    });
    await StorageService.init();
  });

  group('Profile Settings & Storage Tests', () {
    test('Reads and writes user profile name and email', () async {
      expect(StorageService.userName, 'Ahmad');
      expect(StorageService.userEmail, 'ahmad@example.com');

      await StorageService.setUserName('Muhammad');
      await StorageService.setUserEmail('muhammad@example.com');

      expect(StorageService.userName, 'Muhammad');
      expect(StorageService.userEmail, 'muhammad@example.com');
    });

    test('Azan settings persist correctly', () async {
      expect(StorageService.azanEnabled, isTrue);
      expect(StorageService.azanSound, 'Makkah Azan');
      expect(StorageService.azanVolume, 0.9);

      await StorageService.setAzanSound('Madinah Azan');
      await StorageService.setAzanVolume(0.75);

      expect(StorageService.azanSound, 'Madinah Azan');
      expect(StorageService.azanVolume, 0.75);
    });

    test('Individual prayer notification toggles persist', () async {
      final toggles = StorageService.getPrayerNotificationToggles();
      expect(toggles['fajr'], isTrue);
      expect(toggles['sunrise'], isFalse);

      toggles['sunrise'] = true;
      await StorageService.savePrayerNotificationToggles(toggles);

      final updated = StorageService.getPrayerNotificationToggles();
      expect(updated['sunrise'], isTrue);
    });

    test('Four Dynamic Themes persist and switch seamlessly', () async {
      await StorageService.setAppThemeType('theme1');
      expect(StorageService.appThemeType, 'theme1');

      await StorageService.setAppThemeType('theme2');
      expect(StorageService.appThemeType, 'theme2');

      await StorageService.setAppThemeType('theme3');
      expect(StorageService.appThemeType, 'theme3');

      await StorageService.setAppThemeType('theme4');
      expect(StorageService.appThemeType, 'theme4');
    });

    test('All 4 Theme types have valid metadata and properties', () {
      for (final type in AppThemeType.values) {
        expect(type.title.isNotEmpty, isTrue);
        expect(type.subtitle.isNotEmpty, isTrue);
        expect(type.previewPrimary, isNotNull);
        expect(type.previewBackground, isNotNull);
        expect(type.headerGradient, isNotNull);
        expect(type.isDark, isIn([true, false]));
      }
    });

    test('Adhan/Ezan settings remain frozen and functional', () async {
      expect(StorageService.azanSound, 'Makkah Azan');
      expect(StorageService.azanEnabled, isTrue);
    });
  });

  group('High Latitude & Rounding Calculation Tests', () {
    test('Calculates prayer times with High Latitude Rule: middleOfTheNight', () {
      final date = DateTime(2026, 6, 21); // Summer solstice in high latitude London
      const lat = 51.5074;
      const lng = -0.1278;

      final times = PrayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: lat,
        longitude: lng,
        method: CalculationMethod.muslimWorldLeague,
        highLatitude: HighLatitudeRule.middleOfTheNight,
        rounding: RoundingMethod.nearestMinute,
      );

      expect(times.fajr.isBefore(times.sunrise), isTrue);
      expect(times.maghrib.isBefore(times.isha), isTrue);
    });

    test('Precision rounding produces integer minute timestamps', () {
      final date = DateTime(2026, 8, 28);
      const lat = 21.4225;
      const lng = 39.8262;

      final timesNearest = PrayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: lat,
        longitude: lng,
        rounding: RoundingMethod.nearestMinute,
      );

      expect(timesNearest.fajr.second, 0);
      expect(timesNearest.dhuhr.second, 0);
      expect(timesNearest.asr.second, 0);
      expect(timesNearest.maghrib.second, 0);
      expect(timesNearest.isha.second, 0);
    });
  });

  group('Subscription & 3-Day Trial Tests', () {
    test('Trial status calculation reflects 3-day window', () async {
      final now = DateTime.now();
      await StorageService.setTrialDates(now, now.add(const Duration(days: 3)));
      await StorageService.setIsSubscribed(false);
      await StorageService.setSubscriptionStatus('inTrial');

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.inTrial);
      expect(details['daysLeft'], inInclusiveRange(1, 3));
      expect(details['isTrial'], isTrue);
      expect(details['isSubscribed'], isFalse);
    });

    test('Active premium subscription status overrides trial', () async {
      await StorageService.setIsSubscribed(true);
      await StorageService.setSubscriptionStatus('activePremium');

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.activePremium);
      expect(details['isSubscribed'], isTrue);
      expect(details['isTrial'], isFalse);
    });
  });
}
