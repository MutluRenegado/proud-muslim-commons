import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../providers/zakat_provider.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class ZakatView extends StatefulWidget {
  const ZakatView({super.key});

  @override
  State<ZakatView> createState() => _ZakatViewState();
}

class _ZakatViewState extends State<ZakatView> {
  final _cashCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _stocksCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  @override
  void dispose() {
    _cashCtrl.dispose();
    _goldCtrl.dispose();
    _silverCtrl.dispose();
    _stocksCtrl.dispose();
    _businessCtrl.dispose();
    _debtsCtrl.dispose();
    super.dispose();
  }

  void _onValuesChanged(ZakatProvider prov) {
    prov.updateValues(
      cash: double.tryParse(_cashCtrl.text) ?? 0,
      goldGrams: double.tryParse(_goldCtrl.text) ?? 0,
      silverGrams: double.tryParse(_silverCtrl.text) ?? 0,
      stocksAndInvestments: double.tryParse(_stocksCtrl.text) ?? 0,
      businessGoods: double.tryParse(_businessCtrl.text) ?? 0,
      immediateDebts: double.tryParse(_debtsCtrl.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final zakatProv = Provider.of<ZakatProvider>(context);
    final calc = zakatProv.calc;
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          l10n.zakatCalculatorTitle,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.zakatCalculatorTitle,
            description: l10n.zakatNote,
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: deen.accentPrimary),
            tooltip: l10n.reset,
            onPressed: () {
              _cashCtrl.clear();
              _goldCtrl.clear();
              _silverCtrl.clear();
              _stocksCtrl.clear();
              _businessCtrl.clear();
              _debtsCtrl.clear();
              zakatProv.reset();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14.0,
          bottom: bottomInset + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Banner Card
            Container(
              padding: const EdgeInsets.all(22),
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
                    color: deen.accentPrimary.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalZakatPayable,
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(minHeight: 28),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: calc.isNisabReached
                              ? deen.accentGold
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          calc.isNisabReached ? l10n.nisabMet : l10n.belowNisab,
                          maxLines: 3,
                          softWrap: true,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: calc.isNisabReached
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(calc.zakatPayable),
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: deen.accentGoldBright,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${l10n.netZakatableWealth}: ${currencyFormatter.format(calc.netZakatableWealth)}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.goldNisabThreshold}: ${currencyFormatter.format(calc.goldNisabThreshold)}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Asset Inputs
            DeenSectionHeader(
              title: l10n.assetsEligibleForZakat,
              icon: Icons.account_balance_wallet_rounded,
            ),
            const SizedBox(height: 10),

            _buildInputField(l10n.cashInHandBank, _cashCtrl, zakatProv, deen),
            _buildInputField(l10n.goldWeightGrams, _goldCtrl, zakatProv, deen),
            _buildInputField(
              l10n.silverWeightGrams,
              _silverCtrl,
              zakatProv,
              deen,
            ),
            _buildInputField(
              l10n.stocksInvestments,
              _stocksCtrl,
              zakatProv,
              deen,
            ),
            _buildInputField(
              l10n.businessInventory,
              _businessCtrl,
              zakatProv,
              deen,
            ),

            const SizedBox(height: 18),

            // Deductions
            DeenSectionHeader(
              title: l10n.liabilitiesImmediateDebts,
              icon: Icons.money_off_rounded,
            ),
            const SizedBox(height: 10),
            _buildInputField(
              l10n.immediateDebtsBills,
              _debtsCtrl,
              zakatProv,
              deen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController ctrl,
    ZakatProvider prov,
    DeenThemeTokens deen,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => _onValuesChanged(prov),
        style: GoogleFonts.plusJakartaSans(color: deen.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.plusJakartaSans(
            color: deen.textSecondary,
            fontSize: 13,
          ),
          filled: true,
          fillColor: deen.cardBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: deen.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: deen.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: deen.accentGold, width: 1.5),
          ),
        ),
      ),
    );
  }
}
