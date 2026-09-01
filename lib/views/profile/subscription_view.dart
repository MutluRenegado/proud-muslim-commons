import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

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
    final product = subProv.monthlyProduct;
    final billingProvider = subProv.billingProvider;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.subscriptionAndBilling,
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

          // Header Status Banner
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient:
                  isSubscribed ? deen.cardGlowGradient : deen.bgHeaderGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: deen.isDark
                    ? deen.accentGold.withOpacity(0.4)
                    : Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSubscribed ? deen.accentGold : deen.accentPrimary)
                      .withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSubscribed
                            ? Colors.black.withOpacity(0.2)
                            : deen.accentGold.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        isSubscribed
                            ? 'PREMIUM ACTIVE'
                            : (isInTrial ? '3-DAY TRIAL ACTIVE' : 'FREE PLAN'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isSubscribed
                      ? l10n.monthlyPremiumPlan
                      : (isInTrial
                          ? '${l10n.freeTrial} ($daysLeft days left)'
                          : l10n.unlockPremiumAccess),
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isSubscribed
                      ? 'You have unlimited access to all Proud Muslim Pro features.'
                      : (isInTrial
                          ? 'Enjoy complete full access to all dynamic themes and customization.'
                          : 'Subscribe monthly to unlock all dynamic themes and advanced customization.'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Plan Details Card
          DeenSectionHeader(
            title: l10n.subscriptionAndBilling.toUpperCase(),
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    l10n.currentPlan,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    isSubscribed
                        ? 'Monthly Auto-Renewing'
                        : (isInTrial ? l10n.freeTrial : l10n.freePlan),
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    product.price,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: deen.textPrimary,
                    ),
                  ),
                ),
                Divider(height: 1, color: deen.cardBorder),
                ListTile(
                  title: Text(
                    l10n.billingProvider,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    billingProvider,
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.storefront_rounded,
                    color: deen.textSecondary,
                  ),
                ),
                if (trial['endDate'] != null && isInTrial) ...[
                  Divider(height: 1, color: deen.cardBorder),
                  ListTile(
                    title: Text(
                      l10n.trialExpirationDate,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: deen.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('EEEE, MMMM d, yyyy')
                          .format(trial['endDate'] as DateTime),
                      style: GoogleFonts.plusJakartaSans(
                        color: deen.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.event_rounded, color: deen.accentGold),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          if (!isSubscribed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => subProv.subscribeMonthly(),
                icon: const Icon(Icons.lock_open_rounded, size: 20),
                label: Text(
                  '${l10n.subscribeNow} (${product.price} / Month)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: deen.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          OutlinedButton.icon(
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
            icon: const Icon(Icons.restore_rounded, size: 18),
            label: Text(
              l10n.restorePurchases,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: deen.textPrimary,
              side: BorderSide(color: deen.cardBorder),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Google Play Terms and Disclosures
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Subscriptions auto-renew monthly unless canceled at least 24 hours prior to the end of the current billing cycle through Google Play Store > Subscriptions. Quran reading and prayer times remain permanently free.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: deen.textMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
