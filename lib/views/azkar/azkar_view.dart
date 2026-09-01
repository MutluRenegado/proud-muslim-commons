import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/azkar_model.dart';
import '../../core/services/azkar_data_service.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/themed_illustration.dart';

import '../../l10n/app_localizations.dart';

class AzkarView extends StatefulWidget {
  const AzkarView({super.key});

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  List<AzkarCategoryModel> _categories = [];
  bool _isLoading = true;
  final Map<String, int> _itemProgress = {};
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await AzkarDataService.loadAzkar();
    setState(() {
      _categories = list;
      _isLoading = false;
    });
  }

  void _incrementDua(String id, int target) {
    HapticFeedback.lightImpact();
    setState(() {
      final cur = _itemProgress[id] ?? 0;
      if (cur < target) {
        _itemProgress[id] = cur + 1;
        if (_itemProgress[id] == target) {
          HapticFeedback.heavyImpact();
        }
      } else {
        _itemProgress[id] = 0;
      }
    });
  }

  DeenIllustration _getCategoryIllustration(int index) {
    switch (index % 6) {
      case 0:
        return DeenIllustration.mosqueDawn;
      case 1:
        return DeenIllustration.mosqueNight;
      case 2:
        return DeenIllustration.prayerMat;
      case 3:
        return DeenIllustration.lantern;
      case 4:
        return DeenIllustration.duaHands;
      case 5:
      default:
        return DeenIllustration.tasbihBeads;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final selectedCategory =
        _categories.isNotEmpty && _selectedCategoryIndex < _categories.length
            ? _categories[_selectedCategoryIndex]
            : null;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          '${l10n.dailyAzkar} (حصن المسلم)',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Horizontal Category Carousel / Chips
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = index == _selectedCategoryIndex;
                      final illustration = _getCategoryIllustration(index);

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 110,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (deen.isDark
                                    ? deen.surfaceElevated
                                    : deen.badgeBackground)
                                : deen.cardBackground,
                            borderRadius: BorderRadius.circular(AppRadius.m),
                            border: Border.all(
                              color: isSelected
                                  ? deen.accentGold
                                  : deen.cardBorder,
                              width: isSelected ? 1.6 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? AppShadows.glow(deen.accentGold, radius: 10)
                                : [
                                    BoxShadow(
                                      color: deen.cardShadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ThemedIllustration(
                                illustration: illustration,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.getLocalizedTitle(languageCode),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? deen.accentPrimary
                                      : deen.textPrimary,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),

                // 2. Active Category Duas List
                Expanded(
                  child: selectedCategory == null
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: bottomInset + 32,
                          ),
                          itemCount: selectedCategory.items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = selectedCategory.items[itemIndex];
                            final localizedTitle = item.getLocalizedTitle(
                              languageCode,
                            );
                            final localizedTranslation =
                                item.getLocalizedTranslation(languageCode);
                            final localizedBenefit = item.getLocalizedBenefit(
                              languageCode,
                            );
                            final showTargetTranslation =
                                languageCode != 'en' &&
                                    languageCode != 'ar' &&
                                    localizedTranslation != item.translation;
                            final progress = _itemProgress[item.id] ?? 0;
                            final isComplete = progress >= item.repeat;

                            return DeenCard(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              padding: const EdgeInsets.all(16),
                              isSelected: isComplete,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Header: Title & Counter Button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          localizedTitle,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: deen.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Tactile Counter Button
                                      InkWell(
                                        onTap: () =>
                                            _incrementDua(item.id, item.repeat),
                                        borderRadius: BorderRadius.circular(20),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isComplete
                                                ? deen.success
                                                : deen.badgeBackground,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: isComplete
                                                  ? deen.success
                                                  : deen.badgeBorder,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isComplete
                                                    ? Icons.check_circle_rounded
                                                    : Icons.touch_app_rounded,
                                                size: 16,
                                                color: isComplete
                                                    ? Colors.white
                                                    : deen.accentPrimary,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '$progress / ${item.repeat}',
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.5,
                                                  color: isComplete
                                                      ? Colors.white
                                                      : deen.accentPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Arabic Dua
                                  Text(
                                    item.arabic,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.amiri(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1.8,
                                      color: deen.arabicPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Transliteration
                                  if (item.transliteration.isNotEmpty) ...[
                                    Text(
                                      item.transliteration,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: deen.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],

                                  // Translation
                                  Text(
                                    'English\n${item.translation}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      color: deen.textPrimary,
                                      height: 1.45,
                                    ),
                                  ),
                                  if (showTargetTranslation) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      localizedTranslation,
                                      textDirection: Directionality.of(context),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: deen.accentPrimary,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 10),

                                  // Reference & Reward Badges
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: deen.badgeBackground,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          'Ref: ${item.reference}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: deen.textMuted,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (localizedBenefit.isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            localizedBenefit,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: deen.accentPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
