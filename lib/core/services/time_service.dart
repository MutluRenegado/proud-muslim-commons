import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// TimeService provides a reliable UTC time source.
/// It verifies UTC time against trusted network endpoints (HTTP Date header)
/// and calculates any clock drift against the device clock.
/// If offline or if requests fail, it fails safely and falls back to DateTime.now().toUtc().
class TimeService {
  static Duration _clockDrift = Duration.zero;
  static bool _hasNetworkSync = false;
  static DateTime _lastLocalCheck = DateTime.now();
  static final List<VoidCallback> _clockJumpListeners = [];

  static Duration get clockDrift => _clockDrift;
  static bool get hasNetworkSync => _hasNetworkSync;

  /// Internal source of truth: Current UTC time (adjusted with verified drift if available)
  static DateTime nowUtc() {
    return DateTime.now().toUtc().add(_clockDrift);
  }

  /// Sets custom clock drift (useful for unit tests and simulation)
  static void setMockDrift(Duration drift) {
    _clockDrift = drift;
  }

  /// Registers a callback for when a major device clock jump is detected.
  static void addClockJumpListener(VoidCallback listener) {
    _clockJumpListeners.add(listener);
  }

  static void removeClockJumpListener(VoidCallback listener) {
    _clockJumpListeners.remove(listener);
  }

  /// Checks if the device clock experienced a significant jump (> 60 seconds).
  static void checkClockJump() {
    final now = DateTime.now();
    final elapsedLocal = now.difference(_lastLocalCheck).inSeconds.abs();
    _lastLocalCheck = now;

    // If unexpected time gap occurs, notify listeners
    if (elapsedLocal > 120) {
      debugPrint('TimeService: Major device clock jump detected.');
      for (final listener in List<VoidCallback>.from(_clockJumpListeners)) {
        try {
          listener();
        } catch (e) {
          debugPrint('Error in clock jump listener: $e');
        }
      }
    }
  }

  /// Attempts to sync UTC time from trusted public servers via HTTP Date header.
  /// Safe fallback: If network request fails or times out, clock drift remains unchanged or 0.
  static Future<bool> syncNetworkTime() async {
    final urls = [
      'https://www.google.com',
      'https://www.cloudflare.com',
      'https://worldtimeapi.org/api/timezone/Etc/UTC',
    ];

    for (final urlStr in urls) {
      try {
        final start = DateTime.now();
        final uri = Uri.parse(urlStr);
        final response = await http.head(uri).timeout(
              const Duration(seconds: 4),
            );
        final end = DateTime.now();
        final roundTrip = end.difference(start);

        final dateHeader = response.headers['date'];
        if (dateHeader != null) {
          final serverDate = _parseHttpDate(dateHeader);
          if (serverDate != null) {
            // Half of round trip accounts for network latency
            final networkUtc = serverDate.toUtc().add(
                  Duration(milliseconds: roundTrip.inMilliseconds ~/ 2),
                );
            final deviceUtc = DateTime.now().toUtc();
            _clockDrift = networkUtc.difference(deviceUtc);
            _hasNetworkSync = true;
            debugPrint(
              'TimeService: Synced with $urlStr. Drift: ${_clockDrift.inMilliseconds}ms',
            );
            return true;
          }
        }
      } catch (_) {
        // Continue to next fallback URL
      }
    }

    debugPrint(
        'TimeService: Network time sync failed. Using device clock fallback.');
    return false;
  }

  /// Parses RFC 1123 / RFC 822 Date header string e.g. "Tue, 01 Sep 2026 17:45:00 GMT"
  static DateTime? _parseHttpDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        final parts = dateStr.split(' ');
        if (parts.length >= 6) {
          final day = int.parse(parts[1]);
          final monthStr = parts[2].toLowerCase();
          final year = int.parse(parts[3]);
          final timeParts = parts[4].split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final second = int.parse(timeParts[2]);

          const months = {
            'jan': 1,
            'feb': 2,
            'mar': 3,
            'apr': 4,
            'may': 5,
            'jun': 6,
            'jul': 7,
            'aug': 8,
            'sep': 9,
            'oct': 10,
            'nov': 11,
            'dec': 12,
          };
          final month = months[monthStr] ?? 1;

          return DateTime.utc(year, month, day, hour, minute, second);
        }
      } catch (_) {}
    }
    return null;
  }
}
