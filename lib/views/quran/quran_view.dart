import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/surah_model.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/themed_illustration.dart';
import 'surah_reader_view.dart';
import 'quran_sources_view.dart';

import '../../l10n/app_localizations.dart';
import '../../core/services/surah_localization_service.dart';
import '../../core/services/ui_translation_service.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filter = 'all'; // 'all', 'Meccan', 'Medinan'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runSearch() {
    FocusScope.of(context).unfocus();
    setState(() => _searchQuery = _searchController.text.trim());
  }

  String _normalizeSearch(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06ff]+'), '')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('û', 'u');

  int _editDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    var previous = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 0; i < a.length; i++) {
      final current = <int>[i + 1];
      for (var j = 0; j < b.length; j++) {
        current.add(
          [
            current[j] + 1,
            previous[j + 1] + 1,
            previous[j] + (a[i] == b[j] ? 0 : 1),
          ].reduce((x, y) => x < y ? x : y),
        );
      }
      previous = current;
    }
    return previous.last;
  }

  bool _matchesSurah(SurahModel surah, String rawQuery, String languageCode) {
    final query = _normalizeSearch(rawQuery);
    if (query.isEmpty) return true;
    if (surah.number.toString() == query) return true;
    final candidates = <String>[
      surah.englishName,
      SurahLocalizationService.localizedName(
          surah.number, languageCode, surah.englishName),
      SurahLocalizationService.meaning(
          surah.number, languageCode, surah.englishNameTranslation),
      surah.name,
    ].map(_normalizeSearch);
    return candidates.any((candidate) {
      if (candidate.contains(query) || candidate.startsWith(query)) return true;
      final allowance = query.length < 5 ? 1 : 2;
      return _editDistance(candidate, query) <= allowance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quranProv = Provider.of<QuranProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final filteredSurahs = quranProv.surahs.where((s) {
      final matchesQuery = _matchesSurah(s, _searchQuery, languageCode);

      if (!matchesQuery) return false;
      if (_filter == 'all') return true;
      return s.revelationType.toLowerCase() == _filter.toLowerCase();
    }).toList();

    // Last read surah fallback
    final lastReadSurah =
        quranProv.surahs.isNotEmpty ? quranProv.surahs.first : null;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.holyQuran,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.source_outlined),
            tooltip: l10n.quranTranslationSources,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuranSourcesView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _searchQuery = value.trim()),
              onSubmitted: (_) => _runSearch(),
              style: GoogleFonts.plusJakartaSans(color: deen.textPrimary),
              decoration: InputDecoration(
                hintText: l10n.searchSurahHint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: deen.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: deen.accentPrimary,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty ||
                        _searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 6),
                      child: FilledButton(
                        onPressed: _runSearch,
                        style: FilledButton.styleFrom(
                          backgroundColor: deen.accentPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(l10n.search),
                      ),
                    ),
                  ],
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

          // 2. Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('all', _filterLabel(context, 'all'), deen),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Meccan',
                  _filterLabel(context, 'meccan'),
                  deen,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Medinan',
                  _filterLabel(context, 'medinan'),
                  deen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // 3. Surah List & Continue Reading Hero Card
          Expanded(
            child: quranProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : quranProv.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 52,
                                color: deen.warning,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                quranProv.errorMessage!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  color: deen.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: quranProv.loadSurahs,
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text(l10n.continueText),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredSurahs.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 52,
                                    color: deen.textMuted,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${l10n.search}: “$_searchQuery”',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: deen.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: bottomInset + 32),
                            itemCount: filteredSurahs.length +
                                (lastReadSurah != null && _searchQuery.isEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              // Top Continue Reading Card when not searching
                              if (lastReadSurah != null &&
                                  _searchQuery.isEmpty &&
                                  index == 0) {
                                return _buildContinueReadingHeroCard(
                                  context,
                                  lastReadSurah,
                                  deen,
                                  l10n,
                                );
                              }

                              final surahIndex = (lastReadSurah != null &&
                                      _searchQuery.isEmpty)
                                  ? index - 1
                                  : index;
                              final surah = filteredSurahs[surahIndex];
                              return _buildSurahTile(
                                  context, surah, deen, l10n);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(BuildContext context, String key) {
    final languageCode = Localizations.localeOf(context).languageCode;
    const labels = <String, Map<String, String>>{
      'all': {
        'ar': 'كل السور (114)',
        'de': 'Alle Suren (114)',
        'en': 'All Surahs (114)',
        'es': 'Todas (114)',
        'fr': 'Toutes (114)',
        'id': 'Semua Surah (114)',
        'ms': 'Semua Surah (114)',
        'pt': 'Todas (114)',
        'ru': 'Все суры (114)',
        'tr': 'Tüm Sureler (114)',
        'ur': 'تمام سورتیں (114)',
      },
      'meccan': {
        'ar': 'مكية',
        'de': 'Mekkanisch',
        'en': 'Meccan',
        'es': 'Mecanas',
        'fr': 'Mecquoises',
        'id': 'Makkiyah',
        'ms': 'Makkiyah',
        'pt': 'Mecanas',
        'ru': 'Мекканские',
        'tr': 'Mekkî',
        'ur': 'مکی',
      },
      'medinan': {
        'ar': 'مدنية',
        'de': 'Medinensisch',
        'en': 'Medinan',
        'es': 'Medinenses',
        'fr': 'Médinoises',
        'id': 'Madaniyah',
        'ms': 'Madaniyah',
        'pt': 'Medinenses',
        'ru': 'Мединские',
        'tr': 'Medenî',
        'ur': 'مدنی',
      },
    };
    return labels[key]?[languageCode] ?? labels[key]?['en'] ?? key;
  }

  Widget _buildFilterChip(String key, String label, DeenThemeTokens deen) {
    final isSelected = _filter == key;
    return InkWell(
      onTap: () => setState(() => _filter = key),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? deen.accentPrimary : deen.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? deen.accentPrimary : deen.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : deen.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueReadingHeroCard(
    BuildContext context,
    SurahModel surah,
    DeenThemeTokens deen,
    AppLocalizations l10n,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(18),
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
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bookmark_added_rounded,
                      size: 16,
                      color: deen.accentGoldBright,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.readNow.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: deen.accentGoldBright,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  SurahLocalizationService.localizedName(
                    surah.number,
                    languageCode,
                    surah.englishName,
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${SurahLocalizationService.meaning(surah.number, languageCode, surah.englishNameTranslation)} • ${UiTranslationService.text(surah.revelationType == 'Meccan' ? 'meccan' : 'medinan', languageCode)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahReaderView(surah: surah),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: Text(l10n.readNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deen.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const ThemedIllustration(
            illustration: DeenIllustration.quranRehal,
            size: 72,
          ),
        ],
      ),
    );
  }

  Widget _buildSurahTile(
    BuildContext context,
    SurahModel surah,
    DeenThemeTokens deen,
    AppLocalizations l10n,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return DeenCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SurahReaderView(surah: surah)),
        );
      },
      child: Row(
        children: [
          // Geometric Surah Number Badge
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: deen.badgeBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: deen.accentGold.withOpacity(0.6),
                width: 1.2,
              ),
            ),
            child: Text(
              '${surah.number}',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: deen.accentPrimary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // English Title & Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SurahLocalizationService.localizedName(
                    surah.number,
                    languageCode,
                    surah.englishName,
                  ),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    color: deen.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  SurahLocalizationService.meaning(
                    surah.number,
                    languageCode,
                    surah.englishNameTranslation,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: deen.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${UiTranslationService.text(surah.revelationType == 'Meccan' ? 'meccan' : 'medinan', languageCode)} • ${surah.numberOfAyahs} ${l10n.versesCount}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: deen.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Arabic Name in Calligraphy
          Text(
            surah.name,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: deen.arabicPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
