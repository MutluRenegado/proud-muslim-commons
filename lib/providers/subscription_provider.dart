import 'package:flutter/material.dart';

import '../core/services/subscription_service.dart';
import '../core/services/storage_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlanStatus _status = SubscriptionPlanStatus.free;
  PremiumProductInfo _monthlyProduct = SubscriptionService.fallbackMonthlyProduct;
  PremiumProductInfo _annualProduct = SubscriptionService.fallbackAnnualProduct;
  Map<String, dynamic> _statusDetails = {};
  bool _isLoading = false;

  SubscriptionPlanStatus get status => _status;
  Map<String, dynamic> get trialDetails => _statusDetails;
  Map<String, dynamic> get statusDetails => _statusDetails;
  bool get isLoading => _isLoading;

  /// True if user is an authorized test account, paid subscriber, or on 3-day free trial
  bool get hasPremiumAccess =>
      _status == SubscriptionPlanStatus.activePremium ||
      _status == SubscriptionPlanStatus.activeTrial ||
      _status == SubscriptionPlanStatus.testingAccount ||
      StorageService.hasPremiumAccess;

  /// 100% Ad-Free across the entire app
  bool get hasAdFreeAccess => true;

  bool get isSubscribed => hasPremiumAccess;
  bool get isPaidSubscribed => StorageService.isPaidSubscribed;
  bool get isPermanentTestingAccount => StorageService.isPermanentTestingAccount;
  bool get isPermanentProAccount => isPermanentTestingAccount;
  bool get isPermanentAdFreeAccount => isPermanentTestingAccount;
  bool get hasActiveTrial => StorageService.hasActiveTrial;
  int get trialDaysRemaining => StorageService.trialDaysRemaining;

  // Products
  PremiumProductInfo get monthlyProduct => _monthlyProduct;
  PremiumProductInfo get annualProduct => _annualProduct;
  PremiumProductInfo get productInfo => _annualProduct;
  String get formattedAnnualPrice => _annualProduct.price;
  String get formattedMonthlyPrice => _monthlyProduct.price;
  String get billingProvider => 'Google Play / App Store';

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
    _monthlyProduct = SubscriptionService.getMonthlyProductInfo();
    _annualProduct = SubscriptionService.getAnnualProductInfo();
    notifyListeners();
  }

  /// Re-evaluates entitlement state (e.g. on login/logout/email change)
  void refreshStatus() {
    _refreshDetails();
    _monthlyProduct = SubscriptionService.getMonthlyProductInfo();
    _annualProduct = SubscriptionService.getAnnualProductInfo();
    notifyListeners();
  }

  void _refreshDetails() {
    _statusDetails = SubscriptionService.getTrialStatusDetails();
    _status = _statusDetails['status'] as SubscriptionPlanStatus;
  }

  Future<bool> subscribeMonthly() async {
    _isLoading = true;
    notifyListeners();
    final success = await SubscriptionService.buyMonthlySubscription();
    _isLoading = false;
    _refreshDetails();
    notifyListeners();
    return success;
  }

  Future<bool> subscribeAnnual() async {
    _isLoading = true;
    notifyListeners();
    final success = await SubscriptionService.buyAnnualSubscription();
    _isLoading = false;
    _refreshDetails();
    notifyListeners();
    return success;
  }

  Future<bool> start3DayTrial() async {
    _isLoading = true;
    notifyListeners();
    final success = await StorageService.startFreeTrial();
    _isLoading = false;
    _refreshDetails();
    notifyListeners();
    return success;
  }

  Future<bool> subscribeAdFree() => subscribeAnnual();
  Future<bool> subscribeQuarterly() => subscribeAnnual();

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
