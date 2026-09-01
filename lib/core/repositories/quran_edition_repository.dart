// quran_edition_repository.dart
import '../../models/quran_language.dart';
import '../../models/quran_edition.dart';

class QuranEditionRepository {
  /// 14 Supported Languages for V1 Release
  static const List<QuranLanguage> supportedLanguages = [
    QuranLanguage(
      code: 'ar',
      englishName: 'Arabic',
      nativeName: 'العربية',
      isRtl: true,
    ),
    QuranLanguage(
      code: 'tr',
      englishName: 'Turkish',
      nativeName: 'Türkçe',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'en',
      englishName: 'English',
      nativeName: 'English',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'de',
      englishName: 'German',
      nativeName: 'Deutsch',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'fr',
      englishName: 'French',
      nativeName: 'Français',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'es',
      englishName: 'Spanish',
      nativeName: 'Español',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'ur',
      englishName: 'Urdu',
      nativeName: 'اردو',
      isRtl: true,
    ),
    QuranLanguage(
      code: 'id',
      englishName: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'ms',
      englishName: 'Malay',
      nativeName: 'Bahasa Melayu',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'ru',
      englishName: 'Russian',
      nativeName: 'Русский',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'fa',
      englishName: 'Persian',
      nativeName: 'فارسی',
      isRtl: true,
    ),
    QuranLanguage(
      code: 'bn',
      englishName: 'Bengali',
      nativeName: 'বাংলা',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'hi',
      englishName: 'Hindi',
      nativeName: 'हिन्दी',
      isRtl: false,
    ),
    QuranLanguage(
      code: 'pt',
      englishName: 'Portuguese',
      nativeName: 'Português',
      isRtl: false,
    ),
  ];

