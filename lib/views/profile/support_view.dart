import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final faqs = [
      {
        'q': 'How do I ensure prayer times are 100% accurate for my location?',
        'a':
            'Enable Automatic Location (GPS) in Location Settings or select your exact city from the list. You can also adjust your preferred Calculation Method (e.g. MWL, ISNA, Umm Al-Qura) and Asr Juristic School (Standard vs Hanafi) in Calculation Settings.',
      },
      {
        'q': 'How does the Qibla Compass work and how do I calibrate it?',
        'a':
            'The compass uses your device\'s built-in magnetometer. Hold your phone flat horizontally away from metallic objects and wave it in a figure-8 motion a few times to calibrate sensor accuracy.',
      },
      {
        'q': 'How does the 3-Day Free Trial work?',
        'a':
            'New users receive a 3-day free trial of Proud Muslim Premium. You have full access to all reciters, full continuous Quran audio, and Islamic features. Unless cancelled at least 24 hours before the trial ends, the monthly subscription starts automatically.',
      },
      {
        'q': 'Can I listen to complete Surahs continuously?',
        'a':
            'Yes! When you open any Surah (e.g. Surah Al-Fatihah, Surah Yasin), press the Play button to listen from verse 1 all the way to the end without manually tapping each ayah.',
      },
      {
        'q': 'How is my location data handled?',
        'a':
            'We only access your device location to calculate solar prayer times and Qibla direction. Your personal data is never sold or used for tracking.',
      },
    ];

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.helpFaqSupport,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpFaqSupport,
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
          // Contact & Report Action Cards
          Row(
            children: [
              Expanded(
                child: DeenCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => _launchEmail(context, deen),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: deen.badgeBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          color: deen.accentPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contact Us',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: deen.textPrimary,
                        ),
                      ),
                      Text(
                        'Email Support',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DeenCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => _showReportDialog(context, l10n, deen),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: deen.accentGold.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bug_report_outlined,
                          color: deen.accentGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Report Issue',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: deen.textPrimary,
                        ),
                      ),
                      Text(
                        'Submit Feedback',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // FAQ Section
          const DeenSectionHeader(
            title: 'FREQUENTLY ASKED QUESTIONS (FAQ)',
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 10),
          ...faqs.map((faq) => _buildFaqTile(faq['q']!, faq['a']!, deen)),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String q, String a, DeenThemeTokens deen) {
    return DeenCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.help_rounded, size: 18, color: deen.accentGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  q,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: deen.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            a,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: deen.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail(BuildContext context, DeenThemeTokens deen) async {
    final uri = Uri.parse(
      'mailto:${AppConstants.supportEmail}?subject=Proud%20Muslim%20Support%20Request',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Support Email: ${AppConstants.supportEmail}'),
            backgroundColor: deen.accentPrimary,
          ),
        );
      }
    }
  }

  void _showReportDialog(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.surfacePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.reportAnIssue,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: deen.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Describe the issue, prayer calculation discrepancy, or feature feedback below:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: deen.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 4,
              style: GoogleFonts.plusJakartaSans(color: deen.textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter details...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.plusJakartaSans(color: deen.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.issueReceived),
                  backgroundColor: deen.accentPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deen.accentPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.submit,
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
