import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../quran/quran_sources_view.dart';
import '../../l10n/app_localizations.dart';

class LegalAboutView extends StatelessWidget {
  const LegalAboutView({super.key});

  Future<void> _launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.legalAndAbout,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.legalAndAbout,
            description: l10n.privacyPolicyDesc,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14,
          bottom: bottomInset + 32,
        ),
        children: [
          // Forever Free Promise Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: deen.badgeBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: deen.accentGold.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: deen.accentGold, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.quranForeverFree,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: deen.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // App Info Hero Card
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    color: deen.accentGoldBright,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appTagline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    'Version ${AppConstants.appVersion} (${AppConstants.appBuildNumber})',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About the App
          const DeenSectionHeader(
            title: 'ABOUT THE APP',
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Proud Muslim is designed to accompany you in your daily Islamic worship. Featuring accurate prayer times, astronomical Qibla compass, authentic Hisn al-Muslim daily Azkar, digital Tasbih, and a complete 14-language Holy Quran reader with canonical Arabic scripture.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.5,
                color: deen.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Legal Links & Attribution
          const DeenSectionHeader(
            title: 'LEGAL & SOURCE ATTRIBUTIONS',
            icon: Icons.gavel_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.source_outlined, color: deen.accentGold),
                  title: Text(
                    l10n.quranTranslationSources,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.quranTranslationSourcesDesc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: deen.textSecondary,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuranSourcesView(),
                      ),
                    );
                  },
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: deen.accentPrimary,
                  ),
                  title: Text(
                    l10n.privacyPolicy,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.privacyPolicyDesc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _launchWebUrl(AppConstants.privacyPolicyUrl),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: deen.accentPrimary,
                  ),
                  title: Text(
                    l10n.termsOfService,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.termsOfServiceDesc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _launchWebUrl(AppConstants.termsOfUseUrl),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: deen.accentPrimary,
                  ),
                  title: Text(
                    l10n.dataAccountDeletion,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.dataAccountDeletionDesc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _showDataDeletionDialog(context, l10n, deen),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  leading: Icon(
                    Icons.mail_outline_rounded,
                    color: deen.accentGold,
                  ),
                  title: Text(
                    l10n.supportAndContact,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    AppConstants.supportEmail,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: deen.textSecondary,
                  ),
                  onTap: () =>
                      _launchWebUrl('mailto:${AppConstants.supportEmail}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDataDeletionDialog(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.shield_outlined, color: deen.accentPrimary, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.dataAccountDeletion,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: deen.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proud Muslim does not maintain external user accounts or track your identity on remote cloud servers. All personal preferences, bookmarks, tasbih counts, and location settings are stored locally on your device.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: deen.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'To delete all data, you can clear app storage from Android App Settings or tap Reset Preferences in the app profile.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: deen.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: deen.accentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
