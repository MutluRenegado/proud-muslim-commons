import 'dart:math' as math;

import '../../models/prayer_time_model.dart';

class PrayerCalculationService {
  // Method configurations: fajrAngle, ishaAngle (or fixed minutes after Maghrib)
  static Map<CalculationMethod, Map<String, dynamic>> methodParameters = {
    CalculationMethod.muslimWorldLeague: {'fajrAngle': 18.0, 'ishaAngle': 17.0},
    CalculationMethod.islamicSocietyOfNorthAmerica: {
      'fajrAngle': 15.0,
      'ishaAngle': 15.0,
    },
    CalculationMethod.egyptianGeneralAuthority: {
      'fajrAngle': 19.5,
      'ishaAngle': 17.5,
    },
    CalculationMethod.ummAlQuraMakkah: {
      'fajrAngle': 18.5,
      'ishaInterval': 90.0, // 90 min after Maghrib (120 in Ramadan)
    },
    CalculationMethod.universityOfIslamicSciencesKarachi: {
      'fajrAngle': 18.0,
      'ishaAngle': 18.0,
    },
    CalculationMethod.instituteOfGeophysicsTehran: {
      'fajrAngle': 17.7,
      'maghribAngle': 4.5,
      'ishaAngle': 14.0,
    },
    CalculationMethod.shiaIthnaAshari: {
      'fajrAngle': 16.0,
      'maghribAngle': 4.0,
      'ishaAngle': 14.0,
    },
  };

