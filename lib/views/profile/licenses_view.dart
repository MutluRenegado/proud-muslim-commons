import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/deen_theme_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/deen_card.dart';

class LicensesView extends StatelessWidget {
  const LicensesView({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.licenses,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          14,
          AppSpacing.screenMargin,
          32,
        ),
        children: [
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_user_rounded,
                    color: deen.accentGoldBright, size: 30),
                const SizedBox(height: 12),
                Text(
                  'Licences & Attributions',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Third-party content remains the property of its respective copyright owners.',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            context,
            title: 'Quran Audio Recitation',
            icon: Icons.headphones_rounded,
            children: const [
              _LicenseLine('Reciter', 'Mishary Rashid Alafasy'),
              _LicenseLine('Edition identifier', 'ar.alafasy'),
              _LicenseLine('Provider', 'Al Quran Cloud / Islamic Network'),
              _LicenseLine('Delivery', 'Islamic Network audio CDN'),
              _LicenseLine(
                'Licence status',
                'Streaming, embedding and downloading are permitted for personal and educational use. The provider also permits inclusion in commercial products under its published terms.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Rights and Conditions',
            icon: Icons.gavel_rounded,
            children: const [
              _BodyText(
                'Copyright in each recitation remains with the reciter or applicable rights holder. The provider states that its recitations are licensed by the reciters or their estates for free, non-commercial redistribution at the published bitrates.',
              ),
              _BodyText(
                'Use in a commercial product is permitted by the provider, but a reciter or rights holder may request removal. Proud Muslim will honour a valid removal or attribution request.',
              ),
              _BodyText(
                'The service is provided without warranties. These terms do not transfer ownership of the recording to Proud Muslim or ANM Digital Labs.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Official Documents',
            icon: Icons.description_outlined,
            children: [
              _DocumentTile(
                title: 'Al Quran Cloud Terms and Conditions',
                subtitle: 'Official recitation and CDN usage terms',
                onTap: () => _open(AppConstants.quranAudioTermsUrl),
              ),
              _DocumentTile(
                title: 'Al Quran Cloud',
                subtitle: 'Official audio provider',
                onTap: () => _open(AppConstants.quranAudioProviderUrl),
              ),
              _DocumentTile(
                title: 'Proud Muslim Licences',
                subtitle: 'Complete app licences and attributions',
                onTap: () => _open(AppConstants.licensesUrl),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Terms verified: 15 September 2026. Provider terms were last updated on 14 June 2026. If upstream terms change, the current official terms apply.',
            style: GoogleFonts.plusJakartaSans(
              color: deen.textSecondary,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final deen = context.deen;
    return DeenCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: deen.accentPrimary, size: 21),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: deen.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _LicenseLine extends StatelessWidget {
  const _LicenseLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: deen.accentPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: deen.textPrimary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: deen.textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: deen.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          color: deen.textSecondary,
          fontSize: 11,
        ),
      ),
      trailing: Icon(
        Icons.open_in_new_rounded,
        color: deen.textSecondary,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
