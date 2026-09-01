// quran_sources_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/repositories/quran_edition_repository.dart';
import '../../widgets/deen_card.dart';

class QuranSourcesView extends StatelessWidget {
  const QuranSourcesView({super.key});

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final allEditions = QuranEditionRepository.allEditions;
    final languages = QuranEditionRepository.supportedLanguages;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Quran Sources & Attributions',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // 1. Architecture & API Credit Card
          Container(
            padding: const EdgeInsets.all(18),
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
                  color: deen.accentPrimary.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: deen.accentGoldBright,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MULTILINGUAL QURAN ARCHITECTURE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: deen.accentGoldBright,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Canonical Arabic & 14-Language Translations',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Arabic scripture remains the canonical, unedited core text. Translations are dynamically served via high-reliability CDN endpoints powered by the Fawaz Ahmed Quran API repository with offline storage caching.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Section Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'TRANSLATION EDITIONS BY LANGUAGE (14)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: deen.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // 3. Editions List grouped by language
          ...languages.map((lang) {
            final editions =
                allEditions.where((e) => e.languageCode == lang.code).toList();
            if (editions.isEmpty) return const SizedBox.shrink();

            return DeenCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Title Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: deen.accentPrimary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: deen.accentPrimary.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              lang.code.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: deen.accentPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            lang.englishName,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: deen.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        lang.nativeName,
                        textDirection:
                            lang.isRtl ? TextDirection.rtl : TextDirection.ltr,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deen.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Individual Editions
                  ...editions.map((ed) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: deen.bgPrimary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ed.translatorName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: deen.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: ed.enabled
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ed.enabled
                                      ? 'Active / Enabled'
                                      : 'Distribution Reserved',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ed.enabled
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Source: ${ed.source}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: deen.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'License: ${ed.licenseStatus}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: deen.accentPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (ed.attribution.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              ed.attribution,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: deen.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
