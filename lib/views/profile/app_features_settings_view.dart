import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/storage_service.dart';
import '../qibla/qibla_view.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';

import '../../l10n/app_localizations.dart';

class AppFeaturesSettingsView extends StatefulWidget {
  const AppFeaturesSettingsView({super.key});

  @override
  State<AppFeaturesSettingsView> createState() =>
      _AppFeaturesSettingsViewState();
}

class _AppFeaturesSettingsViewState extends State<AppFeaturesSettingsView> {
  bool _dailyReminders = StorageService.dailyRemindersEnabled;
  bool _azkarReminders = StorageService.azkarRemindersEnabled;
  bool _dailyAyah = StorageService.dailyAyahReminder;
  bool _dailyHadith = StorageService.dailyHadithReminder;

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.appFeaturesReminders,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14,
          bottom: bottomInset + 32,
        ),
        children: [
          // Section 1: Qibla Compass Tools
          DeenSectionHeader(
            title: l10n.qiblaCompass,
            icon: Icons.explore_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: deen.accentGold.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.explore_rounded,
                      color: deen.accentGold,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    l10n.qiblaCompass,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.helpQiblaDesc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QiblaView()),
                  ),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: deen.badgeBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.rotate_90_degrees_ccw_rounded,
                      color: deen.accentPrimary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    l10n.qiblaTipsTitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.compassAccuracyLow,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.info_outline_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _showCalibrationDialog(context, deen, l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Islamic Daily Reminders
          const DeenSectionHeader(
            title: 'DAILY SPIRITUAL REMINDERS',
            icon: Icons.notifications_active_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Master Daily Reminders',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Enable or disable all app notifications and spiritual alerts',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  value: _dailyReminders,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    setState(() => _dailyReminders = val);
                    StorageService.setDailyRemindersEnabled(val);
                  },
                ),
                Divider(height: 1, color: deen.cardBorder),
                SwitchListTile(
                  title: Text(
                    'Daily Ayah Inspiration',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Receive a daily Quranic verse reflection in the morning',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  value: _dailyAyah,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    setState(() => _dailyAyah = val);
                    StorageService.setDailyAyahReminder(val);
                  },
                ),
                Divider(height: 1, color: deen.cardBorder),
                SwitchListTile(
                  title: Text(
                    'Daily Hadith Gem',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Receive an authentic prophetic Hadith narration daily',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  value: _dailyHadith,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    setState(() => _dailyHadith = val);
                    StorageService.setDailyHadithReminder(val);
                  },
                ),
                Divider(height: 1, color: deen.cardBorder),
                SwitchListTile(
                  title: Text(
                    'Morning & Evening Azkar',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Reminders for Hisn al-Muslim morning and evening adhkar',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  value: _azkarReminders,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    setState(() => _azkarReminders = val);
                    StorageService.setAzkarRemindersEnabled(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: Share App
          const DeenSectionHeader(
            title: 'SPREAD THE MESSAGE (SADAQAH JARIYAH)',
            icon: Icons.share_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deen.accentGold.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share_rounded,
                  color: deen.accentGold,
                  size: 20,
                ),
              ),
              title: Text(
                'Share Proud Muslim with Family & Friends',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: deen.textPrimary,
                ),
              ),
              subtitle: Text(
                'The one who guides to good is like the one who does it (Hadith)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: deen.textSecondary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: deen.textSecondary,
              ),
              onTap: () {
                Share.share(
                  'Explore Proud Muslim — The complete Islamic companion for Prayer Times, Holy Quran, Qibla Compass, and Azkar. Download now!',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCalibrationDialog(
    BuildContext context,
    DeenThemeTokens deen,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.surfacePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.qiblaTipsTitle,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: deen.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.screen_rotation_rounded,
              size: 54,
              color: deen.accentGold,
            ),
            const SizedBox(height: 12),
            Text(
              '${l10n.compassAccuracyLow}\n\n${l10n.magneticInterferenceNotice}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.45,
                color: deen.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: deen.accentPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.gotIt,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
