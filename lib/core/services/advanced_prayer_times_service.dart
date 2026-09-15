import 'dart:math' as math;

import '../../models/prayer_time_model.dart';

class AdvancedPrayerTimesService {
  AdvancedPrayerTimesService._();

  /// Returns the 18 canonical timetable markers in display order.
  /// The primary six times come from the active app calculation settings;
  /// supplementary markers are derived astronomically for the same date/location.
  static List<DateTime> calculate({
    required PrayerTimesModel today,
    required DateTime nextFajrUtc,
    required double latitude,
    required double longitude,
  }) {
    final date = today.date;
    final solar = _solarData(date, longitude);
    final ishraq = _altitudeCrossing(
      date, solar, latitude, 5, morning: true,
    );
    final isfirar = _altitudeCrossing(
      date, solar, latitude, 5, morning: false,
    );
    final ishtibak = _altitudeCrossing(
      date, solar, latitude, -10, morning: false,
    );
    final firstAsr = _asr(date, solar, latitude, 1);
    final secondAsr = _asr(date, solar, latitude, 2);
    final secondIsha = _altitudeCrossing(
      date, solar, latitude, -19, morning: false,
    );
    final night = nextFajrUtc.difference(today.maghribUtc);
    final midnight = today.maghribUtc.add(night ~/ 2);
    final tahajjud = today.maghribUtc.add((night * 2) ~/ 3);
    final sahar = today.maghribUtc.add((night * 5) ~/ 6);
    final dahwa = today.fajrUtc.add(
      today.maghribUtc.difference(today.fajrUtc) ~/ 2,
    );
    final qiblaTime = _qiblaAlignment(
      date, solar, latitude, longitude,
    );

    return [
      today.fajrUtc,
      today.fajrUtc.add(const Duration(minutes: 17)),
      today.sunriseUtc,
      ishraq,
      dahwa,
      today.dhuhrUtc.subtract(const Duration(minutes: 20)),
      today.dhuhrUtc,
      firstAsr,
      secondAsr,
      isfirar,
      today.maghribUtc,
      ishtibak,
      today.ishaUtc,
      secondIsha,
      midnight,
      tahajjud,
      sahar,
      qiblaTime,
    ];
  }

  static bool isKerahatActive(List<DateTime> values, DateTime nowUtc) {
    final sunrise = values[2];
    final ishraq = values[3];
    final middayStart = values[5];
    final dhuhr = values[6];
    final isfirar = values[9];
    final maghrib = values[10];
    return _between(nowUtc, sunrise, ishraq) ||
        _between(nowUtc, middayStart, dhuhr) ||
        _between(nowUtc, isfirar, maghrib);
  }

  static bool _between(DateTime value, DateTime start, DateTime end) =>
      !value.isBefore(start) && value.isBefore(end);

  static _SolarData _solarData(DateTime date, double longitude) {
    final jd = _julianDay(date.year, date.month, date.day);
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    final declination = _asin(_sin(e) * _sin(l));
    final ra = _atan2(_cos(e) * _sin(l), _cos(l)) / 15;
    final equation = q / 15 - _fixHour(ra);
    final noonUtcHour = 12 - longitude / 15 - equation;
    return _SolarData(declination, equation, noonUtcHour);
  }

  static DateTime _altitudeCrossing(
    DateTime date,
    _SolarData solar,
    double latitude,
    double altitude, {
    required bool morning,
  }) {
    final angle = _hourAngle(latitude, solar.declination, altitude);
    final hour = solar.noonUtcHour + (morning ? -angle : angle) / 15;
    return _dateAtUtcHour(date, hour);
  }

  static DateTime _asr(
    DateTime date,
    _SolarData solar,
    double latitude,
    double shadowFactor,
  ) {
    final altitude = _atan(1 / (shadowFactor + _tan((latitude - solar.declination).abs())));
    final angle = _hourAngle(latitude, solar.declination, altitude);
    return _dateAtUtcHour(date, solar.noonUtcHour + angle / 15);
  }

  static DateTime _qiblaAlignment(
    DateTime date,
    _SolarData solar,
    double latitude,
    double longitude,
  ) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final dLng = _rad(kaabaLng - longitude);
    final lat1 = _rad(latitude);
    final lat2 = _rad(kaabaLat);
    final bearing = _fixAngle(_deg(math.atan2(
      math.sin(dLng) * math.cos(lat2),
      math.cos(lat1) * math.sin(lat2) -
          math.sin(lat1) * math.cos(lat2) * math.cos(dLng),
    )));

    var bestMinute = (solar.noonUtcHour * 60).round();
    var bestDifference = double.infinity;
    for (var minute = 0; minute < 24 * 60; minute++) {
      final utcHour = minute / 60;
      final hourAngle = 15 * (utcHour + longitude / 15 + solar.equation - 12);
      final altitude = _asin(
        _sin(latitude) * _sin(solar.declination) +
            _cos(latitude) * _cos(solar.declination) * _cos(hourAngle),
      );
      if (altitude <= 0) continue;
      final azimuth = _fixAngle(_deg(math.atan2(
            math.sin(_rad(hourAngle)),
            math.cos(_rad(hourAngle)) * math.sin(_rad(latitude)) -
                math.tan(_rad(solar.declination)) * math.cos(_rad(latitude)),
          )) + 180);
      final difference = _angularDifference(azimuth, bearing);
      if (difference < bestDifference) {
        bestDifference = difference;
        bestMinute = minute;
      }
    }
    return DateTime.utc(date.year, date.month, date.day)
        .add(Duration(minutes: bestMinute));
  }

  static double _angularDifference(double a, double b) {
    final diff = (a - b).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }

  static DateTime _dateAtUtcHour(DateTime date, double hour) =>
      DateTime.utc(date.year, date.month, date.day)
          .add(Duration(minutes: (hour * 60).round()));

  static double _julianDay(int year, int month, int day) {
    if (month <= 2) { year--; month += 12; }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() + day + b - 1524.5;
  }

  static double _hourAngle(double lat, double decl, double altitude) {
    final value = (_sin(altitude) - _sin(lat) * _sin(decl)) /
        (_cos(lat) * _cos(decl));
    return _deg(math.acos(value.clamp(-1.0, 1.0)));
  }

  static double _rad(double value) => value * math.pi / 180;
  static double _deg(double value) => value * 180 / math.pi;
  static double _sin(double value) => math.sin(_rad(value));
  static double _cos(double value) => math.cos(_rad(value));
  static double _tan(double value) => math.tan(_rad(value));
  static double _asin(double value) => _deg(math.asin(value.clamp(-1.0, 1.0)));
  static double _atan(double value) => _deg(math.atan(value));
  static double _atan2(double y, double x) => _deg(math.atan2(y, x));
  static double _fixAngle(double value) => value - 360 * (value / 360).floor();
  static double _fixHour(double value) => value - 24 * (value / 24).floor();
}

class _SolarData {
  const _SolarData(this.declination, this.equation, this.noonUtcHour);
  final double declination;
  final double equation;
  final double noonUtcHour;
}
