import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/app_constants.dart';
import '../services/storage_service.dart';

enum SubscriptionPlanStatus {
  activePremium,
  activeTrial,
  testingAccount,
  free,
  expired,
  pending,
  gracePeriod,
  accountHold,
  cancelled,
}

class PremiumProductInfo {
  final String id;
  final String title;
  final String description;
  final String price;
  final String trialText;
  final double rawPrice;
  final String currencyCode;
  final String billingPeriod;
  final bool isBestValue;

  const PremiumProductInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.trialText = AppConstants.formattedTrialDuration,
    required this.rawPrice,
    required this.currencyCode,
    required this.billingPeriod,
    this.isBestValue = false,
  });
}

class SubscriptionService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static bool _isAvailable = false;
  static final Map<String, ProductDetails> _remoteProducts = {};

  static PremiumProductInfo get fallbackMonthlyProduct => const PremiumProductInfo(id: AppConstants.productIdPremiumMonthly, title: 'Monthly Premium', description: 'Price supplied by Google Play', price: 'Unavailable', trialText: '', rawPrice: 0, currencyCode: '', billingPeriod: '1 month');

  static PremiumProductInfo get fallbackAnnualProduct => const PremiumProductInfo(id: AppConstants.productIdPremiumAnnual, title: 'Annual Premium', description: 'Price supplied by Google Play', price: 'Unavailable', trialText: '', rawPrice: 0, currencyCode: '', billingPeriod: '12 months', isBestValue: true);

  static Future<void> init(
    Function(SubscriptionPlanStatus) onStatusChanged,
  ) async {
    try {
      _isAvailable = await _iap.isAvailable();
      if (_isAvailable) {
        final Set<String> ids = {
          AppConstants.productIdPremiumMonthly,
          AppConstants.productIdPremiumAnnual,
          AppConstants.subscriptionProductId,
          AppConstants.legacyProductIdPremium,
        };
        final response = await _iap.queryProductDetails(ids);
        for (final product in response.productDetails) {
          _remoteProducts[product.id] = product;
        }

        _subscription = _iap.purchaseStream.listen(
          (purchases) => _handlePurchaseUpdates(purchases, onStatusChanged),
          onDone: () => _subscription?.cancel(),
          onError: (error) {
            debugPrint('IAP stream error: $error');
          },
        );
      }
    } catch (e) {
      debugPrint('Error initializing IAP: $e');
    }
  }

  static void _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
    Function(SubscriptionPlanStatus) onStatusChanged,
  ) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        onStatusChanged(SubscriptionPlanStatus.pending);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error}');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Validate purchase & complete
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        await StorageService.setIsSubscribed(true);
        await StorageService.setSubscriptionStatus('activePremium');
        onStatusChanged(SubscriptionPlanStatus.activePremium);
      } else if (purchase.status == PurchaseStatus.canceled) {
        // User canceled purchase
      }
    }
  }

  static PremiumProductInfo getMonthlyProductInfo() {
    final remote = _remoteProducts[AppConstants.productIdPremiumMonthly];
    if (remote != null) {
      return PremiumProductInfo(
        id: remote.id,
        title: remote.title,
        description: remote.description,
        price: '${remote.price}/month',
        trialText: AppConstants.formattedTrialDuration,
        rawPrice: remote.rawPrice,
        currencyCode: remote.currencyCode,
        billingPeriod: '1 month',
        isBestValue: false,
      );
    }
    return fallbackMonthlyProduct;
  }

  static PremiumProductInfo getAnnualProductInfo() {
    final remote = _remoteProducts[AppConstants.productIdPremiumAnnual] ??
        _remoteProducts[AppConstants.subscriptionProductId];
    if (remote != null) {
      return PremiumProductInfo(
        id: remote.id,
        title: remote.title,
        description: remote.description,
        price: '${remote.price}/year',
        trialText: AppConstants.formattedTrialDuration,
        rawPrice: remote.rawPrice,
        currencyCode: remote.currencyCode,
        billingPeriod: '12 months',
        isBestValue: true,
      );
    }
    return fallbackAnnualProduct;
  }

  static Future<bool> buyMonthlySubscription() async {
    final product = _remoteProducts[AppConstants.productIdPremiumMonthly];
    if (!_isAvailable || product == null) { return false; }
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<bool> buyAnnualSubscription() async {
    final product = _remoteProducts[AppConstants.productIdPremiumAnnual] ??
        _remoteProducts[AppConstants.subscriptionProductId];
    if (!_isAvailable || product == null) { return false; }
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<bool> buyAdFreeSubscription() => buyAnnualSubscription();

  static Future<bool> restorePurchases() async {
    try {
      if (_isAvailable) {
        await _iap.restorePurchases();
        return true;
      } else {
        if (StorageService.isPaidSubscribed || StorageService.isPermanentTestingAccount) {
          await StorageService.setSubscriptionStatus('activePremium');
          return true;
        }
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  /// Calculates authoritative entitlement status details
  static Map<String, dynamic> getTrialStatusDetails() {
    if (StorageService.isPermanentTestingAccount) {
      return {
        'status': SubscriptionPlanStatus.testingAccount,
        'title': 'Internal Testing Account',
        'subtitle': 'Full unrestricted access to all Free & Premium features.',
        'badge': 'TESTER',
        'isSubscribed': true,
        'hasPremiumAccess': true,
        'isRealPaidSubscriber': false,
      };
    }

    if (StorageService.isPaidSubscribed) {
      return {
        'status': SubscriptionPlanStatus.activePremium,
        'title': 'Proud Muslim Premium',
        'subtitle': 'Active Store Subscription (Unlimited AI Narration & Audio)',
        'badge': 'PREMIUM',
        'isSubscribed': true,
        'hasPremiumAccess': true,
        'isRealPaidSubscriber': true,
      };
    }

    if (StorageService.hasActiveTrial) {
      final days = StorageService.trialDaysRemaining;
      return {
        'status': SubscriptionPlanStatus.activeTrial,
        'title': '3-Day Free Trial Active',
        'subtitle': '$days day${days == 1 ? '' : 's'} remaining in your complimentary trial.',
        'badge': 'TRIAL',
        'isSubscribed': true,
        'hasPremiumAccess': true,
        'isRealPaidSubscriber': false,
      };
    }

    return {
      'status': SubscriptionPlanStatus.free,
      'title': 'Free Tier',
      'subtitle': 'Quran reading, translations and the 99 Names are free. Other features require Google Play Premium.',
      'badge': 'FREE',
      'isSubscribed': false,
      'hasPremiumAccess': false,
      'isRealPaidSubscriber': false,
    };
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
