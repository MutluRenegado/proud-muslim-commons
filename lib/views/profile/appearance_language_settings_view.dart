import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class AppearanceLanguageSettingsView extends StatelessWidget {
  const AppearanceLanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final languages = {
      'en': {'name': 'English', 'native': 'English'},
      'tr': {'name': 'Turkish', 'native': 'Türkçe'},
      'ar': {'name': 'Arabic', 'native': 'العربية'},
      'de': {'name': 'German', 'native': 'Deutsch'},
      'fr': {'name': 'French', 'native': 'Français'},
      'es': {'name': 'Spanish', 'native': 'Español'},
      'pt': {'name': 'Portuguese', 'native': 'Português'},
      'ru': {'name': 'Russian', 'native': 'Русский'},
      'id': {'name': 'Indonesian', 'native': 'Bahasa Indonesia'},
      'ur': {'name': 'Urdu', 'native': 'اردو'},
      'ms': {'name': 'Malay', 'native': 'Bahasa Melayu'},
    };

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.appearanceAndLanguage,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpThemesTitle,
            description: l10n.helpThemesDesc,
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
          // Section 1: 4 Dynamic User-Selectable Themes
          DeenSectionHeader(
            title: l10n.fourDynamicThemes,
            icon: Icons.palette_rounded,
          ),
          const SizedBox(height: 8),
          ...AppThemeType.values.map((themeType) {
            final isSelected = themeProv.currentThemeType == themeType;
            return _buildThemeCard(
              context: context,
              themeProv: themeProv,
              themeType: themeType,
              isSelected: isSelected,
              deen: deen,
            );
          }),
          const SizedBox(height: 20),

          // Section 2: Typography & Font Sizing
          DeenSectionHeader(
            title: l10n.typographyAccessibility,
            icon: Icons.text_fields_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.arabicFontSize,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              color: deen.textPrimary,
                            ),
                          ),
                          Text(
                            '${themeProv.arabicFontSize.round()} pt',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: deen.accentPrimary,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: themeProv.arabicFontSize,
                        min: 18.0,
                        max: 36.0,
                        divisions: 9,
                        activeColor: deen.accentPrimary,
                        onChanged: (val) => themeProv.setArabicFontSize(val),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: themeProv.arabicFontSize,
                            fontWeight: FontWeight.bold,
                            color: deen.arabicPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: deen.cardBorder),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.translationFontSize,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              color: deen.textPrimary,
                            ),
                          ),
                          Text(
                            '${themeProv.translationFontSize.round()} pt',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: deen.accentGold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: themeProv.translationFontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        activeColor: deen.accentGold,
                        onChanged: (val) =>
                            themeProv.setTranslationFontSize(val),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.bismillahQuote,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: themeProv.translationFontSize,
                          fontStyle: FontStyle.italic,
                          color: deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: Language & Number Format
          DeenSectionHeader(
            title: l10n.languageAndRegionalSettings.toUpperCase(),
            icon: Icons.language_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    l10n.displayLanguage,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${languages[themeProv.languageCode]?['name']} (${languages[themeProv.languageCode]?['native']})',
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _showLanguagePicker(
                    context,
                    themeProv,
                    languages,
                    l10n,
                    deen,
                  ),
                ),
                Divider(height: 1, color: deen.cardBorder),
                SwitchListTile(
                  title: Text(
                    l10n.showSecondsInCountdown,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.displayLiveSecondTicking,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: deen.textSecondary,
                    ),
                  ),
                  value: themeProv.showSeconds,
                  activeColor: deen.accentGold,
                  onChanged: (val) => themeProv.setShowSeconds(val),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  title: Text(
                    l10n.numeralFormat,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    themeProv.numberFormat == 'easternArabic'
                        ? '${l10n.easternNumerals} (١, ٢, ٣...)'
                        : '${l10n.westernNumerals} (1, 2, 3...)',
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () =>
                      _showNumberFormatPicker(context, themeProv, l10n, deen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required ThemeProvider themeProv,
    required AppThemeType themeType,
    required bool isSelected,
    required DeenThemeTokens deen,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return DeenCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      isSelected: isSelected,
      onTap: () => themeProv.setAppThemeType(themeType),
      child: Row(
        children: [
          // Visual Theme Swatch Capsule
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: themeType.previewBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? deen.accentGold : deen.cardBorder,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Accent dot
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: themeType.previewPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
                // Mini surface tile
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: themeType.previewSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black12, width: 0.8),
                    ),
                    child: Icon(
                      themeType.isDark
                          ? Icons.dark_mode_rounded
                          : Icons.wb_sunny_rounded,
                      size: 12,
                      color: themeType.previewPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Theme Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      themeType.title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                        color: deen.textPrimary,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: deen.accentGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.active.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: deen.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  themeType.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: deen.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Selection Radio Indicator
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? deen.accentGold : deen.textMuted,
                width: 2,
              ),
              color: isSelected ? deen.accentGold : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: Colors.black)
                : null,
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    ThemeProvider themeProv,
    Map<String, Map<String, String>> languages,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.selectLanguage,
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
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: languages.entries.map((entry) {
                      final isCurrent = themeProv.languageCode == entry.key;
                      return ListTile(
                        title: Text(
                          entry.value['name']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCurrent
                                ? deen.accentPrimary
                                : deen.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          entry.value['native']!,
                          style: GoogleFonts.plusJakartaSans(
                            color: deen.textSecondary,
                          ),
                        ),
                        trailing: isCurrent
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: deen.accentPrimary,
                              )
                            : null,
                        onTap: () {
                          themeProv.setLanguageCode(entry.key);
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNumberFormatPicker(
    BuildContext context,
    ThemeProvider themeProv,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.numeralFormat,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: deen.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: Text(
                    l10n.westernNumerals,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: const Text('0, 1, 2, 3, 4, 5, 6, 7, 8, 9'),
                  value: 'westernArabic',
                  groupValue: themeProv.numberFormat,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    if (val != null) {
                      themeProv.setNumberFormat(val);
                      Navigator.pop(ctx);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(
                    l10n.easternNumerals,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: const Text('٠, ١, ٢, ٣, ٤, ٥, ٦, ٧, ٨, ٩'),
                  value: 'easternArabic',
                  groupValue: themeProv.numberFormat,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    if (val != null) {
                      themeProv.setNumberFormat(val);
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
