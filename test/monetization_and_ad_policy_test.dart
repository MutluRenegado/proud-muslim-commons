import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_path/core/constants/app_constants.dart';
import 'package:deen_path/core/services/storage_service.dart';
import 'package:deen_path/core/services/subscription_service.dart';
import 'package:deen_path/core/services/ad_policy_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AppConstants.keyUserName: 'Standard User',
      AppConstants.keyUserEmail: 'standard.user@example.com',
      'is_subscribed': false,
      'subscription_status': 'free',
      AppConstants.keyCountry: 'United States',
      AppConstants.keyLanguageCode: 'en',
    });
    await StorageService.init();
  });

  group('PROUD MUSLIM FINAL MONETIZATION & AD POLICY TESTS', () {
    // TEST A: Normal User / Quran Reading -> FREE + NO ADS
    test('TEST A: Normal Free User in Quran Reading section sees NO ADS', () {
      expect(StorageService.hasAdFreeAccess, isFalse);
      final showAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionQuran,
      );
      expect(showAds, isFalse,
          reason: 'Quran Reading must remain 100% ad-free forever for everyone');
    });

    // TEST B: Normal User / Esmaul Husna -> FREE + NO ADS
    test('TEST B: Normal Free User in Esmaul Husna section sees NO ADS', () {
      expect(StorageService.hasAdFreeAccess, isFalse);
      final showAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionNamesOfAllah,
      );
      expect(showAds, isFalse,
          reason: 'Esmaul Husna must remain 100% ad-free forever for everyone');
    });

    // TEST C: Normal User / Other Features -> FREE + ADS (No paywalls)
    test('TEST C: Normal Free User on other features sees ADS (without paywalls)', () {
      expect(StorageService.hasAdFreeAccess, isFalse);
      final showPrayerAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionPrayer,
      );
      final showQiblaAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionQibla,
      );
      final showAzkarAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionAzkar,
      );
      final showHadithAds = AdPolicyService.shouldShowAds(
        section: AdPolicyService.sectionHadith,
      );

      expect(showPrayerAds, isTrue);
      expect(showQiblaAds, isTrue);
      expect(showAzkarAds, isTrue);
      expect(showHadithAds, isTrue);
    });

    // TEST D: Paid Ad-Free User -> ALL FEATURES + NO ADS
    test('TEST D: Paid Ad-Free Subscriber has NO ADS across the entire app', () async {
      await StorageService.setIsSubscribed(true);
      await StorageService.setSubscriptionStatus('activeAdFree');

      expect(StorageService.hasAdFreeAccess, isTrue);
      expect(StorageService.isPaidSubscribed, isTrue);

      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQuran), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionNamesOfAllah), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQibla), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionAzkar), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHome), isFalse);
    });

    // TEST E: akgnmutlu@gmail.com -> ALL FEATURES + NO ADS + NO PAYMENT
    test('TEST E: akgnmutlu@gmail.com receives permanent Ad-Free entitlement without payment', () async {
      await StorageService.setUserEmail('akgnmutlu@gmail.com');
      await StorageService.setIsSubscribed(false); // No payment required

      expect(StorageService.isPermanentAdFreeAccount, isTrue);
      expect(StorageService.hasAdFreeAccess, isTrue);

      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHome), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHadith), isFalse);
    });

    // TEST F: testingisamust32@gmail.com -> ALL FEATURES + NO ADS + VIEWER STATUS
    test('TEST F: testingisamust32@gmail.com receives Viewer test account entitlement without payment', () async {
      await StorageService.setUserEmail('testingisamust32@gmail.com');
      await StorageService.setIsSubscribed(false); // No payment required

      expect(StorageService.isViewerAccount, isTrue);
      expect(StorageService.isPermanentAdFreeAccount, isTrue);
      expect(StorageService.hasAdFreeAccess, isTrue);

      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHome), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionAzkar), isFalse);
    });

    // TEST G: Logout / Account Switch Isolation
    test('TEST G: Logout Isolation - Switching from permanent account to normal account resets entitlement', () async {
      // Step 1: Login with permanent account
      await StorageService.setUserEmail('akgnmutlu@gmail.com');
      expect(StorageService.hasAdFreeAccess, isTrue);

      // Step 2: Logout / reset
      await StorageService.logout();
      await StorageService.setUserEmail('unprivileged.user@gmail.com');

      // Step 3: Verify normal account returns to Free + Ads (except Quran & Esmaul Husna)
      expect(StorageService.isPermanentAdFreeAccount, isFalse);
      expect(StorageService.hasAdFreeAccess, isFalse);

      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQuran), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionNamesOfAllah), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isTrue);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHome), isTrue);
    });

    // TEST H: Subscription Expiry -> Features remain available, ads return
    test('TEST H: Subscription Expiry preserves feature access and returns ads on general features', () async {
      // User subscription expires
      await StorageService.setIsSubscribed(false);
      await StorageService.setSubscriptionStatus('expired');
      await StorageService.setUserEmail('expired.subscriber@example.com');

      expect(StorageService.hasAdFreeAccess, isFalse);
      // Quran & 99 Names still remain ad-free
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQuran), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionNamesOfAllah), isFalse);
      // Other features show ads
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isTrue);
    });

    // TEST I: Restore Purchases -> Valid subscriber regains Ad-Free status
    test('TEST I: Restore Purchases restores Ad-Free entitlement', () async {
      await StorageService.setIsSubscribed(true);
      final restored = await SubscriptionService.restorePurchases();
      expect(restored, isTrue);
      expect(StorageService.hasAdFreeAccess, isTrue);
      expect(StorageService.subscriptionStatus, 'activeAdFree');
    });

    // TEST J: USA Pricing Matrix ($4.59 first year, then $12.59/year)
    test('TEST J: USA Pricing Matrix targets \$4.59 first year then \$12.59/year', () async {
      await StorageService.saveLocation(38.8951, -77.0364, 'Washington', 'United States');
      await StorageService.setLanguageCode('en');

      final product = SubscriptionService.fallbackAnnualAdFreeProduct;
      expect(product.introPrice, AppConstants.formattedPriceIntroUsa);
      expect(product.regularPrice, AppConstants.formattedPriceAnnualRegularUsd);
      expect(product.billingPeriod, '12 months');
      expect(product.rawPrice, 4.59);
    });

    // TEST K: Europe Pricing Matrix (€4.59 equivalent first year, then €12.59/year)
    test('TEST K: Europe Pricing Matrix targets €4.59 first year then €12.59/year', () async {
      await StorageService.saveLocation(52.5200, 13.4050, 'Berlin', 'Germany');
      await StorageService.setLanguageCode('de');

      final product = SubscriptionService.fallbackAnnualAdFreeProduct;
      expect(product.introPrice, AppConstants.formattedPriceIntroEurope);
      expect(product.regularPrice, AppConstants.formattedPriceAnnualRegularEur);
      expect(product.billingPeriod, '12 months');
      expect(product.currencyCode, 'EUR');
      expect(product.rawPrice, 4.59);
    });

    // TEST L: Rest of World Pricing Matrix ($2.59 equivalent first year, then $12.59/year)
    test('TEST L: Rest of World Pricing Matrix targets \$2.59 first year then \$12.59/year', () async {
      await StorageService.saveLocation(-6.2088, 106.8456, 'Jakarta', 'Indonesia');
      await StorageService.setLanguageCode('id');

      final product = SubscriptionService.fallbackAnnualAdFreeProduct;
      expect(product.introPrice, AppConstants.formattedPriceIntroRow);
      expect(product.regularPrice, AppConstants.formattedPriceAnnualRegularUsd);
      expect(product.billingPeriod, '12 months');
      expect(product.currencyCode, 'USD');
      expect(product.rawPrice, 2.59);
    });
  });
}