  /// Calculates prayer times for a given date, latitude, longitude, and calculation options.
  static PrayerTimesModel calculatePrayerTimes({
    required DateTime date,
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslimWorldLeague,
    JuristicMethod juristic = JuristicMethod.standard,
    HighLatitudeRule highLatitude = HighLatitudeRule.none,
    RoundingMethod rounding = RoundingMethod.nearestMinute,
    Map<String, int>? minuteOffsets,
  }) {
    final params = methodParameters[method] ??
        methodParameters[CalculationMethod.muslimWorldLeague]!;
    final double fajrAngle = (params['fajrAngle'] as num).toDouble();
    final double? ishaAngle = params['ishaAngle'] != null
        ? (params['ishaAngle'] as num).toDouble()
        : null;
    final double? ishaInterval = params['ishaInterval'] != null
        ? (params['ishaInterval'] as num).toDouble()
        : null;
    final double? maghribAngle = params['maghribAngle'] != null
        ? (params['maghribAngle'] as num).toDouble()
        : null;

    final double d = _julianDay(date.year, date.month, date.day) - 2451545.0;

    // Mean solar coordinates
    final double g = _fixAngle(357.529 + 0.98560028 * d);
    final double q = _fixAngle(280.459 + 0.98564736 * d);
    final double l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));

    final double e = 23.439 - 0.00000036 * d; // Obliquity of ecliptic
    final double dSun = _arcsin(_sin(e) * _sin(l)); // Sun declination

    final double ra =
        _arctan2(_cos(e) * _sin(l), _cos(l)) / 15.0; // Right ascension in hours
    final double eqt = q / 15.0 - _fixHour(ra); // Equation of time

    // Midday (Dhuhr) in local time hours
    final double timezoneOffset = date.timeZoneOffset.inMinutes / 60.0;
    final double dhuhrHour = 12.0 + timezoneOffset - (longitude / 15.0) - eqt;

    // Sunrise & Sunset angle is -0.833 degrees for atmospheric refraction
    final double sunriseHourAngle = _sunHourAngle(latitude, dSun, -0.833);
    double fajrHourAngle = _sunHourAngle(latitude, dSun, -fajrAngle);

    final double sunriseHour = dhuhrHour - (sunriseHourAngle / 15.0);
    final double sunsetHour = dhuhrHour + (sunriseHourAngle / 15.0);
    double fajrHour = dhuhrHour - (fajrHourAngle / 15.0);

    // Asr calculation based on shadow multiplier (Standard=1, Hanafi=2)
    final double asrMultiplier = juristic == JuristicMethod.hanafi ? 2.0 : 1.0;
    final double asrAngle = _arccot(
      asrMultiplier + _tan((latitude - dSun).abs()),
    );
    final double asrHourAngle = _sunHourAngle(latitude, dSun, asrAngle);
    final double asrHour = dhuhrHour + (asrHourAngle / 15.0);

    // Maghrib
    double maghribHour;
    if (maghribAngle != null) {
      final double mAngle = _sunHourAngle(latitude, dSun, -maghribAngle);
      maghribHour = dhuhrHour + (mAngle / 15.0);
    } else {
      maghribHour = sunsetHour; // standard sunset
    }

    // Isha
    double ishaHour;
    if (ishaInterval != null) {
      ishaHour = maghribHour + (ishaInterval / 60.0);
    } else if (ishaAngle != null) {
      double ishaHourAngle = _sunHourAngle(latitude, dSun, -ishaAngle);
      ishaHour = dhuhrHour + (ishaHourAngle / 15.0);
    } else {
      ishaHour = maghribHour + 1.5;
    }

    // High Latitude Adjustments
    if (highLatitude != HighLatitudeRule.none) {
      final double nightTime =
          24.0 - (sunsetHour - sunriseHour); // duration of night in hours
      if (highLatitude == HighLatitudeRule.middleOfTheNight) {
        final double halfNight = nightTime / 2.0;
        if (fajrHour.isNaN || sunriseHour - fajrHour > halfNight) {
          fajrHour = sunriseHour - halfNight;
        }
        if (ishaHour.isNaN || ishaHour - sunsetHour > halfNight) {
          ishaHour = sunsetHour + halfNight;
        }
      } else if (highLatitude == HighLatitudeRule.oneSeventh) {
        final double portion = nightTime / 7.0;
        if (fajrHour.isNaN || sunriseHour - fajrHour > portion) {
          fajrHour = sunriseHour - portion;
        }
        if (ishaHour.isNaN || ishaHour - sunsetHour > portion) {
          ishaHour = sunsetHour + portion;
        }
      } else if (highLatitude == HighLatitudeRule.angleBased) {
        final double fajrPortion = (fajrAngle / 60.0) * nightTime;
        final double ishaPort = ((ishaAngle ?? 18.0) / 60.0) * nightTime;
        if (fajrHour.isNaN || sunriseHour - fajrHour > fajrPortion) {
          fajrHour = sunriseHour - fajrPortion;
        }
        if (ishaHour.isNaN || ishaHour - sunsetHour > ishaPort) {
          ishaHour = sunsetHour + ishaPort;
        }
      }
    }

    // Convert hours to DateTime with Rounding option
    DateTime toDateTime(double hourVal, [int offsetMin = 0]) {
      if (hourVal.isNaN) hourVal = 12.0;
      final int normalizedHour = hourVal.floor();
      final double rawMinutes = (hourVal - normalizedHour) * 60.0;
      int minute;
      int second = 0;
      switch (rounding) {
        case RoundingMethod.noRounding:
          minute = rawMinutes.floor();
          second = ((rawMinutes - minute) * 60).round();
          break;
        case RoundingMethod.upToNextMinute:
          minute = rawMinutes.ceil();
          break;
        case RoundingMethod.downToPreviousMinute:
          minute = rawMinutes.floor();
          break;
        case RoundingMethod.nearestMinute:
          minute = rawMinutes.round();
          break;
      }
      return DateTime(
        date.year,
        date.month,
        date.day,
        normalizedHour,
        minute,
        second,
      ).add(Duration(minutes: offsetMin));
    }

    final offsets = minuteOffsets ?? {};

    final dtFajr = toDateTime(fajrHour, offsets['Fajr'] ?? 0);
    final dtSunrise = toDateTime(sunriseHour, offsets['Sunrise'] ?? 0);
    final dtDhuhr = toDateTime(dhuhrHour, offsets['Dhuhr'] ?? 0);
    final dtAsr = toDateTime(asrHour, offsets['Asr'] ?? 0);
    final dtMaghrib = toDateTime(maghribHour, offsets['Maghrib'] ?? 0);
    final dtIsha = toDateTime(ishaHour, offsets['Isha'] ?? 0);

    // Qiyam (Last third of night: between Isha & next day Fajr)
    final diffToFajr = dtFajr.add(const Duration(days: 1)).difference(dtIsha);
    final dtQiyam = dtIsha.add(
      Duration(minutes: (diffToFajr.inMinutes * 2 / 3).round()),
    );

    return PrayerTimesModel(
      fajr: dtFajr,
      sunrise: dtSunrise,
      dhuhr: dtDhuhr,
      asr: dtAsr,
      maghrib: dtMaghrib,
      isha: dtIsha,
      qiyam: dtQiyam,
      date: date,
      calculationMethod: method.name,
    );
  }

  // Trigonometric & Astronomical Helpers (Degrees)
  static double _degToRad(double deg) => deg * (math.pi / 180.0);
  static double _radToDeg(double rad) => rad * (180.0 / math.pi);
  static double _sin(double d) => math.sin(_degToRad(d));
  static double _cos(double d) => math.cos(_degToRad(d));
  static double _tan(double d) => math.tan(_degToRad(d));
  static double _arcsin(double x) => _radToDeg(math.asin(x.clamp(-1.0, 1.0)));
  static double _arccos(double x) => _radToDeg(math.acos(x.clamp(-1.0, 1.0)));
  static double _arctan2(double y, double x) => _radToDeg(math.atan2(y, x));
  static double _arccot(double x) => _radToDeg(math.atan(1.0 / x));

  static double _fixAngle(double a) => a - 360.0 * (a / 360.0).floor();
  static double _fixHour(double h) => h - 24.0 * (h / 24.0).floor();

  static double _julianDay(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final int a = (year / 100).floor();
    final int b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;
  }

  static double _sunHourAngle(double lat, double decl, double altitude) {
    final double val =
        (_sin(altitude) - _sin(lat) * _sin(decl)) / (_cos(lat) * _cos(decl));
    if (val > 1.0) return 0.0;
    if (val < -1.0) return 180.0;
    return _arccos(val);
  }
}
