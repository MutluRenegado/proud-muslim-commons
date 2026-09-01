import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../models/hadith_model.dart';
import '../../core/services/hadith_data_service.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

class HadithView extends StatefulWidget {
  const HadithView({super.key});

  @override
  State<HadithView> createState() => _HadithViewState();
}

class _HadithViewState extends State<HadithView> {
  List<HadithModel> _hadiths = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await HadithDataService.loadNawawiHadiths();
    setState(() {
      _hadiths = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final filtered = _hadiths.where((h) {
      final q = _searchQuery.toLowerCase();
      return h.getLocalizedTitle(languageCode).toLowerCase().contains(q) ||
          h.translation.toLowerCase().contains(q) ||
          h.getLocalizedTranslation(languageCode).toLowerCase().contains(q) ||
          h.arabic.contains(_searchQuery) ||
          h.id.toString() == _searchQuery;
    }).toList();

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.imamNawawi40Hadith,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books_outlined),
            tooltip:
                UiTranslationService.text('openHadithLibrary', languageCode),
            onPressed: () => launchUrl(
              Uri.parse('https://sunnah.com/'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          LocalizedHelpIcon(
            title: l10n.imamNawawi40Hadith,
            description: l10n.searchHadithHint,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.plusJakartaSans(color: deen.textPrimary),
              decoration: InputDecoration(
                hintText: l10n.searchHadithHint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: deen.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: deen.accentPrimary,
                ),
                filled: true,
                fillColor: deen.cardBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: deen.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: deen.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: deen.accentGold, width: 1.5),
                ),
              ),
            ),
          ),

          // Hadith Cards List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.only(top: 4, bottom: bottomInset + 32),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final rawLocalizedTitle = item.getLocalizedTitle(
                        languageCode,
                      );
                      final localizedTitle = item.id > 6 &&
                              languageCode != 'en' &&
                              languageCode != 'ar' &&
                              rawLocalizedTitle == item.title
                          ? UiTranslationService.text(
                              'hadithNumber',
                              languageCode,
                              params: {'number': item.id.toString()},
                            )
                          : rawLocalizedTitle;
                      final localizedTranslation = item.getLocalizedTranslation(
                        languageCode,
                      );
                      final localizedNarrator = item.getLocalizedNarrator(
                        languageCode,
                      );
                      final localizedSource = item.getLocalizedSource(
                        languageCode,
                      );
                      final localizedExplanation = item.getLocalizedExplanation(
                        languageCode,
                      );
                      final showTargetTranslation = languageCode != 'en' &&
                          languageCode != 'ar' &&
                          localizedTranslation != item.translation;
                      return DeenCard(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: deen.badgeBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: deen.badgeBorder),
                                  ),
                                  child: Text(
                                    UiTranslationService.text(
                                      'hadithNumber',
                                      languageCode,
                                      params: {'number': item.id.toString()},
                                    ),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: deen.accentPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.copy_rounded,
                                        size: 19,
                                        color: deen.accentPrimary,
                                      ),
                                      tooltip: MaterialLocalizations.of(context)
                                          .copyButtonLabel,
                                      onPressed: () => Clipboard.setData(
                                        ClipboardData(
                                          text:
                                              '${item.arabic}\n\n${item.translation}${showTargetTranslation ? '\n\n$localizedTranslation' : ''}\n\n— $localizedSource',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.share_outlined,
                                        size: 20,
                                        color: deen.accentPrimary,
                                      ),
                                      tooltip: l10n.shareHadith,
                                      onPressed: () {
                                        Share.share(
                                          'Hadith #${item.id} - $localizedTitle:\n\n${item.arabic}\n\nEnglish:\n${item.translation}${showTargetTranslation ? '\n\n$localizedTranslation' : ''}\n\n— $localizedSource ($localizedNarrator)\n\nShared via Proud Muslim App',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizedTitle,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: deen.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                            if (languageCode == 'en' ||
                                !showTargetTranslation) ...[
                              Text(
                                '"${item.translation}"',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontStyle: FontStyle.italic,
                                  color: deen.textPrimary,
                                  height: 1.45,
                                ),
                              ),
                            ] else ...[
                              Text(
                                localizedTranslation,
                                textDirection: Directionality.of(context),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: deen.textPrimary,
                                  height: 1.45,
                                ),
                              ),
                            ],
                            if (localizedExplanation.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                localizedExplanation,
                                textDirection: Directionality.of(context),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color: deen.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                Text(
                                  localizedSource,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: deen.accentGold,
                                  ),
                                ),
                                Text(
                                  '${l10n.narrator}: $localizedNarrator',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: deen.textMuted,
                                  ),
                                ),
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
