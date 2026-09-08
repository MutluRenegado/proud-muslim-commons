import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;

  static FirebaseAnalytics? get analytics => _analytics;
  static FirebaseAnalyticsObserver? get observer => _observer;

  static void init() {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      debugPrint('[AnalyticsService] Firebase Analytics initialized successfully');
    } catch (e) {
      debugPrint('[AnalyticsService] Firebase Analytics init skipped/failed: $e');
    }
  }

  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('[AnalyticsService] logEvent failed: $e');
    }
  }

  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      debugPrint('[AnalyticsService] logScreenView failed: $e');
    }
  }

  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('[AnalyticsService] setUserProperty failed: $e');
    }
  }
}
