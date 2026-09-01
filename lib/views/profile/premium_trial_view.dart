import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class PremiumTrialView extends StatelessWidget {
  const PremiumTrialView({super.key});

  @override
  Widget build(BuildContext context) {
    final subProv = Provider.of<SubscriptionProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final trial = subProv.trialDetails;
    final isSubscribed = subProv.isSubscribed;
    final isInTrial = subProv.isInTrial;
    final daysLeft = subProv.daysLeftInTrial;
    final product = subProv.productInfo;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.freeTrial,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpSubscriptionTitle,
            description: l10n.helpSubscriptionDesc,
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

          // Hero Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: deen.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: deen.accentGold, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: deen.accentGold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isSubscribed
                        ? 'PREMIUM ACTIVATED'
                        : (isInTrial
                            ? '$daysLeft DAYS LEFT IN TRIAL'
                            : '3-DAY FREE TRIAL AVAILABLE'),
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: deen.accentGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Main Title & Subtitle
          Text(
            isSubscribed
                ? 'You Are a Proud Muslim Premium Member'
                : 'Experience All Features Risk-Free',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: deen.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSubscribed
                ? 'Your subscription is active and in good standing.'
                : 'All dynamic themes, typography customization, and premium features are active during your 3-day trial.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: deen.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          // Trial Timeline Card
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
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimelineStep(
                      step: 'Day 1',
                      title: l10n.trialStarts,
                      subtitle: l10n.fullAccess,
                      isActive: true,
                      deen: deen,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white54,
                      size: 18,
                    ),
                    _buildTimelineStep(
                      step: 'Day 3',
                      title: l10n.trialEnds,
                      subtitle: trial['endDate'] != null
                          ? DateFormat('MMM d')
                              .format(trial['endDate'] as DateTime)
                          : 'In 3 days',
                      isActive: true,
                      deen: deen,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white54,
                      size: 18,
                    ),
                    _buildTimelineStep(
                      step: 'Day 4',
                      title: l10n.monthlyPlan,
                      subtitle: product.price,
                      isActive: isSubscribed,
                      deen: deen,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feature Checkmarks
          DeenCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _buildFeatureCheck(l10n.quranForeverFree, deen),
                Divider(height: 16, color: deen.cardBorder),
                _buildFeatureCheck(
                  '4 Dynamic Islamic Spiritual Themes & Colors',
                  deen,
                ),
                Divider(height: 16, color: deen.cardBorder),
                _buildFeatureCheck(
                  'Accurate Sensor Qibla Compass Calibration',
                  deen,
                ),
                Divider(height: 16, color: deen.cardBorder),
                _buildFeatureCheck(
                  'Authentic Hisn al-Muslim Azkar & Dhikr Counters',
                  deen,
                ),
                Divider(height: 16, color: deen.cardBorder),
                _buildFeatureCheck(
                  'Ad-Free, Peaceful, Distraction-Free Experience',
                  deen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (!isSubscribed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => subProv.subscribeMonthly(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: deen.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  '${l10n.start3DayFreeTrial} (${product.price} / mo)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          OutlinedButton(
            onPressed: () async {
              final success = await subProv.restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Purchases restored successfully.'
                          : 'No active subscriptions found.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: deen.textSecondary,
              side: BorderSide(color: deen.cardBorder),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.restorePurchases,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String step,
    required String title,
    required String subtitle,
    required bool isActive,
    required DeenThemeTokens deen,
  }) {
    return Column(
      children: [
        Text(
          step,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: deen.accentGoldBright,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCheck(String text, DeenThemeTokens deen) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, color: deen.accentGold, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: deen.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
