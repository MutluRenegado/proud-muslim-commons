import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/deen_theme_tokens.dart';
import '../core/constants/app_design_tokens.dart';
import '../l10n/app_localizations.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final DateTime time;
  final bool isNext;
  final bool isCurrent;
  final IconData icon;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.time,
    this.isNext = false,
    this.isCurrent = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final timeStr = DateFormat('hh:mm a').format(time);

    final cardBg = isNext
        ? (deen.isDark ? deen.surfaceElevated : deen.badgeBackground)
        : deen.cardBackground;

    final borderColor = isNext ? deen.accentGold : deen.cardBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: borderColor, width: isNext ? 1.6 : 1.0),
        boxShadow: isNext
            ? AppShadows.glow(deen.accentGold, radius: 12)
            : [
                BoxShadow(
                  color: deen.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNext
                  ? deen.accentGold
                  : deen.accentPrimary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isNext ? Colors.black : deen.accentPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: isNext ? FontWeight.w700 : FontWeight.w600,
                    color: isNext
                        ? (deen.isDark ? deen.accentGold : deen.accentPrimary)
                        : deen.textPrimary,
                  ),
                ),
                if (isNext)
                  Text(
                    'Upcoming Prayer',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: deen.accentGold,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isNext ? deen.accentGold : deen.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownTimerWidget extends StatelessWidget {
  final String nextPrayer;
  final Duration remainingTime;

  const CountdownTimerWidget({
    super.key,
    required this.nextPrayer,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        gradient: deen.bgHeaderGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: deen.isDark
              ? deen.accentGold.withOpacity(0.4)
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: deen.accentPrimary.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: deen.accentGoldBright,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: deen.accentGoldBright.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.nextPrayer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withOpacity(0.82),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16),
                      child: Text(
                        nextPrayer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.countdownTo,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeBox(hours, _timeLabel(languageCode, 'hours'), deen),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTimeBox(minutes, _timeLabel(languageCode, 'minutes'), deen),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTimeBox(seconds, _timeLabel(languageCode, 'seconds'), deen),
            ],
          ),
        ],
      ),
    );
  }

  String _timeLabel(String languageCode, String unit) {
    const labels = <String, Map<String, String>>{
      'hours': {
        'ar': 'ساعات',
        'de': 'STD',
        'en': 'HOURS',
        'es': 'HORAS',
        'fr': 'HEURES',
        'id': 'JAM',
        'ms': 'JAM',
        'pt': 'HORAS',
        'ru': 'ЧАС',
        'tr': 'SAAT',
        'ur': 'گھنٹے',
      },
      'minutes': {
        'ar': 'دقائق',
        'de': 'MIN',
        'en': 'MINS',
        'es': 'MIN',
        'fr': 'MIN',
        'id': 'MENIT',
        'ms': 'MIN',
        'pt': 'MIN',
        'ru': 'МИН',
        'tr': 'DK',
        'ur': 'منٹ',
      },
      'seconds': {
        'ar': 'ثوان',
        'de': 'SEK',
        'en': 'SECS',
        'es': 'SEG',
        'fr': 'SEC',
        'id': 'DETIK',
        'ms': 'SAAT',
        'pt': 'SEG',
        'ru': 'СЕК',
        'tr': 'SN',
        'ur': 'سیکنڈ',
      },
    };
    return labels[unit]?[languageCode] ?? labels[unit]?['en'] ?? unit;
  }

  Widget _buildTimeBox(String val, String label, DeenThemeTokens deen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Text(
            val,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
