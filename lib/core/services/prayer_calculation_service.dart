import 'dart:math' as math;
import '../../models/prayer_time_model.dart';

class PrayerCalculationService {
  /// Method configurations: fajrAngle, ishaAngle, maghribAngle, or fixed intervals
  static final Map<CalculationMethod, Map<String, dynamic>> methodParameters = {
    CalculationMethod.turkeyDiyanet: {
      'name': 'Türkiye Diyanet İşleri Başkanlığı',
      'fajrAngle': 18.0,
      'ishaAngle': 17.0,
      'dhuhrTamkinMin': 5, // Diyanet standard solar disc transit buffer
      'maghribTamkinMin': 7, // Diyanet sunset refraction / disc buffer
    },
    CalculationMethod.muslimWorldLeague: {
      'name': 'Muslim World League (MWL)',
      'fajrAngle': 18.0,
      'ishaAngle': 17.0,
    },
    CalculationMethod.islamicSocietyOfNorthAmerica: {
      'name': 'Islamic Society of North America (ISNA)',
      'fajrAngle': 15.0,
      'ishaAngle': 15.0,
    },
    CalculationMethod.egyptianGeneralAuthority: {
      'name': 'Egyptian General Authority of Survey',
      'fajrAngle': 19.5,
      'ishaAngle': 17.5,
    },
    CalculationMethod.ummAlQuraMakkah: {
      'name': 'Umm Al-Qura University, Makkah',
      'fajrAngle': 18.5,
      'ishaInterval': 90.0, // 90 min after Maghrib (120 min in Ramadan)
    },
    CalculationMethod.universityOfIslamicSciencesKarachi: {
      'name': 'University of Islamic Sciences, Karachi',
      'fajrAngle': 18.0,
      'ishaAngle': 18.0,
    },
    CalculationMethod.dubai: {
      'name': 'Dubai (UAE / GAIAE)',
      'fajrAngle': 18.2,
      'ishaAngle': 18.2,
    },
    CalculationMethod.kuwait: {
      'name': 'Kuwait (Ministry of Awqaf)',
      'fajrAngle': 18.0,
      'ishaAngle': 17.5,
    },
    CalculationMethod.qatar: {
      'name': 'Qatar (Ministry of Awqaf)',
      'fajrAngle': 18.0,
      'ishaInterval': 90.0,
    },
    CalculationMethod.singapore: {
      'name': 'Singapore (MUIS)',
      'fajrAngle': 20.0,
      'ishaAngle': 18.0,
    },
    CalculationMethod.instituteOfGeophysicsTehran: {
      'name': 'Institute of Geophysics, Tehran',
      'fajrAngle': 17.7,
      'maghribAngle': 4.5,
      'ishaAngle': 14.0,
    },
    CalculationMethod.shiaIthnaAshari: {
      'name': 'Ja‘fari — Leva Research Institute, Qum',
      'fajrAngle': 16.0,
      'maghribAngle': 4.0,
      'ishaAngle': 14.0,
    },
  };

