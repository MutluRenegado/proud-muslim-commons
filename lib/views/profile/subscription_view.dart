import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/storage_service.dart';
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

    final hasPremium = subProv.hasPremiumAccess;
    final isTester = subProv.isPermanentTestingAccount;
    final isTrial = subProv.hasActiveTrial;
    final isPaid = subProv.isPaidSubscribed;
    final billingProvider = subProv.billingProvider;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Subscription & Plans',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: 'Proud Muslim Plans',
            description:
                'Proud Muslim offers a complete 100% Free Qur\'an experience without ads. Premium unlocks unlimited AI voice translation narration, AI verse explanations, and background audio.',
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
          // 1. Core Islamic Free Promise Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: deen.badgeBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: deen.accentGold.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: deen.accentGold, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Free Core Qur\'an & No Ads',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: deen.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Reading Qur\'an, translations, Arabic recitation, prayer times, Qibla compass & 99 Names are 100% Free with zero advertisements.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: deen.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Status Banner
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient:
                  hasPremium ? deen.cardGlowGradient : deen.bgHeaderGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: deen.isDark
                    ? deen.accentGold.withOpacity(0.4)
                    : Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: (hasPremium ? deen.accentGold : deen.accentPrimary)
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
                        color: hasPremium
                            ? Colors.black.withOpacity(0.25)
                            : deen.accentGold.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        isTester
                            ? 'TEST ACCOUNT (UNRESTRICTED)'
                            : (isPaid
                                ? 'PREMIUM ACTIVE'
                                : (isTrial
                                    ? '3-DAY TRIAL ACTIVE (${subProv.trialDaysRemaining}d left)'
                                    : 'FREE TIER')),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Icon(
                      hasPremium
                          ? Icons.auto_awesome_rounded
                          : Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isTester
                      ? 'Internal Testing Account'
                      : (isPaid
                          ? 'Proud Muslim Premium Active'
                          : (isTrial
                              ? '3-Day Free Trial Active'
                              : 'Proud Muslim Free Tier')),
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isTester
                      ? 'Signed in with authorized internal test entitlement. Full unrestricted access to all Free & Premium features.'
                      : (isPaid
                          ? 'You have unlimited access to all Premium features: AI narration, AI explanations, and background audio.'
                          : (isTrial
                              ? 'You have full Premium access during your 3-day trial period.'
                              : 'Core Qur\'an and all prayer tools are free. Subscribe to unlock unlimited AI translation narration.')),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Subscription Products Card
          DeenSectionHeader(
            title: 'AVAILABLE SUBSCRIPTION PLANS',
            icon: Icons.workspace_premium_rounded,
          ),
          const SizedBox(height: 8),

          // Annual Plan Card (Best Value / Recommended)
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Annual Premium',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: deen.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: deen.accentGold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'BEST VALUE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppConstants.formattedPriceAnnualUsd,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: deen.accentPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '3-day free trial, then ${AppConstants.formattedPriceAnnualUsd} (${AppConstants.formattedPriceAnnualEquivalentMonthly}) • Save 37%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: deen.textSecondary,
                  ),
                ),
                if (!hasPremium) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => subProv.subscribeAnnual(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deen.accentGold,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Start 3-Day Free Trial (Annual)',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Monthly Plan Card
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Premium',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                    Text(
                      AppConstants.formattedPriceMonthlyUsd,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '3-day free trial, then ${AppConstants.formattedPriceMonthlyUsd} • Renews monthly',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: deen.textSecondary,
                  ),
                ),
                if (!hasPremium) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => subProv.subscribeMonthly(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: deen.accentPrimary,
                        side: BorderSide(color: deen.accentPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Start 3-Day Free Trial (Monthly)',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Restore & Billing Provider Info
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 14),

          OutlinedButton.icon(
            onPressed: () async {
              final success = await subProv.restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Purchases restored successfully.'
                          : 'No active subscription found to restore.',
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
          const SizedBox(height: 18),

          // 5. Transparent Platform Terms & Disclosures
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Eligible new subscribers receive 3 full days of complimentary Premium access. Subscriptions auto-renew (monthly at ${AppConstants.formattedPriceMonthlyUsd} or yearly at ${AppConstants.formattedPriceAnnualUsd}) unless cancelled at least 24 hours prior to the end of the trial period via Google Play Store / App Store subscription settings. All core Qur\'an reading and religious tools are 100% free with zero advertisements.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: deen.textMuted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
