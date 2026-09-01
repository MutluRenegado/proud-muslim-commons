import 'dart:math' as math;

import '../constants/app_constants.dart';

class QiblaService {
  /// Calculates the true bearing towards the Holy Kaaba in Makkah (0-360 degrees).
  static double calculateQiblaBearing(double userLat, double userLng) {
    final double phi1 = userLat * (math.pi / 180.0);
    final double phi2 = AppConstants.kaabaLatitude * (math.pi / 180.0);
    final double deltaLambda =
        (AppConstants.kaabaLongitude - userLng) * (math.pi / 180.0);

    final double y = math.sin(deltaLambda);
    final double x = math.cos(phi1) * math.tan(phi2) -
        math.sin(phi1) * math.cos(deltaLambda);

    double qiblaAngle = math.atan2(y, x) * (180.0 / math.pi);
    return (qiblaAngle + 360.0) % 360.0;
  }

  /// Calculates geodesic distance to Makkah in Kilometers.
  static double calculateDistanceToMakkah(double userLat, double userLng) {
    const double r = 6371.0; // Earth radius in km
    final double dLat =
        (AppConstants.kaabaLatitude - userLat) * (math.pi / 180.0);
    final double dLng =
        (AppConstants.kaabaLongitude - userLng) * (math.pi / 180.0);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(userLat * (math.pi / 180.0)) *
            math.cos(AppConstants.kaabaLatitude * (math.pi / 180.0)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  /// Calculates shortest relative angle between compass heading and Qibla bearing (-180 to +180 deg).
  static double calculateRelativeAngle(
    double compassHeading,
    double qiblaBearing,
  ) {
    double diff = (qiblaBearing - compassHeading) % 360.0;
    if (diff > 180.0) diff -= 360.0;
    if (diff < -180.0) diff += 360.0;
    return diff;
  }

  /// Checks if device heading is aligned with Qibla within given tolerance in degrees.
  static bool isAligned(
    double compassHeading,
    double qiblaBearing, {
    double tolerance = 4.0,
  }) {
    final diff = calculateRelativeAngle(compassHeading, qiblaBearing);
    return diff.abs() <= tolerance;
  }

  /// Smooths heading transition across the 0/360 degree boundary.
  static double smoothHeading(
    double current,
    double target, {
    double alpha = 0.25,
  }) {
    double diff = (target - current) % 360.0;
    if (diff > 180.0) diff -= 360.0;
    if (diff < -180.0) diff += 360.0;
    return (current + diff * alpha + 360.0) % 360.0;
  }
}
