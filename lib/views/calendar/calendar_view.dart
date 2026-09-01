import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/hijri_calendar_service.dart';
import '../../core/services/ui_translation_service.dart';
import '../../models/tasbih_model.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/themed_illustration.dart';

import '../../l10n/app_localizations.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _currentDate = DateTime.now();
  String _calendarView = 'month';
  String _calendarBasis = 'gregorian';

  String _localizedHijriMonth(int month, String languageCode) =>
      UiTranslationService.hijriMonth(month, languageCode);

  String _localizedEventTitle(IslamicEventModel event, String languageCode) {
    if (languageCode == 'ar') return event.titleArabic;
    final key = '${event.month}-${event.day}';
    const values = <String, Map<String, String>>{
      'tr': {
        '1-1': 'Hicri Yılbaşı',
        '1-10': 'Aşure Günü',
        '3-12': 'Mevlid Kandili',
        '7-27': 'İsrâ ve Miraç',
        '8-15': 'Berat Gecesi',
        '9-1': 'Ramazan’ın İlk Günü',
        '9-27': 'Kadir Gecesi',
        '10-1': 'Ramazan Bayramı',
        '12-9': 'Arefe Günü',
        '12-10': 'Kurban Bayramı',
      },
      'de': {
        '1-1': 'Islamisches Neujahr',
        '1-10': 'Tag von Aschura',
        '3-12': 'Mawlid an-Nabi',
        '7-27': 'Isra und Miradsch',
        '8-15': 'Nacht von Bara’a',
        '9-1': 'Erster Tag des Ramadan',
        '9-27': 'Laylat al-Qadr',
        '10-1': 'Eid al-Fitr',
        '12-9': 'Tag von Arafat',
        '12-10': 'Eid al-Adha',
      },
      'ru': {
        '1-1': 'Исламский Новый год',
        '1-10': 'День Ашура',
        '3-12': 'Мавлид ан-Наби',
        '7-27': 'Исра и Мирадж',
        '8-15': 'Ночь Бараат',
        '9-1': 'Первый день Рамадана',
        '9-27': 'Ночь предопределения',
        '10-1': 'Ураза-байрам',
        '12-9': 'День Арафа',
        '12-10': 'Курбан-байрам',
      },
    };
    return values[languageCode]?[key] ?? event.title;
  }

  String _localizedEventDescription(
    IslamicEventModel event,
    String languageCode,
  ) {
    final key = '${event.month}-${event.day}';
    const values = <String, Map<String, String>>{
      'tr': {
        '1-1': 'Hicri ay takvimi yılının ilk günüdür.',
        '1-10':
            'Hz. Musa’nın kurtuluşunu anmak için tutulan sünnet orucu günüdür.',
        '3-12': 'Hz. Muhammed’in (sav) dünyaya gelişini anma günüdür.',
        '7-27': 'Mucizevi gece yolculuğu ve göğe yükseliş gecesidir.',
        '8-15': 'Bağışlanma ve ilahi takdir için önemli bir gecedir.',
        '9-1': 'Oruç ve vahiy ayı olan mübarek Ramazan’ın başlangıcıdır.',
        '9-27': 'Bin aydan daha hayırlı olan Kadir Gecesidir.',
        '10-1': 'Ramazan ayının tamamlanmasını kutlayan bayramdır.',
        '12-9': 'Haccın zirve günü ve bağışlanma için önemli bir gündür.',
        '12-10': 'Hz. İbrahim’in teslimiyetini anan Kurban Bayramıdır.',
      },
      'de': {
        '1-1': 'Der erste Tag des islamischen Mondkalenderjahres.',
        '1-10':
            'Ein Sunnah-Fastentag zur Erinnerung an die Rettung des Propheten Musa.',
        '3-12': 'Gedenken an die Geburt des Propheten Muhammad.',
        '7-27': 'Die wundersame Nachtreise und die himmlische Himmelfahrt.',
        '8-15':
            'Eine Nacht der Vergebung und Vorbereitung auf die göttliche Bestimmung.',
        '9-1': 'Beginn des gesegneten Monats des Fastens und der Offenbarung.',
        '9-27': 'Die Nacht der Bestimmung, besser als tausend Monate.',
        '10-1': 'Das Fest zum Abschluss des heiligen Monats Ramadan.',
        '12-9':
            'Der Höhepunkt des Haddsch und ein bedeutender Tag der Vergebung.',
        '12-10':
            'Das Opferfest zum Gedenken an die Hingabe des Propheten Ibrahim.',
      },
      'ru': {
        '1-1': 'Первый день исламского лунного календарного года.',
        '1-10': 'День желательного поста в память о спасении пророка Мусы.',
        '3-12': 'День памяти рождения пророка Мухаммада.',
        '7-27': 'Чудесное ночное путешествие и небесное вознесение.',
        '8-15': 'Ночь прощения и подготовки к божественному предопределению.',
        '9-1': 'Начало благословенного месяца поста и ниспослания Откровения.',
        '9-27': 'Ночь предопределения, которая лучше тысячи месяцев.',
        '10-1': 'Праздник завершения священного месяца Рамадан.',
        '12-9': 'Главный день хаджа и великий день прощения.',
        '12-10':
            'Праздник жертвоприношения в память о преданности пророка Ибрахима.',
      },
    };
    return values[languageCode]?[key] ?? event.description;
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final hijriInfo = HijriCalendarService.gregorianToHijri(_currentDate);
    final events = HijriCalendarService.getIslamicEvents();
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.islamicHijriCalendar,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14.0,
          bottom: bottomInset + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Hijri Month Banner with Crescent Illustration
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: deen.bgHeaderGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: deen.isDark
                      ? deen.accentGold.withOpacity(0.4)
                      : Colors.white.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: deen.accentPrimary.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _localizedHijriMonth(
                                  hijriInfo['month'] as int,
                                  languageCode,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                hijriInfo['monthNameArabic'] as String,
                                textDirection: TextDirection.rtl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.amiri(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: deen.accentGoldBright,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${hijriInfo['year']} AH',
                              style: GoogleFonts.outfit(
                                color: deen.accentGoldBright,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              intl.DateFormat.yMMMM(languageCode)
                                  .format(_currentDate),
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  const ThemedIllustration(
                    illustration: DeenIllustration.crescentStars,
                    size: 52,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildCalendarControls(deen, languageCode),
            const SizedBox(height: 10),
            _buildCalendarBody(deen, languageCode),
            const SizedBox(height: 20),

            // Fasting Sunnah Days Card
            DeenSectionHeader(
              title: l10n.sunnahFastingOpportunities,
              icon: Icons.brightness_2_rounded,
            ),
            const SizedBox(height: 8),
            DeenCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.brightness_2_outlined,
                        color: deen.accentGold,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.whiteDaysDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: deen.accentPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.weeklySunnahFastsDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Important Islamic Events & Holidays
            DeenSectionHeader(
              title: l10n.keyIslamicEvents,
              icon: Icons.event_note_rounded,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final ev = events[index];
                return DeenCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: deen.badgeBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: deen.badgeBorder),
                        ),
                        child: Text(
                          ev.hijriDate,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: deen.accentPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _localizedEventTitle(ev, languageCode),
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: deen.textPrimary,
                              ),
                            ),
                            Text(
                              _localizedEventDescription(ev, languageCode),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: deen.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarControls(DeenThemeTokens deen, String languageCode) {
    final hijri = HijriCalendarService.gregorianToHijri(_currentDate);
    final title = _calendarBasis == 'hijri'
        ? '${_localizedHijriMonth(hijri['month'] as int, languageCode)} ${hijri['year']} AH'
        : intl.DateFormat.yMMMM(languageCode).format(_currentDate);
    return DeenCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'gregorian',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      UiTranslationService.text('gregorian', languageCode)),
                ),
              ),
              ButtonSegment(
                value: 'hijri',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(UiTranslationService.text('hijri', languageCode)),
                ),
              ),
            ],
            selected: {_calendarBasis},
            onSelectionChanged: (value) =>
                setState(() => _calendarBasis = value.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'month',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(UiTranslationService.text('month', languageCode)),
                ),
              ),
              ButtonSegment(
                value: 'week',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(UiTranslationService.text('week', languageCode)),
                ),
              ),
              ButtonSegment(
                value: 'day',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(UiTranslationService.text('day', languageCode)),
                ),
              ),
            ],
            selected: {_calendarView},
            onSelectionChanged: (value) =>
                setState(() => _calendarView = value.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: () => _moveCalendar(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: deen.textPrimary,
                  ),
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _moveCalendar(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
              TextButton(
                onPressed: () => setState(() => _currentDate = DateTime.now()),
                child: Text(UiTranslationService.text('today', languageCode)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _moveCalendar(int direction) {
    setState(() {
      if (_calendarView == 'day') {
        _currentDate = _currentDate.add(Duration(days: direction));
      } else if (_calendarView == 'week') {
        _currentDate = _currentDate.add(Duration(days: 7 * direction));
      } else if (_calendarBasis == 'hijri') {
        _currentDate = _currentDate.add(Duration(days: 29 * direction));
      } else {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + direction,
          1,
        );
      }
    });
  }

  Widget _buildCalendarBody(DeenThemeTokens deen, String languageCode) {
    if (_calendarView == 'day') {
      return _buildDayCard(_currentDate, deen, languageCode, large: true);
    }
    if (_calendarView == 'week') {
      final start = _currentDate.subtract(
        Duration(days: _currentDate.weekday - DateTime.monday),
      );
      return DeenCard(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: List.generate(7, (index) {
            final date = start.add(Duration(days: index));
            return Expanded(
              child: InkWell(
                onTap: () => setState(() {
                  _currentDate = date;
                  _calendarView = 'day';
                }),
                child: _buildCompactDay(date, deen, languageCode),
              ),
            );
          }),
        ),
      );
    }

    final monthStart = DateTime(_currentDate.year, _currentDate.month, 1);
    final gridStart = monthStart.subtract(
      Duration(days: monthStart.weekday - DateTime.monday),
    );
    final weekdayLabels = List.generate(
      7,
      (index) =>
          intl.DateFormat.E(languageCode).format(DateTime(2026, 1, 5 + index)),
    );
    return DeenCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: deen.textMuted,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final date = gridStart.add(Duration(days: index));
              final outsideMonth = date.month != _currentDate.month;
              final selected = DateUtils.isSameDay(date, _currentDate);
              final today = DateUtils.isSameDay(date, DateTime.now());
              final hijri = HijriCalendarService.gregorianToHijri(date);
              final primary =
                  _calendarBasis == 'hijri' ? '${hijri['day']}' : '${date.day}';
              final secondary =
                  _calendarBasis == 'hijri' ? '${date.day}' : '${hijri['day']}';
              return InkWell(
                onTap: () => setState(() => _currentDate = date),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: selected
                        ? deen.accentPrimary
                        : today
                            ? deen.badgeBackground
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: today ? Border.all(color: deen.accentGold) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        primary,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: selected
                              ? Colors.white
                              : outsideMonth
                                  ? deen.textMuted.withOpacity(0.55)
                                  : deen.textPrimary,
                        ),
                      ),
                      Text(
                        secondary,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: selected ? Colors.white70 : deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildDayCard(_currentDate, deen, languageCode),
        ],
      ),
    );
  }

  Widget _buildCompactDay(
    DateTime date,
    DeenThemeTokens deen,
    String languageCode,
  ) {
    final hijri = HijriCalendarService.gregorianToHijri(date);
    final selected = DateUtils.isSameDay(date, _currentDate);
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? deen.accentPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          Text(
            intl.DateFormat.E(languageCode).format(date),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: selected ? Colors.white70 : deen.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _calendarBasis == 'hijri' ? '${hijri['day']}' : '${date.day}',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : deen.textPrimary,
            ),
          ),
          Text(
            _calendarBasis == 'hijri' ? '${date.day}' : '${hijri['day']}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: selected ? Colors.white70 : deen.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(
    DateTime date,
    DeenThemeTokens deen,
    String languageCode, {
    bool large = false,
  }) {
    final hijri = HijriCalendarService.gregorianToHijri(date);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.DateFormat.yMMMMEEEEd(languageCode).format(date),
          style: GoogleFonts.outfit(
            fontSize: large ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: deen.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${hijri['day']} ${_localizedHijriMonth(hijri['month'] as int, languageCode)} ${hijri['year']} AH',
          style: GoogleFonts.plusJakartaSans(
            fontSize: large ? 16 : 12,
            fontWeight: FontWeight.w700,
            color: deen.accentPrimary,
          ),
        ),
      ],
    );
    if (!large) return content;
    return DeenCard(padding: const EdgeInsets.all(22), child: content);
  }
}
