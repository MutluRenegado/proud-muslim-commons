import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_colors.dart';

class CityPreset {
  final String city;
  final String country;
  final double lat;
  final double lng;

  const CityPreset({
    required this.city,
    required this.country,
    required this.lat,
    required this.lng,
  });
}

class LocationService {
  static const List<CityPreset> popularIslamicCities = [
    CityPreset(
      city: 'Makkah',
      country: 'Saudi Arabia',
      lat: 21.4225,
      lng: 39.8262,
    ),
    CityPreset(
      city: 'Madinah',
      country: 'Saudi Arabia',
      lat: 24.4672,
      lng: 39.6111,
    ),
    CityPreset(
      city: 'Jerusalem (Al-Quds)',
      country: 'Palestine',
      lat: 31.7767,
      lng: 35.2345,
    ),
    CityPreset(city: 'Cairo', country: 'Egypt', lat: 30.0444, lng: 31.2357),
    CityPreset(city: 'Istanbul', country: 'Turkey', lat: 41.0082, lng: 28.9784),
    CityPreset(
      city: 'Dubai',
      country: 'United Arab Emirates',
      lat: 25.2048,
      lng: 55.2708,
    ),
    CityPreset(
      city: 'Riyadh',
      country: 'Saudi Arabia',
      lat: 24.7136,
      lng: 46.6753,
    ),
    CityPreset(city: 'Doha', country: 'Qatar', lat: 25.2854, lng: 51.5310),
    CityPreset(
      city: 'Kuwait City',
      country: 'Kuwait',
      lat: 29.3759,
      lng: 47.9774,
    ),
    CityPreset(city: 'Muscat', country: 'Oman', lat: 23.5880, lng: 58.3829),
    CityPreset(city: 'Manama', country: 'Bahrain', lat: 26.2285, lng: 50.5860),
    CityPreset(
      city: 'Karachi',
      country: 'Pakistan',
      lat: 24.8607,
      lng: 67.0011,
    ),
    CityPreset(city: 'Lahore', country: 'Pakistan', lat: 31.5204, lng: 74.3587),
    CityPreset(
      city: 'Islamabad',
      country: 'Pakistan',
      lat: 33.6844,
      lng: 73.0479,
    ),
    CityPreset(
      city: 'Dhaka',
      country: 'Bangladesh',
      lat: 23.8103,
      lng: 90.4125,
    ),
    CityPreset(
      city: 'Jakarta',
      country: 'Indonesia',
      lat: -6.2088,
      lng: 106.8456,
    ),
    CityPreset(
      city: 'Kuala Lumpur',
      country: 'Malaysia',
      lat: 3.1390,
      lng: 101.6869,
    ),
    CityPreset(
      city: 'London',
      country: 'United Kingdom',
      lat: 51.5074,
      lng: -0.1278,
    ),
    CityPreset(
      city: 'Birmingham',
      country: 'United Kingdom',
      lat: 52.4862,
      lng: -1.8904,
    ),
    CityPreset(
      city: 'Manchester',
      country: 'United Kingdom',
      lat: 53.4808,
      lng: -2.2426,
    ),
    CityPreset(city: 'Paris', country: 'France', lat: 48.8566, lng: 2.3522),
    CityPreset(city: 'Berlin', country: 'Germany', lat: 52.5200, lng: 13.4050),
    CityPreset(
      city: 'New York',
      country: 'United States',
      lat: 40.7128,
      lng: -74.0060,
    ),
    CityPreset(
      city: 'Chicago',
      country: 'United States',
      lat: 41.8781,
      lng: -87.6298,
    ),
    CityPreset(
      city: 'Los Angeles',
      country: 'United States',
      lat: 34.0522,
      lng: -118.2437,
    ),
    CityPreset(
      city: 'Houston',
      country: 'United States',
      lat: 29.7604,
      lng: -95.3698,
    ),
    CityPreset(city: 'Toronto', country: 'Canada', lat: 43.6532, lng: -79.3832),
    CityPreset(
      city: 'Sydney',
      country: 'Australia',
      lat: -33.8688,
      lng: 151.2093,
    ),
    CityPreset(
      city: 'Melbourne',
      country: 'Australia',
      lat: -37.8136,
      lng: 144.9631,
    ),
    CityPreset(
      city: 'Singapore',
      country: 'Singapore',
      lat: 1.3521,
      lng: 103.8198,
    ),
    CityPreset(city: 'Tokyo', country: 'Japan', lat: 35.6762, lng: 139.6503),
    CityPreset(
      city: 'Casablanca',
      country: 'Morocco',
      lat: 33.5731,
      lng: -7.5898,
    ),
    CityPreset(city: 'Algiers', country: 'Algeria', lat: 36.7538, lng: 3.0588),
    CityPreset(city: 'Tunis', country: 'Tunisia', lat: 36.8065, lng: 10.1815),
    CityPreset(city: 'Amman', country: 'Jordan', lat: 31.9454, lng: 35.9284),
  ];

  /// Shows the required permission explanation dialog before invoking OS location prompt.
  static Future<bool> showPermissionRationaleDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primaryEmerald,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Location Access',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enable Location for Accurate Prayer Times',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.primaryEmerald,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We only access your device location to provide accurate prayer times and location-based features. Your personal data remains private. You can safely enable location services.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryEmerald,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Checks and requests device GPS location.
  static Future<Position?> requestDeviceLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled on your device. Please turn on GPS.',
            ),
            backgroundColor: AppColors.warning,
          ),
        );
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        final proceed = await showPermissionRationaleDialog(context);
        if (!proceed) return null;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission denied. Using manual location.',
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Permission Permanently Denied'),
            content: const Text(
              'Location permission is permanently denied. You can enable it from system App Settings or select a city manually.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Geolocator.openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return position;
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  /// Approximate nearest city from coordinates among preset list.
  static CityPreset findNearestCity(double lat, double lng) {
    CityPreset nearest = popularIslamicCities.first;
    double minDistance = double.infinity;

    for (final c in popularIslamicCities) {
      final d = Geolocator.distanceBetween(lat, lng, c.lat, c.lng);
      if (d < minDistance) {
        minDistance = d;
        nearest = c;
      }
    }
    return nearest;
  }
}