  /// Configurable Quran Translation Editions
  static const List<QuranEdition> _editions = [
    // --- Arabic Canonical ---
    QuranEdition(
      id: 'ara-quranacademy',
      languageCode: 'ar',
      languageName: 'Arabic',
      nativeLanguageName: 'العربية',
      translatorName: 'Quran Academy (Uthmani Text)',
      source: 'Quran Academy / Tanzil Project',
      apiEditionId: 'ara-quranacademy',
      approved: true,
      enabled: true,
      attribution:
          'Authentic Uthmani Quranic text based on standard Hafs recitation.',
      licenseStatus: 'Open Quranic Text',
      isRtl: true,
    ),
    QuranEdition(
      id: 'ara-kingfahadquranc',
      languageCode: 'ar',
      languageName: 'Arabic',
      nativeLanguageName: 'العربية',
      translatorName: 'King Fahad Quran Complex',
      source: 'King Fahad Complex for the Printing of the Holy Quran',
      apiEditionId: 'ara-kingfahadquranc',
      approved: true,
      enabled: false, // Keep integrated but reserved
      attribution: 'King Fahad Complex official Arabic scripture edition.',
      licenseStatus: 'Distribution Reserved',
      isRtl: true,
    ),

    // --- Turkish ---
    QuranEdition(
      id: 'tur-diyanetisleri',
      languageCode: 'tr',
      languageName: 'Turkish',
      nativeLanguageName: 'Türkçe',
      translatorName: 'Diyanet İşleri',
      source: 'Diyanet İşleri Başkanlığı Kur\'an Meali',
      apiEditionId: 'tur-diyanetisleri',
      approved: true,
      enabled: true,
      attribution:
          'Türkiye Cumhuriyeti Diyanet İşleri Başkanlığı Kur\'an-ı Kerim Meali.',
      licenseStatus:
          'Official Institution Meal (Separate Distribution Control)',
      isRtl: false,
    ),
    QuranEdition(
      id: 'tur-muhammedhamdiya',
      languageCode: 'tr',
      languageName: 'Turkish',
      nativeLanguageName: 'Türkçe',
      translatorName: 'Elmalılı Hamdi Yazır',
      source: 'Hak Dini Kur\'an Dili - Elmalılı M. Hamdi Yazır',
      apiEditionId: 'tur-muhammedhamdiya',
      approved: true,
      enabled: true,
      attribution:
          'Elmalılı Muhammed Hamdi Yazır sadeleştirilmiş Kur\'an meali.',
      licenseStatus: 'Public Domain Translation',
      isRtl: false,
    ),
    QuranEdition(
      id: 'tur-diyanetvakfi',
      languageCode: 'tr',
      languageName: 'Turkish',
      nativeLanguageName: 'Türkçe',
      translatorName: 'Diyanet Vakfı',
      source: 'Türkiye Diyanet Vakfı Kur\'an Meali',
      apiEditionId: 'tur-diyanetvakfi',
      approved: true,
      enabled: false, // Configurable alternate
      attribution: 'Türkiye Diyanet Vakfı Meali Heyeti.',
      licenseStatus: 'Pending Final Redistribution Review',
      isRtl: false,
    ),

    // --- English ---
    QuranEdition(
      id: 'eng-mustafakhattaba',
      languageCode: 'en',
      languageName: 'English',
      nativeLanguageName: 'English',
      translatorName: 'Dr. Mustafa Khattab',
      source: 'The Clear Quran Series',
      apiEditionId: 'eng-mustafakhattaba',
      approved: true,
      enabled: true,
      attribution:
          'The Clear Quran by Dr. Mustafa Khattab, authorized translation.',
      licenseStatus: 'Permission Granted / Al-Azhar Approved',
      isRtl: false,
    ),
    QuranEdition(
      id: 'eng-abdelhaleem',
      languageCode: 'en',
      languageName: 'English',
      nativeLanguageName: 'English',
      translatorName: 'M.A.S. Abdel Haleem',
      source: 'Oxford World\'s Classics',
      apiEditionId: 'eng-abdelhaleem',
      approved: true,
      enabled: true,
      attribution:
          'The Qur\'an translated by M. A. S. Abdel Haleem, Oxford University Press.',
      licenseStatus: 'Academic Reference',
      isRtl: false,
    ),
    QuranEdition(
      id: 'eng-abdullahyusufal',
      languageCode: 'en',
      languageName: 'English',
      nativeLanguageName: 'English',
      translatorName: 'Abdullah Yusuf Ali',
      source: 'The Meaning of the Holy Qur\'an',
      apiEditionId: 'eng-abdullahyusufal',
      approved: true,
      enabled: true,
      attribution: 'Classical English Translation by Abdullah Yusuf Ali.',
      licenseStatus: 'Public Domain',
      isRtl: false,
    ),

    // --- German ---
    QuranEdition(
      id: 'deu-asfbubenheimand',
      languageCode: 'de',
      languageName: 'German',
      nativeLanguageName: 'Deutsch',
      translatorName: 'A. S. F. Bubenheim & N. Elyas',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'deu-asfbubenheimand',
      approved: true,
      enabled: true,
      attribution:
          'Der edle Qur\'an und die Übersetzung seiner Bedeutungen in die deutsche Sprache.',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'deu-adeltheodorkhou',
      languageCode: 'de',
      languageName: 'German',
      nativeLanguageName: 'Deutsch',
      translatorName: 'Adel Theodor Khoury',
      source: 'Der Koran Übersetzung',
      apiEditionId: 'deu-adeltheodorkhou',
      approved: true,
      enabled: true,
      attribution: 'Deutsche Übersetzung von Prof. Adel Theodor Khoury.',
      licenseStatus: 'Verified Academic Reference',
      isRtl: false,
    ),
    QuranEdition(
      id: 'deu-aburidamuhammad',
      languageCode: 'de',
      languageName: 'German',
      nativeLanguageName: 'Deutsch',
      translatorName: 'Abu Rida Muhammad Ibn Ahmad',
      source: 'Ibn Rassoul Translation',
      apiEditionId: 'deu-aburidamuhammad',
      approved: true,
      enabled: true,
      attribution: 'Koranübersetzung von Muhammad Ibn Ahmad Ibn Rassoul.',
      licenseStatus: 'Public Educational Edition',
      isRtl: false,
    ),

    // --- French ---
    QuranEdition(
      id: 'fra-muhammadhamidul',
      languageCode: 'fr',
      languageName: 'French',
      nativeLanguageName: 'Français',
      translatorName: 'Muhammad Hamidullah',
      source: 'Complexe du Roi Fahd pour l\'impression du Noble Coran',
      apiEditionId: 'fra-muhammadhamidul',
      approved: true,
      enabled: true,
      attribution:
          'Le Saint Coran et la traduction de ses sens en langue française par le Dr. Muhammad Hamidullah.',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'fra-rashidmaash',
      languageCode: 'fr',
      languageName: 'French',
      nativeLanguageName: 'Français',
      translatorName: 'Rashid Maash',
      source: 'Maison d\'Ennour',
      apiEditionId: 'fra-rashidmaash',
      approved: true,
      enabled: true,
      attribution:
          'Le Coran et la traduction du sens de ses versets par Rashid Maash.',
      licenseStatus: 'Verified Modern Edition',
      isRtl: false,
    ),

    // --- Spanish ---
    QuranEdition(
      id: 'spa-muhammadisagarc',
      languageCode: 'es',
      languageName: 'Spanish',
      nativeLanguageName: 'Español',
      translatorName: 'Muhammad Isa García',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'spa-muhammadisagarc',
      approved: true,
      enabled: true,
      attribution:
          'El Sagrado Corán con traducción al idioma español por Muhammad Isa García.',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'spa-juliocortes',
      languageCode: 'es',
      languageName: 'Spanish',
      nativeLanguageName: 'Español',
      translatorName: 'Julio Cortés',
      source: 'Editorial Herder',
      apiEditionId: 'spa-juliocortes',
      approved: true,
      enabled: true,
      attribution: 'El Corán: Traducción, prólogo y notas por Julio Cortés.',
      licenseStatus: 'Academic Reference',
      isRtl: false,
    ),

    // --- Urdu ---
    QuranEdition(
      id: 'urd-abulaalamaududi',
      languageCode: 'ur',
      languageName: 'Urdu',
      nativeLanguageName: 'اردو',
      translatorName: 'Abul A\'la Maududi',
      source: 'Tafheem-ul-Quran (Urdu Tarjuma)',
      apiEditionId: 'urd-abulaalamaududi',
      approved: true,
      enabled: true,
      attribution: 'تفہیم القرآن ترجمہ سید ابوالاعلیٰ مودودی۔',
      licenseStatus: 'Public Islamic Resource',
      isRtl: true,
    ),
    QuranEdition(
      id: 'urd-fatehmuhammadja',
      languageCode: 'ur',
      languageName: 'Urdu',
      nativeLanguageName: 'اردو',
      translatorName: 'Fateh Muhammad Jalandhry',
      source: 'Jalandhry Translation',
      apiEditionId: 'urd-fatehmuhammadja',
      approved: true,
      enabled: true,
      attribution: 'قرآن مجید کا سلیس اردو ترجمہ مولانا فتح محمد جالندھری۔',
      licenseStatus: 'Public Domain',
      isRtl: true,
    ),
    QuranEdition(
      id: 'urd-muhammadjunagar',
      languageCode: 'ur',
      languageName: 'Urdu',
      nativeLanguageName: 'اردو',
      translatorName: 'Muhammad Junagarhi',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'urd-muhammadjunagar',
      approved: true,
      enabled: true,
      attribution:
          'قرآن مجید کا ترجمہ مولانا محمد جوناگڑھی، مجمع ملک فہد برائے طباعت قرآن کریم۔',
      licenseStatus: 'King Fahd Complex Verified',
      isRtl: true,
    ),

    // --- Indonesian ---
    QuranEdition(
      id: 'ind-indonesianislam',
      languageCode: 'id',
      languageName: 'Indonesian',
      nativeLanguageName: 'Bahasa Indonesia',
      translatorName: 'Kementerian Agama RI',
      source: 'Kementerian Agama Republik Indonesia (Kemenag)',
      apiEditionId: 'ind-indonesianislam',
      approved: true,
      enabled: true,
      attribution:
          'Al-Qur\'an dan Terjemahannya oleh Departemen Agama Republik Indonesia.',
      licenseStatus: 'Government Religious Authority Edition',
      isRtl: false,
    ),
    QuranEdition(
      id: 'ind-kingfahdcomplex',
      languageCode: 'id',
      languageName: 'Indonesian',
      nativeLanguageName: 'Bahasa Indonesia',
      translatorName: 'King Fahd Complex',
      source: 'King Fahd Quran Printing Complex Indonesia Section',
      apiEditionId: 'ind-kingfahdcomplex',
      approved: true,
      enabled: true,
      attribution:
          'Al-Qur\'an dan Terjemahannya oleh Kompleks Percetakan Al-Qur\'an Raja Fahd.',
      licenseStatus: 'King Fahd Complex Verified',
      isRtl: false,
    ),

    // --- Malay ---
    QuranEdition(
      id: 'msa-abdullahmuhamma',
      languageCode: 'ms',
      languageName: 'Malay',
      nativeLanguageName: 'Bahasa Melayu',
      translatorName: 'Abdullah Muhammad Basmeih',
      source: 'Tafsir Pimpinan Ar-Rahman Kepada Pengertian Al-Quran',
      apiEditionId: 'msa-abdullahmuhamma',
      approved: true,
      enabled: true,
      attribution:
          'Tafsir Pimpinan Ar-Rahman oleh Sheikh Abdullah Muhammad Basmeih (JAKIM).',
      licenseStatus: 'Official National Translation (Malaysia)',
      isRtl: false,
    ),

    // --- Russian ---
    QuranEdition(
      id: 'rus-elmirkuliev',
      languageCode: 'ru',
      languageName: 'Russian',
      nativeLanguageName: 'Русский',
      translatorName: 'Elmir Kuliev',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'rus-elmirkuliev',
      approved: true,
      enabled: true,
      attribution:
          'Смысловой перевод Священного Корана на русский язык Э. Р. Кулиева.',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'rus-ministryofawqaf',
      languageCode: 'ru',
      languageName: 'Russian',
      nativeLanguageName: 'Русский',
      translatorName: 'Ministry of Awqaf, Egypt',
      source: 'Supreme Council for Islamic Affairs, Cairo',
      apiEditionId: 'rus-ministryofawqaf',
      approved: true,
      enabled: true,
      attribution:
          'Аль-Мунтахаб фи тафсир аль-Куран аль-Карим (Министерство вакуфов Египта).',
      licenseStatus: 'Official Religious Council Edition',
      isRtl: false,
    ),

    // --- Persian ---
    QuranEdition(
      id: 'fas-hussainansarian',
      languageCode: 'fa',
      languageName: 'Persian',
      nativeLanguageName: 'فارسی',
      translatorName: 'Hussain Ansarian',
      source: 'Ansarian Translation Bureau',
      apiEditionId: 'fas-hussainansarian',
      approved: true,
      enabled: true,
      attribution: 'ترجمه استاد حسین انصاریان.',
      licenseStatus: 'Public Islamic Resource',
      isRtl: true,
    ),
    QuranEdition(
      id: 'fas-mohammadkazemmo',
      languageCode: 'fa',
      languageName: 'Persian',
      nativeLanguageName: 'فارسی',
      translatorName: 'Mohammad Kazem Moezzi',
      source: 'Moezzi Publication',
      apiEditionId: 'fas-mohammadkazemmo',
      approved: true,
      enabled: true,
      attribution: 'ترجمه قرآن کریم توسط حجت‌الاسلام محمدکاظم معزی.',
      licenseStatus: 'Public Domain',
      isRtl: true,
    ),

    // --- Bengali ---
    QuranEdition(
      id: 'ben-muhiuddinkhan',
      languageCode: 'bn',
      languageName: 'Bengali',
      nativeLanguageName: 'বাংলা',
      translatorName: 'Muhiuddin Khan',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'ben-muhiuddinkhan',
      approved: true,
      enabled: true,
      attribution:
          'পবিত্র কুরআনুল করীম (বাংলা অনুবাদ ও সংক্ষিপ্ত তফসীর) - মাওলানা মুহিউদ্দীন খান।',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'ben-abubakrzakaria',
      languageCode: 'bn',
      languageName: 'Bengali',
      nativeLanguageName: 'বাংলা',
      translatorName: 'Abu Bakr Zakaria',
      source: 'King Fahd Quran Complex Bengali Section',
      apiEditionId: 'ben-abubakrzakaria',
      approved: true,
      enabled: true,
      attribution:
          'কুরআনুল কারীম (অনুবাদ ও সংক্ষিপ্ত ব্যাখ্যা) - ড. আবূ বকর মুহাম্মাদ যাকারিয়া।',
      licenseStatus: 'King Fahd Complex Verified',
      isRtl: false,
    ),

    // --- Hindi ---
    QuranEdition(
      id: 'hin-suhelfarooqkhan',
      languageCode: 'hi',
      languageName: 'Hindi',
      nativeLanguageName: 'हिन्दी',
      translatorName: 'Suhel Farooq Khan & Saifur Rahman',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'hin-suhelfarooqkhan',
      approved: true,
      enabled: true,
      attribution:
          'पवित्र क़ुरआन और उसकी आयतों का हिन्दी अनुवाद (फ़ारूक़ ख़ान एवं सैफ़ुर रहमान नदवी)।',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'hin-muhammadfarooqk',
      languageCode: 'hi',
      languageName: 'Hindi',
      nativeLanguageName: 'हिन्दी',
      translatorName: 'Muhammad Farooq Khan & M. Ahmed',
      source: 'Maktaba Al-Hasanat',
      apiEditionId: 'hin-muhammadfarooqk',
      approved: true,
      enabled: true,
      attribution: 'क़ुरआन मजीद का आसान हिन्दी अनुवाद - मुहम्मद फ़ारूक़ ख़ान।',
      licenseStatus: 'Verified Islamic Publication',
      isRtl: false,
    ),

    // --- Portuguese ---
    QuranEdition(
      id: 'por-helminasr',
      languageCode: 'pt',
      languageName: 'Portuguese',
      nativeLanguageName: 'Português',
      translatorName: 'Helmi Nasr',
      source: 'King Fahd Holy Quran Printing Complex',
      apiEditionId: 'por-helminasr',
      approved: true,
      enabled: true,
      attribution:
          'Tradução do Sentido do Nobre Alcorão para a Língua Portuguesa pelo Prof. Dr. Helmi Nasr.',
      licenseStatus: 'King Fahd Complex / Tanzil Open',
      isRtl: false,
    ),
    QuranEdition(
      id: 'por-samirelhayek',
      languageCode: 'pt',
      languageName: 'Portuguese',
      nativeLanguageName: 'Português',
      translatorName: 'Samir El-Hayek',
      source: 'Fundação Salim Nasser / WAMY Brasil',
      apiEditionId: 'por-samirelhayek',
      approved: true,
      enabled: true,
      attribution: 'Tradução do Alcorão Sagrado por Samir El Hayek.',
      licenseStatus: 'Public Islamic Resource',
      isRtl: false,
    ),
  ];

