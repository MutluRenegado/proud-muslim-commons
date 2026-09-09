import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final isSubscribed = subProv.hasAdFreeAccess;
    final product = subProv.annualProduct;
    final billingProvider = subProv.billingProvider;
    final isSpecialAccount = StorageService.isPermanentAdFreeAccount;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Proud Muslim Ad-Free',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: 'Ad-Free Subscription',
            description:
                'Proud Muslim is completely free to use. Reading Quran and 99 Names of Allah are permanently ad-free for all users. The Ad-Free subscription removes advertisements from the remaining features.',
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
          // 1. Core Islamic Promise Box (Quran & 99 Names Free Forever & Ad-Free)
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
                        '100% Free Forever & Ad-Free',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: deen.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Reading Quran and 99 Names of Allah (Esmaul Husna) will never require payment and will never show advertisements.',
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

          // 2. Header Status Banner
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
                        StorageService.isViewerAccount
                            ? 'TESTER (VIEWER)'
                            : (isSubscribed
                                ? 'AD-FREE ACTIVE'
                                : 'FREE (AD-SUPPORTED)'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Icon(
                      isSubscribed
                          ? Icons.verified_rounded
                          : Icons.block_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isSubscribed
                      ? (StorageService.isViewerAccount
                          ? 'Tester (Viewer Mode) Active'
                          : 'Ad-Free Experience Active')
                      : 'Go Ad-Free for the Whole App',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isSubscribed
                      ? (StorageService.isViewerAccount
                          ? 'Signed in as Test Account (Viewer Mode). Full unrestricted access across all features and screens with zero advertisements.'
                          : (isSpecialAccount
                              ? 'You are signed in with an authorized permanent Ad-Free account. No ads will be shown anywhere in the app.'
                              : 'You have an active Ad-Free subscription. All advertisements are disabled across the app.'))
                      : 'All Proud Muslim features are 100% free to use. Subscribe to enjoy a pure, ad-free spiritual environment across all screens.',
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

          // 3. Plan & Pricing Details Card
          DeenSectionHeader(
            title: 'SUBSCRIPTION & BILLING',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Annual Ad-Free Subscription',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    isSubscribed
                        ? (StorageService.isViewerAccount
                            ? 'Test Account (Viewer Mode)'
                            : (isSpecialAccount
                                ? 'Permanent Free Account'
                                : 'Yearly Auto-Renewing'))
                        : '${product.introPrice} for the 1st year',
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    isSubscribed ? 'Active' : product.introPrice,
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
                    'Regular Yearly Renewal',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Renews annually after the first year',
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    product.regularPrice,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: deen.textSecondary,
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Action Buttons
          if (!isSubscribed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => subProv.subscribeAdFree(),
                icon: const Icon(Icons.block_rounded, size: 20),
                label: Text(
                  'Subscribe Ad-Free (${product.introPrice} / 1st Year)',
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
                          ? 'Ad-Free purchases restored successfully.'
                          : 'No active Ad-Free subscriptions found.',
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

          // 5. Transparent Google Play Terms & Disclosures
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Subscriptions auto-renew yearly (every 12 months) at ${product.regularPrice} unless canceled at least 24 hours prior to renewal through Google Play Store > Subscriptions. All application features (Prayer times, Qibla compass, Azkar, Hadith, Calendar, Themes) are 100% free to use. Reading Quran and 99 Names of Allah are free forever and will never show ads.',
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
