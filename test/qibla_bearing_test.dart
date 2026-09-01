import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/core/services/qibla_service.dart';

void main() {
  group('Qibla Bearing Tests', () {
    test('Bearing towards Makkah from London is approx 118 degrees', () {
      // London coordinates (51.5074° N, 0.1278° W)
      final bearing = QiblaService.calculateQiblaBearing(51.5074, -0.1278);
      expect(bearing, greaterThan(115.0));
      expect(bearing, lessThan(125.0));
    });

    test('Bearing towards Makkah from New York is approx 58 degrees', () {
      // New York coordinates (40.7128° N, 74.0060° W)
      final bearing = QiblaService.calculateQiblaBearing(40.7128, -74.0060);
      expect(bearing, greaterThan(55.0));
      expect(bearing, lessThan(62.0));
    });

    test('Distance to Makkah from Makkah itself is approximately 0 km', () {
      final distance = QiblaService.calculateDistanceToMakkah(21.422487, 39.826206);
      expect(distance, lessThan(5.0));
    });

    test('Relative angle and alignment detect alignment within tolerance', () {
      const qiblaBearing = 148.5;
      expect(QiblaService.isAligned(148.5, qiblaBearing), isTrue);
      expect(QiblaService.isAligned(150.0, qiblaBearing, tolerance: 4.0), isTrue);
      expect(QiblaService.isAligned(145.0, qiblaBearing, tolerance: 4.0), isTrue);
      expect(QiblaService.isAligned(155.0, qiblaBearing, tolerance: 4.0), isFalse);

      final diff = QiblaService.calculateRelativeAngle(140.0, 148.5);
      expect(diff, closeTo(8.5, 0.001));

      // Wraparound check (heading 359 vs bearing 2)
      final wrapDiff = QiblaService.calculateRelativeAngle(359.0, 2.0);
      expect(wrapDiff, closeTo(3.0, 0.001));
    });

    test('Smooth heading handles 360/0 degree wraparound seamlessly', () {
      // Moving from 359 to 2
      final smoothed = QiblaService.smoothHeading(359.0, 2.0, alpha: 0.5);
      expect(smoothed, closeTo(0.5, 0.001));

      // Moving from 2 to 359
      final smoothedBack = QiblaService.smoothHeading(2.0, 359.0, alpha: 0.5);
      expect(smoothedBack, closeTo(0.5, 0.001));
    });
  });
}
