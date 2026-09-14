import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/deen_theme_tokens.dart';
import '../providers/subscription_provider.dart';

class PremiumPaywallSheet extends StatefulWidget {
  const PremiumPaywallSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PremiumPaywallSheet(),
    );
  }

  @override
  State<PremiumPaywallSheet> createState() => _PremiumPaywallSheetState();
}

class _PremiumPaywallSheetState extends State<PremiumPaywallSheet> {
  bool _isAnnualSelected = true;

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final subProv = Provider.of<SubscriptionProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: deen.surfacePrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: deen.cardBorder.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: deen.cardGlowGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Proud Muslim Premium',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: deen.textSecondary),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Core Free Guarantee Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: deen.badgeBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: deen.accentGold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_rounded, color: deen.accentGold, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Core Quran reading, translations, Arabic recitation & all prayer tools are 100% Free with zero ads.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: deen.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Premium Features List
            _buildFeatureItem(
              deen: deen,
              icon: Icons.record_voice_over_rounded,
              title: 'Unlimited AI Translation Narration',
              subtitle: 'Studio-quality Male & Female voices across all 14 languages.',
            ),
            _buildFeatureItem(
              deen: deen,
              icon: Icons.psychology_rounded,
              title: 'AI Verse Explanations & Tafsir',
              subtitle: 'Spiritual insights and context for deeper understanding.',
            ),
            _buildFeatureItem(
              deen: deen,
              icon: Icons.headphones_rounded,
              title: 'Continuous Background Audio',
              subtitle: 'Listen uninterrupted while using other apps or screen off.',
            ),
            const SizedBox(height: 16),

            // Option 1: Annual Plan (Best Value / Recommended)
            InkWell(
              onTap: () => setState(() => _isAnnualSelected = true),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isAnnualSelected
                      ? deen.accentPrimary.withOpacity(0.12)
                      : deen.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isAnnualSelected
                        ? deen.accentPrimary
                        : deen.cardBorder,
                    width: _isAnnualSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isAnnualSelected,
                      activeColor: deen.accentPrimary,
                      onChanged: (val) => setState(() => _isAnnualSelected = true),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Annual Premium',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
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
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3-Day Free Trial • ${AppConstants.formattedPriceAnnualUsd} (${AppConstants.formattedPriceAnnualEquivalentMonthly})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: deen.accentPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Option 2: Monthly Plan
            InkWell(
              onTap: () => setState(() => _isAnnualSelected = false),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: !_isAnnualSelected
                      ? deen.accentPrimary.withOpacity(0.12)
                      : deen.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: !_isAnnualSelected
                        ? deen.accentPrimary
                        : deen.cardBorder,
                    width: !_isAnnualSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _isAnnualSelected,
                      activeColor: deen.accentPrimary,
                      onChanged: (val) => setState(() => _isAnnualSelected = false),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Premium',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: deen.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3-Day Free Trial • ${AppConstants.formattedPriceMonthlyUsd}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: deen.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Primary Call to Action Button
            ElevatedButton(
              onPressed: subProv.isLoading
                  ? null
                  : () async {
                      bool success = false;
                      if (_isAnnualSelected) {
                        success = await subProv.subscribeAnnual();
                      } else {
                        success = await subProv.subscribeMonthly();
                      }
                      if (context.mounted && success) {
                        Navigator.pop(context, true);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: deen.accentGold,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: subProv.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Start 3-Day Free Trial',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 10),

            // Restore Purchases
            Center(
              child: TextButton(
                onPressed: subProv.isLoading
                    ? null
                    : () async {
                        final restored = await subProv.restorePurchases();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                restored
                                    ? 'Purchases restored successfully.'
                                    : 'No active subscription found to restore.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          if (restored) Navigator.pop(context, true);
                        }
                      },
                child: Text(
                  'Restore Purchases',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: deen.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Platform Terms & Disclosures
            Text(
              'Eligible new subscribers receive 3 full days of complimentary Premium access. After the 3-day trial, the selected subscription (${_isAnnualSelected ? AppConstants.formattedPriceAnnualUsd : AppConstants.formattedPriceMonthlyUsd}) will apply and automatically renew unless cancelled at least 24 hours prior to the end of the trial period via Google Play Store / App Store subscription settings.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                color: deen.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required DeenThemeTokens deen,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: deen.accentPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: deen.accentPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: deen.textPrimary,
                  ),
                ),
                const SizedBox(height: 1.5),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: deen.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
