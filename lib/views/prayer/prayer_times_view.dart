import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/prayer_time_model.dart';
import '../../providers/prayer_provider.dart';
import '../../core/services/prayer_calculation_service.dart';
import '../../widgets/prayer_card.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class PrayerTimesView extends StatefulWidget {
  const PrayerTimesView({super.key});

  @override
  State<PrayerTimesView> createState() => _PrayerTimesViewState();
}

class _PrayerTimesViewState extends State<PrayerTimesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final times = prayerProv.todayPrayerTimes;
    final l10n = AppLocalizations.of(context)!;
    final deen = context.deen;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.prayerTimesAndSchedule,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: deen.accentGold,
          indicatorWeight: 3,
          labelColor: deen.accentGold,
          unselectedLabelColor: deen.textSecondary,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              text: l10n.todaysSchedule,
              icon: const Icon(Icons.today_rounded, size: 20),
            ),
            Tab(
              text: l10n.monthlyTimetable,
              icon: const Icon(Icons.calendar_month_rounded, size: 20),
            ),
          ],
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpPrayerTimesTitle,
            description: l10n.helpPrayerTimesDesc,
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded, color: deen.accentPrimary),
            tooltip: l10n.calculationMethod,
            onPressed: () =>
                _showCalculationSettings(context, prayerProv, l10n, deen),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Today Tab
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.screenMargin,
              right: AppSpacing.screenMargin,
              top: 16,
              bottom: bottomInset + 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Location Info Banner
                DeenCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM yyyy')
                                .format(DateTime.now()),
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: deen.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prayerProv.getHijriDateFormatted(),
                            style: GoogleFonts.plusJakartaSans(
                              color: deen.accentGold,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: deen.badgeBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: deen.badgeBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: deen.accentPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              prayerProv.city,
                              style: GoogleFonts.plusJakartaSans(
                                color: deen.accentPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Prayer Cards List
                if (times != null) ...[
                  PrayerCard(
                    prayerName: '${l10n.fajr} (Dawn)',
                    time: times.fajr,
                    isNext: prayerProv.nextPrayer == 'Fajr',
                    icon: Icons.nights_stay_outlined,
                  ),
                  PrayerCard(
                    prayerName: '${l10n.sunrise} (Shuruq)',
                    time: times.sunrise,
                    isNext: prayerProv.nextPrayer == 'Sunrise',
                    icon: Icons.wb_twilight,
                  ),
                  PrayerCard(
                    prayerName: '${l10n.dhuhr} (Noon)',
                    time: times.dhuhr,
                    isNext: prayerProv.nextPrayer == 'Dhuhr',
                    icon: Icons.wb_sunny_outlined,
                  ),
                  PrayerCard(
                    prayerName: '${l10n.asr} (Afternoon)',
                    time: times.asr,
                    isNext: prayerProv.nextPrayer == 'Asr',
                    icon: Icons.wb_cloudy_outlined,
                  ),
                  PrayerCard(
                    prayerName: '${l10n.maghrib} (Sunset)',
                    time: times.maghrib,
                    isNext: prayerProv.nextPrayer == 'Maghrib',
                    icon: Icons.bedtime_outlined,
                  ),
                  PrayerCard(
                    prayerName: '${l10n.isha} (Night)',
                    time: times.isha,
                    isNext: prayerProv.nextPrayer == 'Isha',
                    icon: Icons.dark_mode_outlined,
                  ),
                  PrayerCard(
                    prayerName: l10n.qiyam,
                    time: times.qiyam,
                    isNext: false,
                    icon: Icons.hotel_class_outlined,
                  ),
                ],
                const SizedBox(height: 18),

                // Calculation info card
                DeenCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: deen.accentGold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.calculationMethod,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: deen.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prayerProv.method.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: deen.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.juristicSchool,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: deen.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _juristicLabel(prayerProv.juristic),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Monthly Timetable Tab
          _buildMonthlyTable(context, prayerProv, bottomInset, deen),
        ],
      ),
    );
  }

  Widget _buildMonthlyTable(
    BuildContext context,
    PrayerProvider prayerProv,
    double bottomInset,
    DeenThemeTokens deen,
  ) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final List<PrayerTimesModel> monthTimes = [];

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(now.year, now.month, d);
      monthTimes.add(
        PrayerCalculationService.calculatePrayerTimes(
          date: date,
          latitude: prayerProv.latitude,
          longitude: prayerProv.longitude,
          method: prayerProv.method,
          juristic: prayerProv.juristic,
          minuteOffsets: prayerProv.minuteOffsets,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: bottomInset + 32,
      ),
      itemCount: monthTimes.length,
      itemBuilder: (context, i) {
        final pt = monthTimes[i];
        final isToday = pt.date.day == now.day;
        final timeFormat = DateFormat('hh:mm');

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: isToday
                ? (deen.isDark ? deen.surfaceElevated : deen.badgeBackground)
                : deen.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isToday ? deen.accentGold : deen.cardBorder,
              width: isToday ? 1.5 : 0.8,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pt.date.day} ${DateFormat('MMM').format(pt.date)}',
                style: GoogleFonts.outfit(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                  color: isToday ? deen.accentGold : deen.textPrimary,
                ),
              ),
              Text(
                'F: ${timeFormat.format(pt.fajr)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: deen.textSecondary,
                ),
              ),
              Text(
                'D: ${timeFormat.format(pt.dhuhr)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: deen.textSecondary,
                ),
              ),
              Text(
                'A: ${timeFormat.format(pt.asr)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: deen.textSecondary,
                ),
              ),
              Text(
                'M: ${timeFormat.format(pt.maghrib)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: deen.textSecondary,
                ),
              ),
              Text(
                'I: ${timeFormat.format(pt.isha)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: deen.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCalculationSettings(
    BuildContext context,
    PrayerProvider prayerProv,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.calculationJuristicMethod,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: deen.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${l10n.calculationMethod}:',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: deen.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CalculationMethod>(
                          value: prayerProv.method,
                          isExpanded: true,
                          dropdownColor: deen.surfacePrimary,
                          items: CalculationMethod.values.map((m) {
                            return DropdownMenuItem(
                              value: m,
                              child: Text(
                                m.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              prayerProv.setCalculationMethod(val);
                              setModalState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${l10n.juristicSchool}:',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                    ...const {
                      JuristicMethod.shafii: 'Shafi‘i',
                      JuristicMethod.maliki: 'Maliki',
                      JuristicMethod.hanbali: 'Hanbali',
                      JuristicMethod.hanafi: 'Hanafi',
                      JuristicMethod.jafari: 'Ja‘fari',
                    }.entries.map(
                          (entry) => RadioListTile<JuristicMethod>(
                            title: Text(entry.value),
                            value: entry.key,
                            groupValue:
                                prayerProv.juristic == JuristicMethod.standard
                                    ? JuristicMethod.shafii
                                    : prayerProv.juristic,
                            activeColor: deen.accentGold,
                            onChanged: (val) {
                              if (val != null) {
                                prayerProv.setJuristicMethod(val);
                                setModalState(() {});
                              }
                            },
                          ),
                        ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deen.accentPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        l10n.done,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _juristicLabel(JuristicMethod method) {
    switch (method) {
      case JuristicMethod.standard:
      case JuristicMethod.shafii:
        return 'Shafi‘i';
      case JuristicMethod.maliki:
        return 'Maliki';
      case JuristicMethod.hanbali:
        return 'Hanbali';
      case JuristicMethod.hanafi:
        return 'Hanafi';
      case JuristicMethod.jafari:
        return 'Ja‘fari';
    }
  }
}
