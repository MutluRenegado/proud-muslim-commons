import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/surah_model.dart';
import '../../models/ayah_model.dart';
import '../../providers/quran_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/deen_card.dart';
import 'quran_sources_view.dart';

import '../../l10n/app_localizations.dart';
import '../../core/services/surah_localization_service.dart';
import '../../core/services/ui_translation_service.dart';
import '../../core/services/storage_service.dart';

class SurahReaderView extends StatefulWidget {
  final SurahModel surah;

  const SurahReaderView({super.key, required this.surah});

  @override
  State<SurahReaderView> createState() => _SurahReaderViewState();
}

class _SurahReaderViewState extends State<SurahReaderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuranProvider>(
        context,
        listen: false,
      ).loadSurahDetail(widget.surah.number);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quranProv = Provider.of<QuranProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final currentLang = quranProv.selectedLanguage;
    final currentEdition = quranProv.selectedEdition;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          '${SurahLocalizationService.localizedName(widget.surah.number, langCode, widget.surah.englishName)} (${widget.surah.name})',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          ),
        ),
        actions: [
          // Language / Translation Selector Quick Pill
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: InkWell(
              onTap: () => _showQuranSettingsSheet(
                context,
                quranProv,
                themeProv,
                deen,
                l10n,
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: deen.accentPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: deen.accentPrimary.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      size: 15,
                      color: deen.accentPrimary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      currentLang?.nativeName ?? 'Translation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: deen.accentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Settings & Typography Button
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: l10n.settings,
            onPressed: () => _showQuranSettingsSheet(
              context,
              quranProv,
              themeProv,
              deen,
              l10n,
            ),
          ),
        ],
      ),
      body: quranProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 1. Surah Hero Header Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
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
                      children: [
                        Text(
                          widget.surah.name,
                          style: GoogleFonts.amiri(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: deen.accentGoldBright,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${SurahLocalizationService.localizedName(widget.surah.number, langCode, widget.surah.englishName)} — ${SurahLocalizationService.meaning(widget.surah.number, langCode, widget.surah.englishNameTranslation)}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${UiTranslationService.text(widget.surah.revelationType == 'Meccan' ? 'meccan' : 'medinan', langCode)} • ${widget.surah.numberOfAyahs} ${l10n.versesCount}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: quranProv.currentAyahs.isEmpty
                                  ? null
                                  : quranProv.playFullSurahArabic,
                              icon: const Icon(
                                Icons.headphones_rounded,
                                size: 18,
                              ),
                              label: Text(UiTranslationService.text(
                                  'playFullSurah', langCode)),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.16),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (quranProv.showTranslation &&
                                currentLang?.code != 'ar') ...[
                              FilledButton.tonalIcon(
                                onPressed: quranProv.currentAyahs.isEmpty
                                    ? null
                                    : quranProv.playFullSurahTranslation,
                                icon: const Icon(
                                  Icons.record_voice_over_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  UiTranslationService.text(
                                    'listenInLang',
                                    langCode,
                                    params: {
                                      'lang': currentLang?.nativeName ??
                                          currentLang?.englishName ??
                                          '',
                                    },
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: deen.accentGoldBright,
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                              _buildVoiceGenderPill(langCode, deen),
                            ],
                            IconButton.filledTonal(
                              onPressed: quranProv.stopFullSurahAudio,
                              tooltip: UiTranslationService.text(
                                  'stopAudio', langCode),
                              icon: const Icon(Icons.stop_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.16),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (widget.surah.number != 9 &&
                            widget.surah.number != 1) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 6),
                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            style: GoogleFonts.amiri(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // 2. Active Translation Info Pill
                if (quranProv.showTranslation &&
                    currentEdition != null &&
                    currentLang?.code != 'ar')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: deen.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${currentLang?.englishName ?? ''} translation: ${currentEdition.translatorName}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: deen.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 3. Ayahs List
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final ayah = quranProv.currentAyahs[index];
                    return _buildAyahCard(
                      context,
                      ayah,
                      quranProv,
                      themeProv,
                      deen,
                      l10n,
                    );
                  }, childCount: quranProv.currentAyahs.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: bottomInset + 32)),
              ],
            ),
    );
  }

  Widget _buildAyahCard(
    BuildContext context,
    AyahModel ayah,
    QuranProvider quranProv,
    ThemeProvider themeProv,
    DeenThemeTokens deen,
    AppLocalizations l10n,
  ) {
    final isBookmarked = quranProv.isAyahBookmarked(ayah.number);
    final isPlaying = quranProv.currentlyPlayingAudio == ayah.audioUrl;
    final isRtlTranslation = ayah.isRtlTranslation ||
        quranProv.selectedLanguageCode == 'ur' ||
        quranProv.selectedLanguageCode == 'fa' ||
        quranProv.selectedLanguageCode == 'ar';

    return DeenCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      isSelected: isPlaying,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar: Ayah Badge, Audio, Copy, Bookmark, Share
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
                  'Ayah ${widget.surah.number}:${ayah.number}',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: deen.accentPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  // Play Audio
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: isPlaying ? deen.accentGold : deen.accentPrimary,
                      size: 24,
                    ),
                    tooltip: l10n.reciteAyah,
                    onPressed: () {
                      if (ayah.audioUrl != null && ayah.audioUrl!.isNotEmpty) {
                        quranProv.playAyahAudio(ayah.audioUrl!);
                      }
                    },
                  ),
                  // Copy Verse
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 20,
                      color: deen.textSecondary,
                    ),
                    tooltip: l10n.copyAyah,
                    onPressed: () {
                      final copyText = ayah.translation.isNotEmpty &&
                              quranProv.showTranslation
                          ? '${widget.surah.englishName} [${widget.surah.number}:${ayah.number}]\n${ayah.text}\n${ayah.translation}'
                          : '${widget.surah.englishName} [${widget.surah.number}:${ayah.number}]\n${ayah.text}';
                      Clipboard.setData(ClipboardData(text: copyText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.surah.englishName} [${widget.surah.number}:${ayah.number}] ${l10n.ayahCopied}',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  // Bookmark
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color:
                          isBookmarked ? deen.accentGold : deen.textSecondary,
                      size: 22,
                    ),
                    tooltip: 'Bookmark',
                    onPressed: () => quranProv.toggleBookmark(ayah.number),
                  ),
                  // Share
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: deen.textSecondary,
                    ),
                    tooltip: l10n.share,
                    onPressed: () {
                      Share.share(
                        '${widget.surah.englishName} [${widget.surah.number}:${ayah.number}]\n\n${ayah.text}\n\n"${ayah.translation}"\n\nShared via Proud Muslim App',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Canonical Arabic Quran Text (Always Visible & RTL)
          Text(
            ayah.text,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: quranProv.arabicFontSize,
              fontWeight: FontWeight.bold,
              color: deen.arabicPrimary,
              height: 1.8,
            ),
          ),

          // Translation (When Enabled)
          if (quranProv.showTranslation && ayah.translation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              ayah.translation,
              textDirection:
                  isRtlTranslation ? TextDirection.rtl : TextDirection.ltr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: quranProv.translationFontSize,
                color: deen.textSecondary,
                height: 1.48,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showQuranSettingsSheet(
    BuildContext context,
    QuranProvider quranProv,
    ThemeProvider themeProv,
    DeenThemeTokens deen,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final languages = quranProv.supportedLanguages;
            final editions = quranProv.availableEditionsForCurrentLanguage;
            final langCode = Localizations.localeOf(context).languageCode;

            return SafeArea(
              top: false,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quran Translation & Settings',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: deen.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 1. Show Translation Switch
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: deen.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate_rounded,
                                color: deen.accentPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Show Translation',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  color: deen.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: quranProv.showTranslation,
                            activeColor: deen.accentPrimary,
                            onChanged: (val) {
                              quranProv.toggleShowTranslation(val);
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. 14 Translation Languages Selector
                    Text(
                      'Translation Language (14)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: deen.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: deen.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: languages.map((lang) {
                          final isSelected =
                              quranProv.selectedLanguageCode == lang.code;
                          return ChoiceChip(
                            selected: isSelected,
                            showCheckmark: true,
                            label: Text(
                              '${lang.nativeName} (${lang.englishName})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? deen.accentPrimary
                                    : deen.textPrimary,
                              ),
                            ),
                            selectedColor: deen.badgeBackground,
                            side: BorderSide(
                              color: isSelected
                                  ? deen.accentPrimary
                                  : deen.cardBorder,
                            ),
                            onSelected: (_) async {
                              await quranProv.changeTranslationLanguage(
                                lang.code,
                              );
                              if (ctx.mounted) setModalState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Translator / Edition Selector (if multiple available)
                    if (editions.length > 1) ...[
                      Text(
                        'Translator Edition',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: deen.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: deen.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: deen.cardBorder),
                        ),
                        child: Column(
                          children: editions.map((ed) {
                            final isSelected =
                                quranProv.selectedEditionId == ed.id;
                            return ListTile(
                              dense: true,
                              title: Text(
                                ed.translatorName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? deen.accentPrimary
                                      : deen.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                ed.source,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: deen.textMuted,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: deen.accentPrimary,
                                      size: 18,
                                    )
                                  : Icon(
                                      Icons.radio_button_off_rounded,
                                      color: deen.textMuted,
                                      size: 18,
                                    ),
                              onTap: () {
                                quranProv.changeTranslationEdition(ed.id);
                                setModalState(() {});
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 4. Spoken Voice Selection (Male / Female)
                    Text(
                      UiTranslationService.text('narrationVoice', langCode),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: deen.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'male',
                          icon: const Icon(Icons.man_rounded, size: 18),
                          label: Text(
                              UiTranslationService.text('voiceMale', langCode)),
                        ),
                        ButtonSegment(
                          value: 'female',
                          icon: const Icon(Icons.woman_rounded, size: 18),
                          label: Text(UiTranslationService.text(
                              'voiceFemale', langCode)),
                        ),
                      ],
                      selected: {StorageService.ttsVoiceGender},
                      onSelectionChanged: (val) async {
                        await StorageService.setTtsVoiceGender(val.first);
                        if (ctx.mounted) setModalState(() {});
                        setState(() {});
                      },
                      showSelectedIcon: false,
                    ),
                    const SizedBox(height: 16),

                    // 5. Download for Offline Use Button
                    ...[
                      OutlinedButton.icon(
                        onPressed: quranProv.isDownloading
                            ? null
                            : () async {
                                final success =
                                    await quranProv.downloadLanguageForOffline(
                                  quranProv.selectedLanguageCode,
                                );
                                if (ctx.mounted) setModalState(() {});
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? '${quranProv.selectedLanguage?.englishName} downloaded for offline use.'
                                            : 'Could not download translation. Please check connection.',
                                      ),
                                    ),
                                  );
                                }
                              },
                        icon: quranProv.isDownloading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: quranProv.downloadProgress > 0
                                      ? quranProv.downloadProgress
                                      : null,
                                ),
                              )
                            : const Icon(Icons.download_rounded, size: 18),
                        label: Text(
                          quranProv.isDownloading
                              ? 'Downloading (${(quranProv.downloadProgress * 100).toInt()}%)...'
                              : 'Download ${quranProv.selectedLanguage?.englishName ?? ''} for Offline Use',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: deen.accentPrimary,
                          side: BorderSide(
                            color: deen.accentPrimary.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 5. Typography Sliders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.arabicFontSize,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary,
                          ),
                        ),
                        Text(
                          '${quranProv.arabicFontSize.round()} pt',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: deen.accentPrimary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: quranProv.arabicFontSize,
                      min: 18.0,
                      max: 36.0,
                      divisions: 9,
                      activeColor: deen.accentPrimary,
                      onChanged: (val) {
                        quranProv.setArabicFontSize(val);
                        themeProv.setArabicFontSize(val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translationFontSize,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary,
                          ),
                        ),
                        Text(
                          '${quranProv.translationFontSize.round()} pt',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: deen.accentGold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: quranProv.translationFontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 6,
                      activeColor: deen.accentGold,
                      onChanged: (val) {
                        quranProv.setTranslationFontSize(val);
                        themeProv.setTranslationFontSize(val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 14),

                    // 6. View Sources & Attributions Link
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuranSourcesView(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: deen.accentPrimary,
                      ),
                      label: Text(
                        'View Translation Sources & Attributions',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: deen.accentPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Done Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deen.accentPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        l10n.done,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoiceGenderPill(String langCode, DeenThemeTokens deen) {
    final currentGender = StorageService.ttsVoiceGender;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              await StorageService.setTtsVoiceGender('male');
              setState(() {});
            },
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: currentGender == 'male'
                    ? deen.accentGoldBright
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.man_rounded,
                    size: 16,
                    color:
                        currentGender == 'male' ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    UiTranslationService.text('voiceMale', langCode),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: currentGender == 'male'
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await StorageService.setTtsVoiceGender('female');
              setState(() {});
            },
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: currentGender == 'female'
                    ? deen.accentGoldBright
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.woman_rounded,
                    size: 16,
                    color: currentGender == 'female'
                        ? Colors.black87
                        : Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    UiTranslationService.text('voiceFemale', langCode),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: currentGender == 'female'
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
