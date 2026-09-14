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

  group('PROUD MUSLIM FREE + PREMIUM & AD POLICY TESTS', () {
    // TEST 1: Zero Ads Everywhere
    test('TEST 1: App is 100% Ad-Free across all sections for all users', () {
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQuran), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionNamesOfAllah), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionPrayer), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionQibla), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionAzkar), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHadith), isFalse);
      expect(AdPolicyService.shouldShowAds(section: AdPolicyService.sectionHome), isFalse);
    });

    // TEST 2: Free Tier User
    test('TEST 2: Normal Free User has Free status and no Premium access by default', () {
      expect(StorageService.hasPremiumAccess, isFalse);
      expect(StorageService.isPaidSubscribed, isFalse);
      expect(StorageService.hasActiveTrial, isFalse);

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.free);
      expect(details['hasPremiumAccess'], isFalse);
    });

    // TEST 3: Paid Premium Subscriber ($3.99/mo or $29.99/yr)
    test('TEST 3: Paid Premium Subscriber unlocks full Premium access and counts in paid analytics', () async {
      await StorageService.setIsSubscribed(true);
      await StorageService.setSubscriptionStatus('activePremium');

      expect(StorageService.hasPremiumAccess, isTrue);
      expect(StorageService.isPaidSubscribed, isTrue);

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.activePremium);
      expect(details['hasPremiumAccess'], isTrue);
      expect(details['isRealPaidSubscriber'], isTrue);
    });

    // TEST 4: 3-Day Free Trial
    test('TEST 4: 3-Day Free Trial unlocks Premium access during trial and does not count as paid subscriber', () async {
      await StorageService.startFreeTrial();

      expect(StorageService.hasActiveTrial, isTrue);
      expect(StorageService.hasPremiumAccess, isTrue);
      expect(StorageService.trialDaysRemaining, inInclusiveRange(1, 3));

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.activeTrial);
      expect(details['hasPremiumAccess'], isTrue);
      expect(details['isRealPaidSubscriber'], isFalse);
    });

    // TEST 5: akgnmutlu@gmail.com Permanent Test Account
    test('TEST 5: akgnmutlu@gmail.com has unrestricted access without payment', () async {
      await StorageService.setUserEmail('akgnmutlu@gmail.com');
      await StorageService.setIsSubscribed(false); // No payment required

      expect(StorageService.isPermanentTestingAccount, isTrue);
      expect(StorageService.hasPremiumAccess, isTrue);

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.testingAccount);
      expect(details['hasPremiumAccess'], isTrue);
      expect(details['isRealPaidSubscriber'], isFalse);
    });

    // TEST 6: testingisamust32@gmail.com Permanent Test Account
    test('TEST 6: testingisamust32@gmail.com has unrestricted access without payment', () async {
      await StorageService.setUserEmail('testingisamust32@gmail.com');
      await StorageService.setIsSubscribed(false); // No payment required

      expect(StorageService.isPermanentTestingAccount, isTrue);
      expect(StorageService.hasPremiumAccess, isTrue);

      final details = SubscriptionService.getTrialStatusDetails();
      expect(details['status'], SubscriptionPlanStatus.testingAccount);
      expect(details['hasPremiumAccess'], isTrue);
      expect(details['isRealPaidSubscriber'], isFalse);

      // Reset / login as normal user
      await StorageService.setUserEmail('normal.user@example.com');
      expect(StorageService.isPermanentTestingAccount, isFalse);
      expect(StorageService.hasPremiumAccess, isFalse);
    });

    // TEST 7: Pricing and Product Configurations
    test('TEST 7: Pricing and 3-Day Trial configuration matches specification', () {
      expect(AppConstants.priceMonthlyUsd, 3.99);
      expect(AppConstants.priceAnnualUsd, 29.99);
      expect(AppConstants.trialDurationDays, 3);
      expect(AppConstants.productIdPremiumMonthly, 'proud_muslim_premium_monthly');
      expect(AppConstants.productIdPremiumAnnual, 'proud_muslim_premium_annual');
    });
  });
}
