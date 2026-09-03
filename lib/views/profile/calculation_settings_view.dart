import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/prayer_time_model.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class CalculationSettingsView extends StatelessWidget {
  const CalculationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final methodLabels = {
      CalculationMethod.turkeyDiyanet:
          'Türkiye Diyanet İşleri Başkanlığı (Local Astronomical)',
      CalculationMethod.muslimWorldLeague: 'Muslim World League (MWL)',
      CalculationMethod.ummAlQuraMakkah: 'Umm Al-Qura University, Makkah',
      CalculationMethod.egyptianGeneralAuthority:
          'Egyptian General Authority of Survey',
      CalculationMethod.universityOfIslamicSciencesKarachi:
          'University of Islamic Sciences, Karachi',
      CalculationMethod.islamicSocietyOfNorthAmerica:
          'Islamic Society of North America (ISNA)',
      CalculationMethod.dubai: 'Dubai (UAE / GAIAE)',
      CalculationMethod.kuwait: 'Kuwait (Ministry of Awqaf)',
      CalculationMethod.qatar: 'Qatar (Ministry of Awqaf)',
      CalculationMethod.singapore: 'Singapore (MUIS)',
      CalculationMethod.instituteOfGeophysicsTehran:
          'Institute of Geophysics, Tehran',
      CalculationMethod.shiaIthnaAshari:
          'Shia Ithna-Ashari (Leva Institute, Qum)',
    };

    final highLatLabels = {
      HighLatitudeRule.none: 'None (Standard Solar Altitude)',
      HighLatitudeRule.middleOfTheNight: 'Middle of the Night',
      HighLatitudeRule.oneSeventh: 'One Seventh (1/7th of night)',
      HighLatitudeRule.angleBased: 'Angle Based Ratio',
    };

    final roundingLabels = {
      RoundingMethod.noRounding: 'Exact Calculated Time (retain seconds)',
      RoundingMethod.nearestMinute: 'Nearest Minute (Standard)',
      RoundingMethod.upToNextMinute: 'Up to Next Minute (Ceil)',
      RoundingMethod.downToPreviousMinute: 'Down to Previous Minute (Floor)',
    };

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.calculationJuristicMethod,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpPrayerTimesTitle,
            description: l10n.helpPrayerTimesDesc,
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
          // Section 1: Calculation Method
          const DeenSectionHeader(
            title: 'CALCULATION CONVENTION\n& AUTHORITY',
            icon: Icons.account_balance_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              title: Text(
                'Calculation Method',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: deen.textPrimary,
                ),
              ),
              subtitle: Text(
                methodLabels[prayerProv.method] ?? prayerProv.method.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
                  _showMethodPicker(context, prayerProv, methodLabels, deen),
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Juristic Method (Asr Shadow)
          const DeenSectionHeader(
            title: 'ASR JURISTIC SCHOOL (MADHHAB)',
            icon: Icons.school_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildJuristicTile(
                  prayerProv,
                  deen,
                  JuristicMethod.shafii,
                  'Shafi‘i School',
                  'Standard shadow length (1:1)',
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildJuristicTile(
                  prayerProv,
                  deen,
                  JuristicMethod.maliki,
                  'Maliki School',
                  'Standard shadow length (1:1)',
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildJuristicTile(
                  prayerProv,
                  deen,
                  JuristicMethod.hanbali,
                  'Hanbali School',
                  'Standard shadow length (1:1)',
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildJuristicTile(
                  prayerProv,
                  deen,
                  JuristicMethod.hanafi,
                  'Hanafi School',
                  'Shadow length equals twice the object height (2:1)',
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildJuristicTile(
                  prayerProv,
                  deen,
                  JuristicMethod.jafari,
                  'Ja‘fari School',
                  'Standard Asr shadow; Ja‘fari twilight follows the selected calculation convention',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: High Latitude Rule & Rounding
          const DeenSectionHeader(
            title: 'HIGH LATITUDE\n& PRECISION ROUNDING',
            icon: Icons.public_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'High Latitude Rule',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    highLatLabels[prayerProv.highLatitude] ??
                        prayerProv.highLatitude.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _showHighLatPicker(
                    context,
                    prayerProv,
                    highLatLabels,
                    deen,
                  ),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  title: Text(
                    'Rounding Method',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    roundingLabels[prayerProv.rounding] ??
                        prayerProv.rounding.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: deen.textSecondary,
                  ),
                  onTap: () => _showRoundingPicker(
                    context,
                    prayerProv,
                    roundingLabels,
                    deen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 4: Manual Minute Offsets
          const DeenSectionHeader(
            title: 'MANUAL MINUTE ADJUSTMENTS',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildOffsetRow(context, 'Fajr', prayerProv, deen),
                Divider(height: 1, color: deen.cardBorder),
                _buildOffsetRow(context, 'Sunrise', prayerProv, deen),
                Divider(height: 1, color: deen.cardBorder),
                _buildOffsetRow(context, 'Dhuhr', prayerProv, deen),
                Divider(height: 1, color: deen.cardBorder),
                _buildOffsetRow(context, 'Asr', prayerProv, deen),
                Divider(height: 1, color: deen.cardBorder),
                _buildOffsetRow(context, 'Maghrib', prayerProv, deen),
                Divider(height: 1, color: deen.cardBorder),
                _buildOffsetRow(context, 'Isha', prayerProv, deen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffsetRow(
    BuildContext context,
    String prayer,
    PrayerProvider prayerProv,
    DeenThemeTokens deen,
  ) {
    final offset = prayerProv.minuteOffsets[prayer] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayer,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              color: deen.textPrimary,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: deen.accentPrimary,
                ),
                onPressed: () =>
                    prayerProv.updatePrayerOffset(prayer, offset - 1),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  '${offset >= 0 ? "+" : ""}$offset m',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: deen.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: deen.accentPrimary),
                onPressed: () =>
                    prayerProv.updatePrayerOffset(prayer, offset + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJuristicTile(
    PrayerProvider prayerProv,
    DeenThemeTokens deen,
    JuristicMethod value,
    String title,
    String subtitle,
  ) {
    final selected = prayerProv.juristic == value ||
        (value == JuristicMethod.shafii &&
            prayerProv.juristic == JuristicMethod.standard);
    return RadioListTile<JuristicMethod>(
      title: Text(
        title,
        maxLines: 2,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: deen.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 3,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: deen.textSecondary,
        ),
      ),
      value: value,
      groupValue: selected ? value : prayerProv.juristic,
      activeColor: deen.accentGold,
      onChanged: (newValue) {
        if (newValue != null) prayerProv.setJuristicMethod(newValue);
      },
    );
  }

  void _showMethodPicker(
    BuildContext context,
    PrayerProvider prayerProv,
    Map<CalculationMethod, String> labels,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Select Calculation\nConvention',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: deen.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...labels.entries.map((e) {
                return RadioListTile<CalculationMethod>(
                  title: Text(
                    e.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  value: e.key,
                  groupValue: prayerProv.method,
                  activeColor: deen.accentGold,
                  onChanged: (val) {
                    if (val != null) {
                      prayerProv.setCalculationMethod(val);
                      Navigator.pop(ctx);
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showHighLatPicker(
    BuildContext context,
    PrayerProvider prayerProv,
    Map<HighLatitudeRule, String> labels,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: labels.entries.map((e) {
              return RadioListTile<HighLatitudeRule>(
                title: Text(
                  e.value,
                  maxLines: 2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: deen.textPrimary,
                  ),
                ),
                value: e.key,
                groupValue: prayerProv.highLatitude,
                activeColor: deen.accentGold,
                onChanged: (val) {
                  if (val != null) {
                    prayerProv.setHighLatitudeRule(val);
                    Navigator.pop(ctx);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showRoundingPicker(
    BuildContext context,
    PrayerProvider prayerProv,
    Map<RoundingMethod, String> labels,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: labels.entries.map((e) {
              return RadioListTile<RoundingMethod>(
                title: Text(
                  e.value,
                  maxLines: 2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: deen.textPrimary,
                  ),
                ),
                value: e.key,
                groupValue: prayerProv.rounding,
                activeColor: deen.accentGold,
                onChanged: (val) {
                  if (val != null) {
                    prayerProv.setRoundingMethod(val);
                    Navigator.pop(ctx);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
