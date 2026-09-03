import '../../models/tasbih_model.dart';

class HijriCalendarService {
  static const List<String> hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabi al-Awwal',
    'Rabi al-Thani',
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  static const List<String> hijriMonthsTr = [
    'Muharrem',
    'Safer',
    'Rebiülevvel',
    'Rebiülahir',
    'Cemaziyelevvel',
    'Cemaziyelahir',
    'Recep',
    'Şaban',
    'Ramazan',
    'Şevval',
    'Zilkade',
    'Zilhicce',
  ];

  static const List<String> hijriMonthsAr = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  /// Converts a local Gregorian date into the Hijri date.
  /// Uses Kuwati/Astronomical algorithm with optional offsetDays (-2 to +2).
  static Map<String, dynamic> gregorianToHijri(
    DateTime localDate, [
    int offsetDays = 0,
  ]) {
    // Clamping offset between -2 and +2
    final clampedOffset = offsetDays.clamp(-2, 2);
    final adjusted = localDate.add(Duration(days: clampedOffset));
    int d = adjusted.day;
    int m = adjusted.month;
    int y = adjusted.year;

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        ((l / 5670).floor()) * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    int hm = ((24 * l) / 709).floor();
    int hd = l - ((709 * hm) / 24).floor();
    int hy = 30 * n + j - 30;

    int monthIdx = (hm - 1).clamp(0, 11);
    final day = hd.clamp(1, 30);
    final month = hm.clamp(1, 12);
    final year = hy;
    final monthName = hijriMonthsEn[monthIdx];
    final monthNameTr = hijriMonthsTr[monthIdx];
    final monthNameArabic = hijriMonthsAr[monthIdx];

    return {
      'day': day,
      'month': month,
      'year': year,
      'monthName': monthName,
      'monthNameTr': monthNameTr,
      'monthNameArabic': monthNameArabic,
      'formatted': '$day $monthName $year AH',
      'formattedTr': '$day $monthNameTr $year Hicri',
      'formattedArabic': '$day $monthNameArabic $year هـ',
    };
  }

  static List<IslamicEventModel> getIslamicEvents([int? hijriYear]) {
    final year = hijriYear ?? (gregorianToHijri(DateTime.now())['year'] as int);
    return [
      IslamicEventModel(
        title: 'Islamic New Year',
        titleArabic: 'رأس السنة الهجرية',
        hijriDate: '1 Muharram $year',
        description: 'First day of the Islamic lunar calendar year.',
        category: 'Major Event',
        month: 1,
        day: 1,
      ),
      IslamicEventModel(
        title: 'Day of Ashura',
        titleArabic: 'يوم عاشوراء',
        hijriDate: '10 Muharram $year',
        description:
            'Sunnah fast commemorating the salvation of Prophet Musa (AS).',
        category: 'Fasting & Sunnah',
        month: 1,
        day: 10,
      ),
      IslamicEventModel(
        title: 'Mawlid al-Nabi',
        titleArabic: 'المولد النبوي الشريف',
        hijriDate: '12 Rabi al-Awwal $year',
        description: 'Birth of Prophet Muhammad (SAW).',
        category: 'Blessed Occasion',
        month: 3,
        day: 12,
      ),
      IslamicEventModel(
        title: 'Isra and Mi\'raj',
        titleArabic: 'الإسراء والمعراج',
        hijriDate: '27 Rajab $year',
        description: 'The miraculous Night Journey and Heavenly Ascension.',
        category: 'Miracle & History',
        month: 7,
        day: 27,
      ),
      IslamicEventModel(
        title: 'Laylat al-Bara\'ah (Mid-Sha\'ban)',
        titleArabic: 'ليلة البراءة',
        hijriDate: '15 Sha\'ban $year',
        description: 'Night of forgiveness and divine decree preparation.',
        category: 'Blessed Night',
        month: 8,
        day: 15,
      ),
      IslamicEventModel(
        title: 'First Day of Ramadan',
        titleArabic: 'أول أيام شهر رمضان المبارك',
        hijriDate: '1 Ramadan $year',
        description:
            'Beginning of the blessed month of fasting and revelation.',
        category: 'Fasting & Worship',
        month: 9,
        day: 1,
      ),
      IslamicEventModel(
        title: 'Laylat al-Qadr',
        titleArabic: 'ليلة القدر',
        hijriDate: '27 Ramadan $year',
        description: 'The Night of Power, better than a thousand months.',
        category: 'Sacred Night',
        month: 9,
        day: 27,
      ),
      IslamicEventModel(
        title: 'Eid al-Fitr',
        titleArabic: 'عيد الفطر المبارk',
        hijriDate: '1 Shawwal $year',
        description:
            'Celebration marking the conclusion of the holy month of Ramadan.',
        category: 'Major Eid',
        month: 10,
        day: 1,
      ),
      IslamicEventModel(
        title: 'Day of Arafah',
        titleArabic: 'يوم عرفة',
        hijriDate: '9 Dhu al-Hijjah $year',
        description: 'The pinnacle day of Hajj and supreme day of forgiveness.',
        category: 'Sacred Day',
        month: 12,
        day: 9,
      ),
      IslamicEventModel(
        title: 'Eid al-Adha',
        titleArabic: 'عيد الأضحى المبارك',
        hijriDate: '10 Dhu al-Hijjah $year',
        description:
            'Feast of the Sacrifice commemorating Prophet Ibrahim\'s devotion.',
        category: 'Major Eid',
        month: 12,
        day: 10,
      ),
    ];
  }
}
