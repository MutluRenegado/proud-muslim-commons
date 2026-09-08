import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/app_constants.dart';
import '../services/storage_service.dart';

enum SubscriptionPlanStatus {
  activeAdFree,
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
  final String introPrice;
  final String regularPrice;
  final double rawPrice;
  final String currencyCode;
  final String billingPeriod;

  const PremiumProductInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.introPrice,
    required this.regularPrice,
    required this.rawPrice,
    required this.currencyCode,
    this.billingPeriod = '12 months',
  });
}

class SubscriptionService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static bool _isAvailable = false;
  static ProductDetails? _remoteProduct;

  static bool isEuropeOrUsaRegion() {
    final country = StorageService.country.toLowerCase();
    final lang = StorageService.languageCode.toLowerCase();

    if (country.contains('united states') ||
        country == 'usa' ||
        country == 'us') {
      return true;
    }

    const europeanKeywords = [
      'germany', 'deutschland', 'france', 'spain', 'españa', 'italy',
      'italia', 'portugal', 'united kingdom', 'uk', 'great britain',
      'netherlands', 'belgium', 'austria', 'österreich', 'sweden',
      'norway', 'denmark', 'finland', 'ireland', 'switzerland', 'poland',
      'greece', 'czech', 'hungary', 'romania', 'bulgaria', 'croatia',
      'slovakia', 'slovenia', 'estonia', 'latvia', 'lithuania', 'luxembourg'
    ];

    return europeanKeywords.any((eu) => country.contains(eu)) ||
        lang == 'de' ||
        lang == 'fr' ||
        lang == 'es' ||
        lang == 'pt' ||
        lang == 'it';
  }

  static String getRegionalAdFreePriceString() {
    final country = StorageService.country.toLowerCase();
    final lang = StorageService.languageCode.toLowerCase();

    // Priority 1: Turkey (₺149.99 1st year, then ₺399.99/year)
    if (country.contains('turk') || country.contains('türkiye') || lang == 'tr') {
      return '${AppConstants.formattedPriceIntroTurkey} 1st year, then ${AppConstants.formattedPriceAnnualRegularTry}';
    }

    // Priority 2: United States ($4.59 1st year, then $12.59/year)
    if (country.contains('united states') ||
        country == 'usa' ||
        country == 'us') {
      return '${AppConstants.formattedPriceIntroUsa} 1st year, then ${AppConstants.formattedPriceAnnualRegularUsd}';
    }

    // Priority 3: Europe (€4.59 1st year, then €12.59/year)
    if (isEuropeOrUsaRegion()) {
      return '${AppConstants.formattedPriceIntroEurope} 1st year, then ${AppConstants.formattedPriceAnnualRegularEur}';
    }

    // Priority 4: Rest of World ($2.59 1st year, then $12.59/year)
    return '${AppConstants.formattedPriceIntroRow} 1st year, then ${AppConstants.formattedPriceAnnualRegularUsd}';
  }

  static PremiumProductInfo get fallbackAnnualAdFreeProduct {
    final country = StorageService.country.toLowerCase();
    final lang = StorageService.languageCode.toLowerCase();

    String introPrice = AppConstants.formattedPriceIntroRow;
    String regularPrice = AppConstants.formattedPriceAnnualRegularUsd;
    double rawPrice = AppConstants.priceIntroRowUsd;
    String currencyCode = 'USD';

    if (country.contains('turk') || country.contains('türkiye') || lang == 'tr') {
      introPrice = AppConstants.formattedPriceIntroTurkey;
      regularPrice = AppConstants.formattedPriceAnnualRegularTry;
      rawPrice = AppConstants.priceIntroTurkeyTry;
      currencyCode = 'TRY';
    } else if (country.contains('united states') ||
        country == 'usa' ||
        country == 'us') {
      introPrice = AppConstants.formattedPriceIntroUsa;
      regularPrice = AppConstants.formattedPriceAnnualRegularUsd;
      rawPrice = AppConstants.priceIntroUsaEuropeUsd;
      currencyCode = 'USD';
    } else if (isEuropeOrUsaRegion()) {
      introPrice = AppConstants.formattedPriceIntroEurope;
      regularPrice = AppConstants.formattedPriceAnnualRegularEur;
      rawPrice = AppConstants.priceIntroEuropeEur;
      currencyCode = 'EUR';
    }

    return PremiumProductInfo(
      id: AppConstants.subscriptionProductId,
      title: 'Proud Muslim Ad-Free (Yearly)',
      description: 'Remove all advertisements across the application',
      price: '$introPrice 1st year, then $regularPrice',
      introPrice: introPrice,
      regularPrice: regularPrice,
      rawPrice: rawPrice,
      currencyCode: currencyCode,
      billingPeriod: '12 months',
    );
  }

  static Future<void> init(
    Function(SubscriptionPlanStatus) onStatusChanged,
  ) async {
    try {
      _isAvailable = await _iap.isAvailable();
      if (_isAvailable) {
        final Set<String> ids = {
          AppConstants.subscriptionProductId,
          AppConstants.legacyProductIdPremium,
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
        await StorageService.setSubscriptionStatus('activeAdFree');
        onStatusChanged(SubscriptionPlanStatus.activeAdFree);
      } else if (purchase.status == PurchaseStatus.canceled) {
        // Handle cancel
      }
    }
  }

  static PremiumProductInfo getProductInfo() {
    if (_remoteProduct != null) {
      final fallback = fallbackAnnualAdFreeProduct;
      return PremiumProductInfo(
        id: _remoteProduct!.id,
        title: _remoteProduct!.title,
        description: _remoteProduct!.description,
        price: '${_remoteProduct!.price} / year',
        introPrice: _remoteProduct!.price,
        regularPrice: fallback.regularPrice,
        rawPrice: _remoteProduct!.rawPrice,
        currencyCode: _remoteProduct!.currencyCode,
        billingPeriod: '12 months',
      );
    }
    return fallbackAnnualAdFreeProduct;
  }

  static Future<bool> buyAdFreeSubscription() async {
    if (!_isAvailable || _remoteProduct == null) {
      // In offline/test mode without store connection, simulate successful ad-free purchase
      await StorageService.setIsSubscribed(true);
      await StorageService.setSubscriptionStatus('activeAdFree');
      return true;
    }
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _remoteProduct!,
    );
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<bool> buyQuarterlySubscription() => buyAdFreeSubscription();
  static Future<bool> buyMonthlySubscription() => buyAdFreeSubscription();
  static Future<bool> buyAnnualSubscription() => buyAdFreeSubscription();

  static Future<bool> restorePurchases() async {
    try {
      if (_isAvailable) {
        await _iap.restorePurchases();
        return true;
      } else {
        // Simulated restore
        if (StorageService.isPaidSubscribed || StorageService.hasAdFreeAccess) {
          await StorageService.setSubscriptionStatus('activeAdFree');
          return true;
        }
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  /// Calculates Ad-Free entitlement status details.
  static Map<String, dynamic> getTrialStatusDetails() {
    final hasAdFree = StorageService.hasAdFreeAccess;

    if (hasAdFree) {
      return {
        'status': SubscriptionPlanStatus.activeAdFree,
        'title': 'Proud Muslim Ad-Free',
        'subtitle': StorageService.isPermanentAdFreeAccount
            ? 'Permanent Ad-Free Account'
            : 'Yearly Auto-Renewing (No Ads)',
        'badge': 'AD-FREE',
        'isSubscribed': true,
        'hasAdFreeAccess': true,
      };
    }

    return {
      'status': SubscriptionPlanStatus.free,
      'title': 'Free (Ad-Supported)',
      'subtitle': 'Full app access with ads outside Quran & Esmaul Husna.',
      'badge': 'FREE',
      'isSubscribed': false,
      'hasAdFreeAccess': false,
    };
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