  /// Get all editions (including those disabled or pending review)
  static List<QuranEdition> get allEditions => _editions;

  /// Get all approved & enabled editions
  static List<QuranEdition> get approvedEditions =>
      _editions.where((e) => e.approved && e.enabled).toList();

  /// Get approved & enabled editions for a specific language code
  static List<QuranEdition> getEditionsForLanguage(String languageCode) {
    return _editions
        .where((e) => e.languageCode == languageCode && e.approved && e.enabled)
        .toList();
  }

  /// Get default edition for a language code
  static QuranEdition? getDefaultEditionForLanguage(String languageCode) {
    final list = getEditionsForLanguage(languageCode);
    if (list.isNotEmpty) return list.first;

    // If no enabled edition found, check approved ones
    final approvedList = _editions
        .where((e) => e.languageCode == languageCode && e.approved)
        .toList();
    if (approvedList.isNotEmpty) return approvedList.first;

    return null;
  }

  /// Get edition by ID
  static QuranEdition? getEditionById(String editionId) {
    try {
      return _editions.firstWhere(
        (e) => e.id == editionId || e.apiEditionId == editionId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get language metadata by code
  static QuranLanguage? getLanguageByCode(String code) {
    try {
      return supportedLanguages.firstWhere((l) => l.code == code);
    } catch (_) {
      return null;
    }
  }
}
