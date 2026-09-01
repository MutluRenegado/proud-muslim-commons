import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/hijri_calendar_service.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/islamic_pattern_background.dart';
import '../../widgets/prayer_card.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/themed_illustration.dart';
import '../prayer/prayer_times_view.dart';
import '../qibla/qibla_view.dart';
import '../quran/quran_view.dart';
import '../hadith/hadith_view.dart';
import '../azkar/azkar_view.dart';
import '../tasbih/tasbih_view.dart';
import '../calendar/calendar_view.dart';
import '../zakat/zakat_view.dart';
import '../learn/learn_view.dart';
import '../profile/profile_view.dart';

import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final times = prayerProv.todayPrayerTimes;
    final l10n = AppLocalizations.of(context)!;
    final deen = context.deen;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      body: CustomScrollView(
        slivers: [
          // Luminous Modern Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: deen.accentPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: deen.bgHeaderGradient),
                  ),
                  CustomPaint(
                    painter: IslamicPatternPainter(
                      color: Colors.white.withOpacity(0.09),
                      strokeWidth: 1.0,
                    ),
                  ),
                  Positioned(
                    top: 79,
                    right: AppSpacing.screenMargin,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 250),
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: deen.accentGold.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.12),
                            blurRadius: 3,
                            offset: const Offset(-1, -1),
                          ),
                        ],
                      ),
                      child: Text(
                        prayerProv.getHijriDateFormattedArabic(),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.amiri(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.screenMargin,
                    right: AppSpacing.screenMargin,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _localizedHijriDate(context, prayerProv),
                              style: GoogleFonts.outfit(
                                color: deen.accentGoldBright,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _localizedLocation(
                                  context,
                                  prayerProv.city,
                                  prayerProv.country,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: Directionality.of(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              l10n.appName,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: Builder(
                  builder: (context) {
                    final photoPath = StorageService.userProfilePhotoPath;
                    if (photoPath != null && File(photoPath).existsSync()) {
                      return Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: FileImage(File(photoPath)),
                        ),
                      );
                    }
                    return const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                    );
                  },
                ),
                tooltip: l10n.profileAndSettings,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                ),
              ),
            ],
          ),

          // Main Screen Body
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.screenMargin,
                right: AppSpacing.screenMargin,
                top: 18.0,
                bottom: bottomInset + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Next Prayer Countdown Hero Card
                  _buildHomeDepthSurface(
                    deen,
                    child: CountdownTimerWidget(
                      nextPrayer: _localizedPrayerName(
                        l10n,
                        prayerProv.nextPrayer,
                      ),
                      remainingTime: prayerProv.timeUntilNextPrayer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // 2. Explore Deen Visual Hub with Themed Vector Illustrations
                  DeenSectionHeader(
                    title: l10n.exploreDeen,
                    icon: Icons.grid_view_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildQuickAccessGrid(context, l10n, deen),

                  const SizedBox(height: AppSpacing.xxl),

                  // 3. Today's Prayer Times Summary Strip
                  DeenSectionHeader(
                    title: l10n.todayPrayers,
                    icon: Icons.schedule_rounded,
                    actionText: l10n.fullTimetable,
                    onActionTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrayerTimesView(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (times != null) ...[
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.fajr,
                        time: times.fajr,
                        isNext: prayerProv.nextPrayer == 'Fajr',
                        icon: Icons.nights_stay_outlined,
                      ),
                    ),
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.sunrise,
                        time: times.sunrise,
                        isNext: prayerProv.nextPrayer == 'Sunrise',
                        icon: Icons.wb_twilight,
                      ),
                    ),
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.dhuhr,
                        time: times.dhuhr,
                        isNext: prayerProv.nextPrayer == 'Dhuhr',
                        icon: Icons.wb_sunny_outlined,
                      ),
                    ),
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.asr,
                        time: times.asr,
                        isNext: prayerProv.nextPrayer == 'Asr',
                        icon: Icons.wb_cloudy_outlined,
                      ),
                    ),
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.maghrib,
                        time: times.maghrib,
                        isNext: prayerProv.nextPrayer == 'Maghrib',
                        icon: Icons.bedtime_outlined,
                      ),
                    ),
                    _buildPrayerDepthCard(
                      deen,
                      PrayerCard(
                        prayerName: l10n.isha,
                        time: times.isha,
                        isNext: prayerProv.nextPrayer == 'Isha',
                        icon: Icons.dark_mode_outlined,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),

                  // 4. Daily Hadith Card with Rehal/Book motif
                  _buildDailyHadithCard(context, l10n, deen),

                  const SizedBox(height: AppSpacing.l),

                  // 5. Daily Ayah Inspiration Card with Calligraphy
                  _buildDailyAyahCard(context, l10n, deen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDepthSurface(
    DeenThemeTokens deen, {
    required Widget child,
    double radius = AppRadius.xl,
  }) {
    return Transform.translate(
      offset: const Offset(0, -3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(deen.isDark ? 0.42 : 0.24),
              blurRadius: 18,
              spreadRadius: -3,
              offset: const Offset(0, 11),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(deen.isDark ? 0.06 : 0.6),
              blurRadius: 5,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildPrayerDepthCard(DeenThemeTokens deen, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: _buildHomeDepthSurface(deen, radius: AppRadius.l, child: child),
    );
  }

  String _localizedHijriDate(BuildContext context, PrayerProvider prayerProv) {
    final info = HijriCalendarService.gregorianToHijri(
      DateTime.now(),
      StorageService.hijriOffset,
    );
    final lang = Localizations.localeOf(context).languageCode;
    final day = info['day'];
    final month = UiTranslationService.hijriMonth(info['month'] as int, lang);
    final year = info['year'];
    return '$day $month $year AH';
  }

  String _localizedPrayerName(AppLocalizations l10n, String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return l10n.fajr;
      case 'Sunrise':
        return l10n.sunrise;
      case 'Dhuhr':
        return l10n.dhuhr;
      case 'Asr':
        return l10n.asr;
      case 'Maghrib':
        return l10n.maghrib;
      case 'Isha':
        return l10n.isha;
      default:
        return prayerName;
    }
  }

  String _localizedLocation(BuildContext context, String city, String country) {
    final languageCode = Localizations.localeOf(context).languageCode;
    const makkahNames = <String, String>{
      'ar': 'مكة',
      'de': 'Mekka',
      'en': 'Makkah',
      'es': 'La Meca',
      'fr': 'La Mecque',
      'id': 'Makkah',
      'ms': 'Makkah',
      'pt': 'Meca',
      'ru': 'Мекка',
      'tr': 'Mekke',
      'ur': 'مکہ',
    };
    const saudiArabiaNames = <String, String>{
      'ar': 'المملكة العربية السعودية',
      'de': 'Saudi-Arabien',
      'en': 'Saudi Arabia',
      'es': 'Arabia Saudita',
      'fr': 'Arabie saoudite',
      'id': 'Arab Saudi',
      'ms': 'Arab Saudi',
      'pt': 'Arábia Saudita',
      'ru': 'Саудовская Аравия',
      'tr': 'Suudi Arabistan',
      'ur': 'سعودی عرب',
    };

    final cityKey = city.trim().toLowerCase();
    final countryKey = country.trim().toLowerCase();
    final isMakkah =
        cityKey == 'makkah' || cityKey == 'mecca' || cityKey == 'meccah';
    final isSaudi =
        countryKey == 'saudi arabia' || countryKey == 'saudia arabia';
    final localizedCity = isMakkah ? (makkahNames[languageCode] ?? city) : city;
    final localizedCountry =
        isSaudi ? (saudiArabiaNames[languageCode] ?? country) : country;
    return '$localizedCity, $localizedCountry';
  }

  String? _dailyHadithTranslation(String languageCode) {
    const translations = <String, String>{
      'tr':
          'Ameller niyetlere göredir ve herkese ancak niyet ettiği şey vardır.',
      'de':
          'Die Taten werden nach den Absichten beurteilt, und jedem Menschen steht nur das zu, was er beabsichtigt hat.',
      'fr':
          'Les actes ne valent que par les intentions, et chacun n’obtient que ce qu’il a eu l’intention de faire.',
      'es':
          'Las acciones son juzgadas según las intenciones, y cada persona obtendrá aquello que haya pretendido.',
      'pt':
          'As ações são julgadas pelas intenções, e cada pessoa terá apenas aquilo que pretendeu.',
      'ru':
          'Поистине, дела оцениваются по намерениям, и каждому человеку достанется лишь то, что он намеревался обрести.',
      'id':
          'Sesungguhnya setiap amalan bergantung pada niatnya, dan setiap orang memperoleh sesuai dengan apa yang diniatkannya.',
      'ms':
          'Sesungguhnya segala amalan bergantung pada niat, dan setiap orang mendapat apa yang diniatkannya.',
      'ur':
          'اعمال کا دارومدار نیتوں پر ہے اور ہر شخص کے لیے وہی ہے جس کی اس نے نیت کی۔',
    };
    return translations[languageCode];
  }

  String? _dailyAyahTranslation(String languageCode) {
    const translations = <String, String>{
      'tr':
          'Şüphesiz güçlükle beraber bir kolaylık vardır. Gerçekten, güçlükle beraber bir kolaylık vardır.',
      'de':
          'Gewiss, mit der Erschwernis ist Erleichterung. Gewiss, mit der Erschwernis ist Erleichterung.',
      'fr':
          'À côté de la difficulté est, certes, une facilité. Oui, à côté de la difficulté est une facilité.',
      'es':
          'Ciertamente, con la dificultad viene la facilidad. En verdad, con la dificultad viene la facilidad.',
      'pt':
          'Certamente, com a dificuldade vem a facilidade. Em verdade, com a dificuldade vem a facilidade.',
      'ru':
          'Воистину, за каждой тягостью наступает облегчение. За каждой тягостью наступает облегчение.',
      'id':
          'Sesungguhnya bersama kesulitan ada kemudahan. Sesungguhnya bersama kesulitan ada kemudahan.',
      'ms':
          'Sesungguhnya bersama kesukaran ada kemudahan. Sesungguhnya bersama kesukaran ada kemudahan.',
      'ur': 'پس بے شک مشکل کے ساتھ آسانی ہے۔ بے شک مشکل کے ساتھ آسانی ہے۔',
    };
    return translations[languageCode];
  }

  Widget _buildQuickAccessGrid(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final items = [
      {
        'title': l10n.holyQuran,
        'illustration': DeenIllustration.quranRehal,
        'page': const QuranView(),
      },
      {
        'title': l10n.qiblaFinder,
        'illustration': DeenIllustration.kaabaMecca,
        'page': const QiblaView(),
      },
      {
        'title': l10n.dailyAzkar,
        'illustration': DeenIllustration.lantern,
        'page': const AzkarView(),
      },
      {
        'title': l10n.digitalTasbih,
        'illustration': DeenIllustration.tasbihBeads,
        'page': const TasbihView(),
      },
      {
        'title': l10n.hadith40,
        'illustration': DeenIllustration.duaHands,
        'page': const HadithView(),
      },
      {
        'title': l10n.hijriCalendar,
        'illustration': DeenIllustration.crescentStars,
        'page': const CalendarView(),
      },
      {
        'title': l10n.zakatCalculator,
        'illustration': DeenIllustration.islamicArch,
        'page': const ZakatView(),
      },
      {
        'title': l10n.salahAnd99Names,
        'illustration': DeenIllustration.prayerMat,
        'page': const LearnView(),
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final page = item['page'] as Widget;
        final illustration = item['illustration'] as DeenIllustration;

        return _buildHomeDepthSurface(
          deen,
          radius: AppRadius.l,
          child: DeenCard(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(deen.isDark ? 0.10 : 0.75),
                        deen.accentPrimary.withOpacity(0.10),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 2,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: ThemedIllustration(
                    illustration: illustration,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: deen.textPrimary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyHadithCard(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    const englishTranslation =
        'Actions are judged by intentions, and every person will indeed have only that which he intended.';
    final targetTranslation = _dailyHadithTranslation(
      Localizations.localeOf(context).languageCode,
    );
    return _buildHomeDepthSurface(
      deen,
      child: DeenCard(
        isHero: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: deen.accentGold.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.format_quote_rounded,
                        color: deen.accentGold,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.dailyHadithGem,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: deen.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: deen.accentPrimary,
                  ),
                  tooltip: l10n.shareHadith,
                  onPressed: () {
                    Share.share(
                      'Daily Hadith:\n\nإِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ\n\n$englishTranslation${targetTranslation == null ? '' : '\n\n$targetTranslation'}\n\n— Sahih al-Bukhari & Muslim\n\nShared via Proud Muslim App',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: deen.arabicPrimary,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'English\n"$englishTranslation"',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: deen.textPrimary,
                height: 1.4,
              ),
            ),
            if (targetTranslation != null) ...[
              const SizedBox(height: 8),
              Text(
                targetTranslation,
                textDirection: Directionality.of(context),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: deen.accentPrimary,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— Sahih al-Bukhari & Muslim',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: deen.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAyahCard(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    const englishTranslation =
        'For indeed, with hardship comes ease. Indeed, with hardship comes ease.';
    final targetTranslation = _dailyAyahTranslation(
      Localizations.localeOf(context).languageCode,
    );
    return Container(
      padding: AppSpacing.cardPaddingComfortable,
      decoration: BoxDecoration(
        gradient: deen.bgHeaderGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: deen.isDark
              ? deen.accentGold.withOpacity(0.35)
              : Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(deen.isDark ? 0.45 : 0.28),
            blurRadius: 22,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.16),
            blurRadius: 5,
            offset: const Offset(-3, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: deen.accentGoldBright,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.ayahOfTheDay,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
                tooltip: l10n.shareAyah,
                onPressed: () {
                  Share.share(
                    'Ayah of the Day:\n\nفَإِنَّ مَعَ الْعُسْرِ يُسْرًا\n\n$englishTranslation${targetTranslation == null ? '' : '\n\n$targetTranslation'}\n\n— Surah Ash-Sharh (94:5-6)\n\nShared via Proud Muslim App',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا • إِنَّ مَعَ الْعُسْرِ يُسْرًا',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'English\n"$englishTranslation"',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          if (targetTranslation != null) ...[
            const SizedBox(height: 8),
            Text(
              targetTranslation,
              textDirection: Directionality.of(context),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: deen.accentGoldBright,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— Surah Ash-Sharh (94:5-6)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: deen.accentGoldBright,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
