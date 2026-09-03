// prayer_time_model.dart
import '../core/services/timezone_service.dart';

class PrayerTimesModel {
  final DateTime fajrUtc;
  final DateTime sunriseUtc;
  final DateTime dhuhrUtc;
  final DateTime asrUtc;
  final DateTime maghribUtc;
  final DateTime ishaUtc;
  final DateTime qiyamUtc;

  /// The local calendar date (Year, Month, Day) in the target IANA timezone
  final DateTime date;
  final String ianaTimeZone;
  final String calculationMethod;
  final bool isOfficialSource;

  PrayerTimesModel({
    required this.fajrUtc,
    required this.sunriseUtc,
    required this.dhuhrUtc,
    required this.asrUtc,
    required this.maghribUtc,
    required this.ishaUtc,
    required this.qiyamUtc,
    required this.date,
    required this.ianaTimeZone,
    required this.calculationMethod,
    this.isOfficialSource = false,
  });

  /// Local DateTime getters for backward compatibility with existing UI components
  DateTime get fajr => TimezoneService.toLocal(fajrUtc, ianaTimeZone);
  DateTime get sunrise => TimezoneService.toLocal(sunriseUtc, ianaTimeZone);
  DateTime get dhuhr => TimezoneService.toLocal(dhuhrUtc, ianaTimeZone);
  DateTime get asr => TimezoneService.toLocal(asrUtc, ianaTimeZone);
  DateTime get maghrib => TimezoneService.toLocal(maghribUtc, ianaTimeZone);
  DateTime get isha => TimezoneService.toLocal(ishaUtc, ianaTimeZone);
  DateTime get qiyam => TimezoneService.toLocal(qiyamUtc, ianaTimeZone);

  Map<String, DateTime> toUtcMap() {
    return {
      'Fajr': fajrUtc,
      'Sunrise': sunriseUtc,
      'Dhuhr': dhuhrUtc,
      'Asr': asrUtc,
      'Maghrib': maghribUtc,
      'Isha': ishaUtc,
      'Qiyam': qiyamUtc,
    };
  }

  Map<String, DateTime> toMap() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
      'Qiyam': qiyam,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'fajrUtc': fajrUtc.toIso8601String(),
      'sunriseUtc': sunriseUtc.toIso8601String(),
      'dhuhrUtc': dhuhrUtc.toIso8601String(),
      'asrUtc': asrUtc.toIso8601String(),
      'maghribUtc': maghribUtc.toIso8601String(),
      'ishaUtc': ishaUtc.toIso8601String(),
      'qiyamUtc': qiyamUtc.toIso8601String(),
      'date': date.toIso8601String(),
      'ianaTimeZone': ianaTimeZone,
      'calculationMethod': calculationMethod,
      'isOfficialSource': isOfficialSource,
    };
  }

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      fajrUtc: DateTime.parse(json['fajrUtc'] as String).toUtc(),
      sunriseUtc: DateTime.parse(json['sunriseUtc'] as String).toUtc(),
      dhuhrUtc: DateTime.parse(json['dhuhrUtc'] as String).toUtc(),
      asrUtc: DateTime.parse(json['asrUtc'] as String).toUtc(),
      maghribUtc: DateTime.parse(json['maghribUtc'] as String).toUtc(),
      ishaUtc: DateTime.parse(json['ishaUtc'] as String).toUtc(),
      qiyamUtc: DateTime.parse(json['qiyamUtc'] as String).toUtc(),
      date: DateTime.parse(json['date'] as String),
      ianaTimeZone: json['ianaTimeZone'] as String? ?? 'Europe/Istanbul',
      calculationMethod:
          json['calculationMethod'] as String? ?? 'turkeyDiyanet',
      isOfficialSource: json['isOfficialSource'] as bool? ?? false,
    );
  }
}

enum CalculationMethod {
  turkeyDiyanet,
  muslimWorldLeague,
  ummAlQuraMakkah,
  egyptianGeneralAuthority,
  universityOfIslamicSciencesKarachi,
  islamicSocietyOfNorthAmerica,
  dubai,
  kuwait,
  qatar,
  singapore,
  instituteOfGeophysicsTehran,
  shiaIthnaAshari,
}

enum JuristicMethod {
  standard, // Equivalent to Shafi'i / Maliki / Hanbali (shadow 1:1)
  hanafi, // Shadow 2:1
  shafii,
  maliki,
  hanbali,
  jafari,
}

enum HighLatitudeRule { none, middleOfTheNight, oneSeventh, angleBased }

enum RoundingMethod {
  noRounding,
  nearestMinute,
  upToNextMinute,
  downToPreviousMinute,
}
