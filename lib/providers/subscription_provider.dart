import 'package:flutter/material.dart';

import '../core/services/subscription_service.dart';
import '../core/services/storage_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlanStatus _status = SubscriptionPlanStatus.inTrial;
  PremiumProductInfo _productInfo = SubscriptionService.fallbackMonthlyProduct;
  Map<String, dynamic> _trialDetails = {};
  bool _isLoading = false;

  SubscriptionPlanStatus get status => _status;
  PremiumProductInfo get productInfo => _productInfo;
  Map<String, dynamic> get trialDetails => _trialDetails;
  bool get isLoading => _isLoading;

  bool get isSubscribed =>
      _status == SubscriptionPlanStatus.activePremium ||
      StorageService.isSubscribed;
  bool get isInTrial =>
      _status == SubscriptionPlanStatus.inTrial && !isSubscribed;
  int get daysLeftInTrial => (_trialDetails['daysLeft'] as int?) ?? 3;
  String get formattedMonthlyPrice => _productInfo.price;
  String get formattedAnnualPrice => _productInfo.price;
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

  void _refreshDetails() {
    _trialDetails = SubscriptionService.getTrialStatusDetails();
    _status = _trialDetails['status'] as SubscriptionPlanStatus;
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
    return await subscribeMonthly();
  }

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
