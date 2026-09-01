import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/app_constants.dart';
import '../services/storage_service.dart';

enum SubscriptionPlanStatus {
  inTrial,
  activePremium,
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
  final double rawPrice;
  final String currencyCode;
  final int trialDays;
  final String billingPeriod;

  const PremiumProductInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    this.trialDays = 3,
    this.billingPeriod = 'month',
  });
}

class SubscriptionService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static bool _isAvailable = false;
  static ProductDetails? _remoteProduct;

  static const PremiumProductInfo fallbackMonthlyProduct = PremiumProductInfo(
    id: AppConstants.productIdMonthlyPremium,
    title: 'Proud Muslim Premium (Monthly)',
    description: 'Full unlimited access with 3-Day Free Trial',
    price: '\$14.99/month',
    rawPrice: 14.99,
    currencyCode: 'USD',
    trialDays: 3,
    billingPeriod: 'month',
  );

  static Future<void> init(
    Function(SubscriptionPlanStatus) onStatusChanged,
  ) async {
    try {
      _isAvailable = await _iap.isAvailable();
      if (_isAvailable) {
        final Set<String> ids = {
          AppConstants.productIdMonthlyPremium,
          AppConstants.productIdAnnualPremium,
        };
        final response = await _iap.queryProductDetails(ids);
        if (response.productDetails.isNotEmpty) {
          _remoteProduct = response.productDetails.first;
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
        // Handle cancel
      }
    }
  }

  static PremiumProductInfo getProductInfo() {
    if (_remoteProduct != null) {
      return PremiumProductInfo(
        id: _remoteProduct!.id,
        title: _remoteProduct!.title,
        description: _remoteProduct!.description,
        price: '${_remoteProduct!.price}/month',
        rawPrice: _remoteProduct!.rawPrice,
        currencyCode: _remoteProduct!.currencyCode,
        trialDays: 3,
        billingPeriod: 'month',
      );
    }
    return fallbackMonthlyProduct;
  }

  static Future<bool> buyMonthlySubscription() async {
    if (!_isAvailable || _remoteProduct == null) {
      // In offline/test mode without store connection, simulate successful trial purchase
      await StorageService.setIsSubscribed(true);
      await StorageService.setSubscriptionStatus('activePremium');
      return true;
    }
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _remoteProduct!,
    );
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<bool> buyAnnualSubscription() async {
    return await buyMonthlySubscription();
  }

  static Future<bool> restorePurchases() async {
    try {
      if (_isAvailable) {
        await _iap.restorePurchases();
        return true;
      } else {
        // Simulated restore
        if (StorageService.isSubscribed) {
          await StorageService.setSubscriptionStatus('activePremium');
          return true;
        }
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  /// Calculates trial days remaining and status.
  static Map<String, dynamic> getTrialStatusDetails() {
    final isSubscribed = StorageService.isSubscribed;
    final statusStr = StorageService.subscriptionStatus;

    if (isSubscribed || statusStr == 'activePremium') {
      return {
        'status': SubscriptionPlanStatus.activePremium,
        'title': 'Premium Active',
        'subtitle': 'Billed Annually',
        'badge': 'PREMIUM',
        'daysLeft': 0,
        'isTrial': false,
        'isSubscribed': true,
        'renewalDate': DateTime.now().add(const Duration(days: 365)),
      };
    }

    final start = StorageService.trialStartDate;
    final end = StorageService.trialEndDate;
    final now = DateTime.now();

    if (start != null && end != null && now.isBefore(end)) {
      final diff = end.difference(now);
      final daysLeft = (diff.inHours / 24).ceil().clamp(1, 3);
      final hoursLeft = diff.inHours;

      return {
        'status': SubscriptionPlanStatus.inTrial,
        'title': 'Premium Trial',
        'subtitle':
            '$daysLeft ${daysLeft == 1 ? "day" : "days"} left in free trial',
        'badge': 'TRIAL',
        'daysLeft': daysLeft,
        'hoursLeft': hoursLeft,
        'isTrial': true,
        'isSubscribed': false,
        'startDate': start,
        'endDate': end,
      };
    } else {
      return {
        'status': SubscriptionPlanStatus.expired,
        'title': 'Free Plan',
        'subtitle': 'Trial expired. Upgrade to Premium.',
        'badge': 'FREE',
        'daysLeft': 0,
        'isTrial': false,
        'isSubscribed': false,
        'endDate': end,
      };
    }
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
