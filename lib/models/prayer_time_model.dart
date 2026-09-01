// prayer_time_model.dart
class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime qiyam;
  final DateTime date;
  final String calculationMethod;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.qiyam,
    required this.date,
    required this.calculationMethod,
  });

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
}

enum CalculationMethod {
  muslimWorldLeague,
  islamicSocietyOfNorthAmerica,
  egyptianGeneralAuthority,
  ummAlQuraMakkah,
  universityOfIslamicSciencesKarachi,
  instituteOfGeophysicsTehran,
  shiaIthnaAshari,
}

enum JuristicMethod {
  standard, // Legacy setting: equivalent to Shafi'i/Maliki/Hanbali
  hanafi,
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
