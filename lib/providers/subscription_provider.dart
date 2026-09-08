import 'package:flutter/material.dart';

import '../core/services/subscription_service.dart';
import '../core/services/storage_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlanStatus _status = SubscriptionPlanStatus.free;
  PremiumProductInfo _productInfo =
      SubscriptionService.fallbackAnnualAdFreeProduct;
  Map<String, dynamic> _adFreeDetails = {};
  bool _isLoading = false;

  SubscriptionPlanStatus get status => _status;
  PremiumProductInfo get productInfo => _productInfo;
  Map<String, dynamic> get trialDetails => _adFreeDetails;
  Map<String, dynamic> get adFreeDetails => _adFreeDetails;
  bool get isLoading => _isLoading;

  /// Returns true if the user is entitled to ad-free access (Paid subscriber or Permanent Ad-Free Account)
  bool get hasAdFreeAccess =>
      _status == SubscriptionPlanStatus.activeAdFree ||
      _status == SubscriptionPlanStatus.activePremium ||
      StorageService.hasAdFreeAccess;

  bool get isSubscribed => hasAdFreeAccess;
  bool get isPaidSubscribed => StorageService.isPaidSubscribed;
  bool get isPermanentProAccount => StorageService.isPermanentAdFreeAccount;
  bool get isPermanentAdFreeAccount => StorageService.isPermanentAdFreeAccount;

  // Pricing & metadata
  String get formattedAdFreePrice => _productInfo.price;
  String get formattedAnnualPrice => _productInfo.price;
  String get formattedQuarterlyPrice => _productInfo.price;
  String get formattedMonthlyPrice => _productInfo.price;
  PremiumProductInfo get annualProduct => _productInfo;
  PremiumProductInfo get quarterlyProduct => _productInfo;
  PremiumProductInfo get monthlyProduct => _productInfo;
  String get billingProvider => 'Google Play Billing';

  SubscriptionProvider() {
    _init();
  }

  Future<void> _init() async {
    _refreshDetails();
    await SubscriptionService.init((newStatus) {
      _status = newStatus;
      _refreshDetails();
      notifyListeners();
    });
    _productInfo = SubscriptionService.getProductInfo();
    notifyListeners();
  }

  /// Re-evaluates subscription and permanent account entitlement (e.g. on login/logout/email change)
  void refreshStatus() {
    _refreshDetails();
    _productInfo = SubscriptionService.getProductInfo();
    notifyListeners();
  }

  void _refreshDetails() {
    _adFreeDetails = SubscriptionService.getTrialStatusDetails();
    _status = _adFreeDetails['status'] as SubscriptionPlanStatus;
  }

  Future<bool> subscribeAdFree() async {
    _isLoading = true;
    notifyListeners();
    final success = await SubscriptionService.buyAdFreeSubscription();
    _isLoading = false;
    _refreshDetails();
    notifyListeners();
    return success;
  }

  Future<bool> subscribeAnnual() => subscribeAdFree();
  Future<bool> subscribeQuarterly() => subscribeAdFree();
  Future<bool> subscribeMonthly() => subscribeAdFree();

  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();
    final restored = await SubscriptionService.restorePurchases();
    _isLoading = false;
    _refreshDetails();
    notifyListeners();
    return restored;
  }
}
