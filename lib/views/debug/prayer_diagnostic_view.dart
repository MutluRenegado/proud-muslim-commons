import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/time_service.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';

class PrayerDiagnosticView extends StatelessWidget {
  const PrayerDiagnosticView({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final times = prayerProv.todayPrayerTimes;
    final deen = context.deen;
    final nowUtc = TimeService.nowUtc();

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Prayer & Timezone Diagnostics',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const DeenSectionHeader(
            title: 'SYSTEM & TIMEZONE INTEGRITY',
            icon: Icons.access_time_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('UTC Instant (Source of Truth)', nowUtc.toIso8601String()),
                _buildDivider(deen),
                _buildRow('Local Time (Display)', prayerProv.getFormattedLocalTime(use24Hour: true)),
                _buildDivider(deen),
                _buildRow('IANA Time Zone', prayerProv.ianaTimeZone),
                _buildDivider(deen),
                _buildRow('UTC Offset', prayerProv.getUtcOffsetDisplay()),
                _buildDivider(deen),
                _buildRow('Network Time Sync', TimeService.hasNetworkSync ? 'Verified' : 'Offline Device Fallback'),
                _buildDivider(deen),
                _buildRow('Clock Drift Offset', '${TimeService.clockDrift.inMilliseconds} ms'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const DeenSectionHeader(
            title: 'LOCATION & CALCULATION ENGINE',
            icon: Icons.public_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('Location', '${prayerProv.city}, ${prayerProv.country}'),
                _buildDivider(deen),
                _buildRow('Coordinates', 'Lat: ${prayerProv.latitude.toStringAsFixed(5)}, Lng: ${prayerProv.longitude.toStringAsFixed(5)}'),
                _buildDivider(deen),
                _buildRow('Elevation', '${prayerProv.elevation.toStringAsFixed(1)} m'),
                _buildDivider(deen),
                _buildRow('Calculation Method', prayerProv.method.name),
                _buildDivider(deen),
                _buildRow('Asr Madhhab', prayerProv.juristic.name),
                _buildDivider(deen),
                _buildRow('High Latitude Rule', prayerProv.highLatitude.name),
                _buildDivider(deen),
                _buildRow('Rounding Mode', prayerProv.rounding.name),
                _buildDivider(deen),
                _buildRow('Local Gregorian Date', prayerProv.getFormattedLocalDate()),
                _buildDivider(deen),
                _buildRow('Hijri Date (Local)', prayerProv.getHijriDateFormatted()),
                _buildDivider(deen),
                _buildRow('Hijri Arabic (Header)', prayerProv.getHijriDateFormattedArabic()),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const DeenSectionHeader(
            title: 'PRAYER TIMESTAMPS (LOCAL & UTC)',
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 8),
          if (times != null)
            DeenCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPrayerRow('Fajr', times.fajr, times.fajrUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Sunrise', times.sunrise, times.sunriseUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Dhuhr', times.dhuhr, times.dhuhrUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Asr', times.asr, times.asrUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Maghrib', times.maghrib, times.maghribUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Isha', times.isha, times.ishaUtc, deen),
                  _buildDivider(deen),
                  _buildPrayerRow('Qiyam', times.qiyam, times.qiyamUtc, deen),
                ],
              ),
            ),
          const SizedBox(height: 20),

          const DeenSectionHeader(
            title: 'NEXT PRAYER & COUNTDOWN ENGINE',
            icon: Icons.timer_outlined,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('Current Prayer Period', prayerProv.currentPrayer),
                _buildDivider(deen),
                _buildRow('Next Prayer Event', prayerProv.nextPrayer),
                _buildDivider(deen),
                _buildRow('Time Remaining', _formatDuration(prayerProv.timeUntilNextPrayer)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(String name, DateTime local, DateTime utc, DeenThemeTokens deen) {
    final localStr = '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
    final utcStr = '${utc.hour.toString().padLeft(2, '0')}:${utc.minute.toString().padLeft(2, '0')}:${utc.second.toString().padLeft(2, '0')} UTC';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: deen.textPrimary,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Local: $localStr',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: deen.accentPrimary,
                ),
              ),
              Text(
                utcStr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: deen.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(DeenThemeTokens deen) {
    return Divider(height: 12, color: deen.cardBorder.withOpacity(0.5));
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
