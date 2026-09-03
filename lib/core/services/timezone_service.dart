import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static bool _isInitialized = false;

  /// Initializes the timezone database from the timezone package.
  static void init() {
    if (!_isInitialized) {
      tz.initializeTimeZones();
      _isInitialized = true;
    }
  }

  /// Gets the tz.Location instance for a valid IANA timezone identifier.
  /// Falls back to Europe/Istanbul or UTC if invalid.
  static tz.Location getLocation(String ianaTimeZone) {
    init();
    try {
      return tz.getLocation(ianaTimeZone);
    } catch (_) {
      try {
        return tz.getLocation('Europe/Istanbul');
      } catch (_) {
        return tz.UTC;
      }
    }
  }

  /// Converts a UTC DateTime instant to a tz.TZDateTime in the target IANA timezone.
  static tz.TZDateTime toLocal(DateTime utcInstant, String ianaTimeZone) {
    init();
    final location = getLocation(ianaTimeZone);
    final normalizedUtc = utcInstant.isUtc
        ? utcInstant
        : DateTime.utc(
            utcInstant.year,
            utcInstant.month,
            utcInstant.day,
            utcInstant.hour,
            utcInstant.minute,
            utcInstant.second,
            utcInstant.millisecond,
          );
    return tz.TZDateTime.from(normalizedUtc, location);
  }

  /// Returns the current local calendar date (Year, Month, Day) in the target IANA timezone.
  static DateTime getLocalDate(DateTime utcInstant, String ianaTimeZone) {
    final tzLocal = toLocal(utcInstant, ianaTimeZone);
    return DateTime(tzLocal.year, tzLocal.month, tzLocal.day);
  }

  /// Returns current UTC offset string for a given instant in an IANA timezone (e.g. "+03:00", "-04:00").
  static String getUtcOffsetString(DateTime utcInstant, String ianaTimeZone) {
    final tzLocal = toLocal(utcInstant, ianaTimeZone);
    final offsetInMinutes = tzLocal.timeZoneOffset.inMinutes;
    final hours = (offsetInMinutes ~/ 60).abs().toString().padLeft(2, '0');
    final minutes = (offsetInMinutes % 60).abs().toString().padLeft(2, '0');
    final sign = offsetInMinutes >= 0 ? '+' : '-';
    return 'UTC$sign$hours:$minutes';
  }

  /// Formats a UTC instant to local time string e.g. "05:23 AM" or "13:45"
  static String formatTime(
    DateTime utcInstant,
    String ianaTimeZone, {
    bool use24Hour = false,
    bool showSeconds = false,
  }) {
    final tzLocal = toLocal(utcInstant, ianaTimeZone);
    if (use24Hour) {
      return showSeconds
          ? DateFormat('HH:mm:ss').format(tzLocal)
          : DateFormat('HH:mm').format(tzLocal);
    } else {
      return showSeconds
          ? DateFormat('hh:mm:ss a').format(tzLocal)
          : DateFormat('hh:mm a').format(tzLocal);
    }
  }

  /// Formats a local date string e.g. "Tuesday, 1 September 2026"
  static String formatDate(
    DateTime utcInstant,
    String ianaTimeZone, {
    String pattern = 'EEEE, d MMMM yyyy',
    String? locale,
  }) {
    final tzLocal = toLocal(utcInstant, ianaTimeZone);
    return DateFormat(pattern, locale).format(tzLocal);
  }

  /// Maps coordinates or country to the most accurate IANA timezone.
  static String detectIanaTimeZone({
    required double lat,
    required double lng,
    String country = '',
    String city = '',
  }) {
    final c = country.trim().toLowerCase();
    final cityName = city.trim().toLowerCase();

    // Direct country / city matches
    if (c.contains('turkey') ||
        c.contains('türkiye') ||
        cityName.contains('istanbul') ||
        cityName.contains('ankara')) {
      return 'Europe/Istanbul';
    }
    if (c.contains('saudi') ||
        cityName.contains('makkah') ||
        cityName.contains('mecca') ||
        cityName.contains('madinah') ||
        cityName.contains('riyadh')) {
      return 'Asia/Riyadh';
    }
    if (c.contains('united kingdom') ||
        c == 'uk' ||
        cityName.contains('london') ||
        cityName.contains('birmingham')) {
      return 'Europe/London';
    }
    if (c.contains('egypt') || cityName.contains('cairo')) {
      return 'Africa/Cairo';
    }
    if (c.contains('emirates') ||
        c == 'uae' ||
        cityName.contains('dubai') ||
        cityName.contains('abu dhabi')) {
      return 'Asia/Dubai';
    }
    if (c.contains('qatar') || cityName.contains('doha')) {
      return 'Asia/Qatar';
    }
    if (c.contains('kuwait')) {
      return 'Asia/Kuwait';
    }
    if (c.contains('singapore')) {
      return 'Asia/Singapore';
    }
    if (c.contains('pakistan') ||
        cityName.contains('karachi') ||
        cityName.contains('lahore') ||
        cityName.contains('islamabad')) {
      return 'Asia/Karachi';
    }
    if (c.contains('bangladesh') || cityName.contains('dhaka')) {
      return 'Asia/Dhaka';
    }
    if (c.contains('indonesia') || cityName.contains('jakarta')) {
      return 'Asia/Jakarta';
    }
    if (c.contains('malaysia') || cityName.contains('kuala lumpur')) {
      return 'Asia/Kuala_Lumpur';
    }
    if (c.contains('france') || cityName.contains('paris')) {
      return 'Europe/Paris';
    }
    if (c.contains('germany') || cityName.contains('berlin')) {
      return 'Europe/Berlin';
    }
    if (c.contains('russia') || cityName.contains('moscow')) {
      return 'Europe/Moscow';
    }
    if (c.contains('japan') || cityName.contains('tokyo')) {
      return 'Asia/Tokyo';
    }
    if (c.contains('canada') || cityName.contains('toronto')) {
      return 'America/Toronto';
    }
    if (c.contains('morocco') || cityName.contains('casablanca')) {
      return 'Africa/Casablanca';
    }
    if (c.contains('algeria') || cityName.contains('algiers')) {
      return 'Africa/Algiers';
    }
    if (c.contains('tunisia') || cityName.contains('tunis')) {
      return 'Africa/Tunis';
    }
    if (c.contains('jordan') || cityName.contains('amman')) {
      return 'Asia/Amman';
    }
    if (c.contains('palestine') ||
        cityName.contains('jerusalem') ||
        cityName.contains('quds')) {
      return 'Asia/Jerusalem';
    }

    // United States / North America time zones based on Longitude
    if (c.contains('united states') || c == 'usa' || c == 'us') {
      if (lng > -80.0) return 'America/New_York';
      if (lng > -90.0) return 'America/Chicago';
      if (lng > -105.0) return 'America/Denver';
      if (lng > -125.0) return 'America/Los_Angeles';
      if (lat > 50.0) return 'America/Anchorage';
      return 'America/New_York';
    }

    // Australia
    if (c.contains('australia')) {
      if (lng > 140.0) return 'Australia/Sydney';
      if (lng > 130.0) return 'Australia/Adelaide';
      return 'Australia/Perth';
    }

    // Spatial coordinate approximation
    if (lat >= 35.0 && lat <= 43.0 && lng >= 25.0 && lng <= 45.0) {
      return 'Europe/Istanbul';
    }
    if (lat >= 15.0 && lat <= 32.0 && lng >= 34.0 && lng <= 56.0) {
      return 'Asia/Riyadh';
    }
    if (lat >= 49.0 && lat <= 60.0 && lng >= -10.0 && lng <= 2.0) {
      return 'Europe/London';
    }

    // Fallback based on approximate longitude offset
    final roughOffsetHours = (lng / 15.0).round();
    if (roughOffsetHours == 0) return 'UTC';
    if (roughOffsetHours == 1) return 'Europe/Paris';
    if (roughOffsetHours == 2) return 'Africa/Cairo';
    if (roughOffsetHours == 3) return 'Europe/Istanbul';
    if (roughOffsetHours == 4) return 'Asia/Dubai';
    if (roughOffsetHours == 5) return 'Asia/Karachi';
    if (roughOffsetHours == 6) return 'Asia/Dhaka';
    if (roughOffsetHours == 7) return 'Asia/Bangkok';
    if (roughOffsetHours == 8) return 'Asia/Singapore';
    if (roughOffsetHours == 9) return 'Asia/Tokyo';
    if (roughOffsetHours == 10) return 'Australia/Sydney';
    if (roughOffsetHours == 12) return 'Pacific/Auckland';
    if (roughOffsetHours == -5) return 'America/New_York';
    if (roughOffsetHours == -6) return 'America/Chicago';
    if (roughOffsetHours == -7) return 'America/Denver';
    if (roughOffsetHours == -8) return 'America/Los_Angeles';
    if (roughOffsetHours == -10) return 'Pacific/Honolulu';

    return 'Europe/Istanbul';
  }
}