  /// Calculates prayer times for a given local date, coordinates, timezone, and options.
  /// Output prayer times are stored as UTC DateTime instants.
  static PrayerTimesModel calculatePrayerTimes({
    required DateTime date,
    required double latitude,
    required double longitude,
    String ianaTimeZone = 'Europe/Istanbul',
    CalculationMethod method = CalculationMethod.turkeyDiyanet,
    JuristicMethod juristic = JuristicMethod.standard,
    HighLatitudeRule highLatitude = HighLatitudeRule.none,
    RoundingMethod rounding = RoundingMethod.nearestMinute,
    double elevation = 0.0,
    Map<String, int>? minuteOffsets,
    bool isOfficialSource = false,
  }) {
    final params = methodParameters[method] ??
        methodParameters[CalculationMethod.turkeyDiyanet]!;
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
    final int dhuhrTamkin = (params['dhuhrTamkinMin'] as num?)?.toInt() ?? 0;
    final int maghribTamkin =
        (params['maghribTamkinMin'] as num?)?.toInt() ?? 0;

    // Julian day from local calendar date
    final double jd = _julianDay(date.year, date.month, date.day);
    final double d = jd - 2451545.0;

    // Mean solar coordinates
    final double g = _fixAngle(357.529 + 0.98560028 * d);
    final double q = _fixAngle(280.459 + 0.98564736 * d);
    final double l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));

    final double e = 23.439 - 0.00000036 * d; // Obliquity of ecliptic
    final double dSun = _arcsin(_sin(e) * _sin(l)); // Sun declination

    final double ra =
        _arctan2(_cos(e) * _sin(l), _cos(l)) / 15.0; // Right ascension (hours)
    final double eqt = q / 15.0 - _fixHour(ra); // Equation of time (hours)

    // Midday (Solar Transit / Dhuhr base) in UTC hours:
    // When the sun is at the local meridian, local solar time is 12:00.
    // UTC = 12:00 - (longitude / 15) - EqT
    final double dhuhrUtcHour = 12.0 - (longitude / 15.0) - eqt;

    // Standard sunrise/sunset altitude angle (-0.8333 deg) with elevation adjustment
    final double elevationAngle =
        elevation > 0 ? 0.0347 * math.sqrt(elevation) : 0.0;
    final double sunriseSunsetAltitude = -0.8333 - elevationAngle;

    final double sunriseHourAngle =
        _sunHourAngle(latitude, dSun, sunriseSunsetAltitude);
    final double fajrHourAngle = _sunHourAngle(latitude, dSun, -fajrAngle);

    final double sunriseUtcHour = dhuhrUtcHour - (sunriseHourAngle / 15.0);
    final double sunsetUtcHour = dhuhrUtcHour + (sunriseHourAngle / 15.0);
    double fajrUtcHour = dhuhrUtcHour - (fajrHourAngle / 15.0);

    // Asr calculation (Shafi'i/Standard = 1.0, Hanafi = 2.0)
    final double asrMultiplier =
        (juristic == JuristicMethod.hanafi) ? 2.0 : 1.0;
    final double asrAngle = _arccot(
      asrMultiplier + _tan((latitude - dSun).abs()),
    );
    final double asrHourAngle = _sunHourAngle(latitude, dSun, asrAngle);
    final double asrUtcHour = dhuhrUtcHour + (asrHourAngle / 15.0);

    // Maghrib
    double maghribUtcHour;
    if (maghribAngle != null) {
      final double mAngle = _sunHourAngle(latitude, dSun, -maghribAngle);
      maghribUtcHour = dhuhrUtcHour + (mAngle / 15.0);
    } else {
      maghribUtcHour = sunsetUtcHour;
    }

    // Isha
    double ishaUtcHour;
    if (ishaInterval != null) {
      ishaUtcHour = maghribUtcHour + (ishaInterval / 60.0);
    } else if (ishaAngle != null) {
      final double ishaHourAngle = _sunHourAngle(latitude, dSun, -ishaAngle);
      ishaUtcHour = dhuhrUtcHour + (ishaHourAngle / 15.0);
    } else {
      ishaUtcHour = maghribUtcHour + 1.5;
    }

    // High Latitude Adjustments (middle of night, 1/7th, angle based)
    if (highLatitude != HighLatitudeRule.none) {
      final double nightTime = 24.0 - (sunsetUtcHour - sunriseUtcHour);
      if (highLatitude == HighLatitudeRule.middleOfTheNight) {
        final double halfNight = nightTime / 2.0;
        if (fajrUtcHour.isNaN || sunriseUtcHour - fajrUtcHour > halfNight) {
          fajrUtcHour = sunriseUtcHour - halfNight;
        }
        if (ishaUtcHour.isNaN || ishaUtcHour - sunsetUtcHour > halfNight) {
          ishaUtcHour = sunsetUtcHour + halfNight;
        }
      } else if (highLatitude == HighLatitudeRule.oneSeventh) {
        final double portion = nightTime / 7.0;
        if (fajrUtcHour.isNaN || sunriseUtcHour - fajrUtcHour > portion) {
          fajrUtcHour = sunriseUtcHour - portion;
        }
        if (ishaUtcHour.isNaN || ishaUtcHour - sunsetUtcHour > portion) {
          ishaUtcHour = sunsetUtcHour + portion;
        }
      } else if (highLatitude == HighLatitudeRule.angleBased) {
        final double fajrPortion = (fajrAngle / 60.0) * nightTime;
        final double ishaPort = ((ishaAngle ?? 17.0) / 60.0) * nightTime;
        if (fajrUtcHour.isNaN || sunriseUtcHour - fajrUtcHour > fajrPortion) {
          fajrUtcHour = sunriseUtcHour - fajrPortion;
        }
        if (ishaUtcHour.isNaN || ishaUtcHour - sunsetUtcHour > ishaPort) {
          ishaUtcHour = sunsetUtcHour + ishaPort;
        }
      }
    }

    // Helper: Converts calculated UTC decimal hour into exact UTC DateTime
    DateTime toUtcDateTime(double utcHourVal, [int offsetMin = 0]) {
      if (utcHourVal.isNaN) utcHourVal = 12.0;

      // Base anchor in UTC for the calendar day
      final baseDateUtc = DateTime.utc(date.year, date.month, date.day);
      final totalSeconds = (utcHourVal * 3600.0);
      final rawMinutes = totalSeconds / 60.0;

      int roundedMinutes;
      int roundedSeconds = 0;

      switch (rounding) {
        case RoundingMethod.noRounding:
          roundedMinutes = (totalSeconds / 60).floor();
          roundedSeconds = (totalSeconds % 60).round();
          return baseDateUtc
              .add(Duration(minutes: roundedMinutes, seconds: roundedSeconds))
              .add(Duration(minutes: offsetMin));
        case RoundingMethod.upToNextMinute:
          roundedMinutes = rawMinutes.ceil();
          break;
        case RoundingMethod.downToPreviousMinute:
          roundedMinutes = rawMinutes.floor();
          break;
        case RoundingMethod.nearestMinute:
          roundedMinutes = rawMinutes.round();
          break;
      }

      return baseDateUtc.add(Duration(minutes: roundedMinutes + offsetMin));
    }

    final offsets = minuteOffsets ?? {};

    final dtFajrUtc = toUtcDateTime(fajrUtcHour, offsets['Fajr'] ?? 0);
    final dtSunriseUtc = toUtcDateTime(sunriseUtcHour, offsets['Sunrise'] ?? 0);
    final dtDhuhrUtc =
        toUtcDateTime(dhuhrUtcHour, (offsets['Dhuhr'] ?? 0) + dhuhrTamkin);
    final dtAsrUtc = toUtcDateTime(asrUtcHour, offsets['Asr'] ?? 0);
    final dtMaghribUtc = toUtcDateTime(
        maghribUtcHour, (offsets['Maghrib'] ?? 0) + maghribTamkin);
    final dtIshaUtc = toUtcDateTime(ishaUtcHour, offsets['Isha'] ?? 0);

    // Qiyam (Last third of the night between Isha and next day's Fajr)
    final nextFajrEstimate = dtFajrUtc.add(const Duration(days: 1));
    final diffToFajr = nextFajrEstimate.difference(dtIshaUtc);
    final dtQiyamUtc = dtIshaUtc.add(
      Duration(minutes: (diffToFajr.inMinutes * 2 / 3).round()),
    );

    return PrayerTimesModel(
      fajrUtc: dtFajrUtc,
      sunriseUtc: dtSunriseUtc,
      dhuhrUtc: dtDhuhrUtc,
      asrUtc: dtAsrUtc,
      maghribUtc: dtMaghribUtc,
      ishaUtc: dtIshaUtc,
      qiyamUtc: dtQiyamUtc,
      date: DateTime(date.year, date.month, date.day),
      ianaTimeZone: ianaTimeZone,
      calculationMethod: method.name,
      isOfficialSource: isOfficialSource,
    );
  }

  /// Generates a complete 30-day (or specified count) offline prayer schedule starting from [startDate].
  static List<PrayerTimesModel> generateMonthlySchedule({
    required DateTime startDate,
    required double latitude,
    required double longitude,
    String ianaTimeZone = 'Europe/Istanbul',
    CalculationMethod method = CalculationMethod.turkeyDiyanet,
    JuristicMethod juristic = JuristicMethod.standard,
    HighLatitudeRule highLatitude = HighLatitudeRule.none,
    RoundingMethod rounding = RoundingMethod.nearestMinute,
    double elevation = 0.0,
    Map<String, int>? minuteOffsets,
    int daysCount = 35,
  }) {
    final List<PrayerTimesModel> schedule = [];
    for (int i = 0; i < daysCount; i++) {
      final d = startDate.add(Duration(days: i));
      final times = calculatePrayerTimes(
        date: d,
        latitude: latitude,
        longitude: longitude,
        ianaTimeZone: ianaTimeZone,
        method: method,
        juristic: juristic,
        highLatitude: highLatitude,
        rounding: rounding,
        elevation: elevation,
        minuteOffsets: minuteOffsets,
      );
      schedule.add(times);
    }
    return schedule;
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
