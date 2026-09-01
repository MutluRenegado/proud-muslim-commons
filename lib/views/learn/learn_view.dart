import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/allah_name_model.dart';
import '../../models/ayah_model.dart';
import '../../core/services/names_of_allah_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/surah_localization_service.dart';
import '../../core/repositories/quran_repository.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

class LearnView extends StatefulWidget {
  const LearnView({super.key});

  @override
  State<LearnView> createState() => _LearnViewState();
}

class _LearnViewState extends State<LearnView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AllahNameModel> _names = [];
  bool _isLoading = true;
  String _guideMode = 'salah';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNames();
  }

  Future<void> _loadNames() async {
    final list = await NamesOfAllahService.loadNames();
    setState(() {
      _names = list;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.salahAnd99Names,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpNamesOfAllahTitle,
            description: l10n.helpNamesOfAllahDesc,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: deen.accentGold,
          indicatorWeight: 3,
          labelColor: deen.accentGold,
          unselectedLabelColor: deen.textSecondary,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
          tabs: [
            Tab(
              text: l10n.namesOfAllah,
              icon: const Icon(Icons.star_rounded, size: 20),
            ),
            Tab(
              text: UiTranslationService.text(
                  'salahWudu', Localizations.localeOf(context).languageCode),
              icon: const Icon(Icons.accessibility_new_rounded, size: 20),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 99 Names Tab
          _buildNamesTab(bottomInset, l10n, deen),

          // Salah Guide Tab
          _buildSalahGuideTab(bottomInset, deen),
        ],
      ),
    );
  }

  Widget _buildNamesTab(
    double bottomInset,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final langCode = Localizations.localeOf(context).languageCode;

    return GridView.builder(
      padding: EdgeInsets.only(
        left: AppSpacing.screenMargin,
        right: AppSpacing.screenMargin,
        top: 14,
        bottom: bottomInset + 32,
      ),
      itemCount: _names.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final item = _names[index];
        final localizedMeaning = item.getMeaning(langCode);

        return DeenCard(
          padding: const EdgeInsets.all(12),
          onTap: () => _showNameDetail(item, langCode, l10n, deen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${item.number}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: deen.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.volume_up_rounded,
                    size: 16,
                    color: deen.accentPrimary.withOpacity(0.7),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.arabic,
                style: GoogleFonts.amiri(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: deen.arabicPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.transliteration,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: deen.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                localizedMeaning,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: deen.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNameDetail(
    AllahNameModel item,
    String langCode,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final isTurkish = langCode == 'tr';
    final localizedMeaning = item.getMeaning(langCode);
    final localizedExplanation = item.getExplanation(langCode);

    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ValueListenableBuilder<String?>(
          valueListenable: AudioService.currentPlayingIdNotifier,
          builder: (context, playingId, _) {
            final isPlayingAr = playingId == 'ar_${item.number}';
            final isPlayingTrPron = playingId == 'tr_pron_${item.number}';
            final isPlayingExpl =
                playingId == 'expl_${langCode}_${item.number}';

            return SafeArea(
              top: false,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: deen.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Arabic Calligraphy
                    Center(
                      child: Text(
                        item.arabic,
                        style: GoogleFonts.amiri(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: deen.accentGold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '#${item.number} ${item.transliteration}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Audio Controls
                    if (isTurkish) ...[
                      // Turkish mode follows the supplied 99 Names rules:
                      // line 1 native Arabic pronunciation, line 2 Turkish explanation,
                      // line 3 Turkish pronunciation.
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => AudioService.playNativeArabicName(
                            item.number,
                            arabicText: item.arabic,
                            assetPath: item.arabicNativeAudio,
                          ),
                          icon: Icon(
                            isPlayingAr
                                ? Icons.stop_rounded
                                : Icons.volume_up_rounded,
                            size: 17,
                            color: isPlayingAr
                                ? Colors.redAccent
                                : deen.accentPrimary,
                          ),
                          label: Text(
                            isPlayingAr ? l10n.stopAudio : l10n.listenArabic,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isPlayingAr
                                  ? Colors.redAccent
                                  : deen.accentPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: isPlayingAr
                                    ? Colors.redAccent
                                    : deen.accentPrimary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => AudioService.playExplanationAudio(
                            number: item.number,
                            langCode: 'tr',
                            explanationText: localizedExplanation,
                            assetPath: item.turkishExplanationAudio,
                          ),
                          icon: Icon(
                            isPlayingExpl
                                ? Icons.stop_rounded
                                : Icons.auto_stories_rounded,
                            size: 17,
                            color: isPlayingExpl
                                ? Colors.redAccent
                                : deen.accentGold,
                          ),
                          label: Text(
                            isPlayingExpl
                                ? l10n.stopAudio
                                : l10n.listenExplanation,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isPlayingExpl
                                  ? Colors.redAccent
                                  : deen.accentGold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: isPlayingExpl
                                    ? Colors.redAccent
                                    : deen.accentGold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final readText = item.pronunciation.isNotEmpty
                                ? item.pronunciation
                                : (item.turkish.isNotEmpty
                                    ? item.turkish
                                    : item.transliteration);
                            AudioService.playTurkishPronunciation(
                              item.number,
                              readText,
                              assetPath: item.turkishPronunciationAudio,
                            );
                          },
                          icon: Icon(
                            isPlayingTrPron
                                ? Icons.stop_rounded
                                : Icons.record_voice_over_rounded,
                            size: 17,
                            color: isPlayingTrPron
                                ? Colors.redAccent
                                : deen.accentGold,
                          ),
                          label: Text(
                            isPlayingTrPron
                                ? l10n.stopAudio
                                : l10n.listenTurkishPronunciation,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isPlayingTrPron
                                  ? Colors.redAccent
                                  : deen.accentGold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: isPlayingTrPron
                                    ? Colors.redAccent
                                    : deen.accentGold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Non-Turkish Mode: Native Arabic & Multilingual Explanation Narration
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  AudioService.playNativeArabicName(
                                item.number,
                                arabicText: item.arabic,
                                assetPath: item.arabicNativeAudio,
                              ),
                              icon: Icon(
                                isPlayingAr
                                    ? Icons.stop_rounded
                                    : Icons.volume_up_rounded,
                                size: 17,
                                color: isPlayingAr
                                    ? Colors.redAccent
                                    : deen.accentPrimary,
                              ),
                              label: Text(
                                isPlayingAr
                                    ? l10n.stopAudio
                                    : l10n.listenArabic,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isPlayingAr
                                      ? Colors.redAccent
                                      : deen.accentPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isPlayingAr
                                      ? Colors.redAccent
                                      : deen.accentPrimary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  AudioService.playExplanationAudio(
                                number: item.number,
                                langCode: langCode,
                                explanationText: localizedExplanation,
                                assetPath: item.getExplanationAudio(
                                  langCode,
                                ),
                              ),
                              icon: Icon(
                                isPlayingExpl
                                    ? Icons.stop_rounded
                                    : Icons.auto_stories_rounded,
                                size: 17,
                                color: isPlayingExpl
                                    ? Colors.redAccent
                                    : deen.accentGold,
                              ),
                              label: Text(
                                isPlayingExpl
                                    ? l10n.stopAudio
                                    : l10n.listenExplanation,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isPlayingExpl
                                      ? Colors.redAccent
                                      : deen.accentGold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isPlayingExpl
                                      ? Colors.redAccent
                                      : deen.accentGold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 18),

                    // Meaning Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: deen.badgeBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.meaning,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: deen.accentGold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            localizedMeaning,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: deen.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Explanation Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: deen.surfaceSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: deen.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.explanation,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: deen.accentPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            localizedExplanation,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              height: 1.45,
                              color: deen.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Qur'an References Section
                    _buildQuranReferencesSection(item.number, langCode, deen),
                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: () {
                        AudioService.stop();
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deen.accentPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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

  Widget _buildQuranReferencesSection(
    int nameNumber,
    String langCode,
    DeenThemeTokens deen,
  ) {
    return FutureBuilder<List<AllahNameQuranReference>>(
      future: NamesOfAllahService.getReferencesForName(nameNumber),
      builder: (context, refSnapshot) {
        if (!refSnapshot.hasData || refSnapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final refs = refSnapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 16,
                  color: deen.accentGold,
                ),
                const SizedBox(width: 6),
                Text(
                  refs.length > 1
                      ? UiTranslationService.text('quranReferences', langCode)
                      : UiTranslationService.text('quranReference', langCode),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: deen.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...refs.map((ref) => _buildQuranReferenceCard(ref, langCode, deen)),
          ],
        );
      },
    );
  }

  Widget _buildQuranReferenceCard(
    AllahNameQuranReference ref,
    String langCode,
    DeenThemeTokens deen,
  ) {
    return FutureBuilder<AyahModel?>(
      future:
          QuranRepository.getAyah(ref.surah, ref.ayah, languageCode: langCode),
      builder: (context, snapshot) {
        final surahTitle = SurahLocalizationService.localizedName(
          ref.surah,
          langCode,
          'Surah ${ref.surah}',
        );

        final isRtlLanguage =
            langCode == 'ur' || langCode == 'ar' || langCode == 'fa';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: deen.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: deen.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Surah & Ayah reference badge
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: deen.badgeBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: deen.cardBorder),
                    ),
                    child: Text(
                      '$surahTitle ${ref.surah}:${ref.ayah}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: deen.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (snapshot.connectionState == ConnectionState.waiting)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: deen.accentPrimary,
                      ),
                    ),
                  ),
                )
              else if (snapshot.hasData && snapshot.data != null) ...[
                // Arabic Qur'an text (RTL)
                if (snapshot.data!.arabicText.isNotEmpty)
                  Text(
                    snapshot.data!.arabicText,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: deen.arabicPrimary,
                      height: 1.8,
                    ),
                  ),
                const SizedBox(height: 8),

                // Localized Translation in current app language
                if (snapshot.data!.translation.isNotEmpty &&
                    snapshot.data!.translation !=
                        'Translation temporarily unavailable.')
                  Text(
                    snapshot.data!.translation,
                    textDirection:
                        (snapshot.data!.isRtlTranslation || isRtlLanguage)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.45,
                      color: deen.textSecondary,
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Map<String, String>> _localizedSalahSteps(String lang) {
    const ar = [
      'الله أكبر',
      'الفاتحة وسورة',
      'سبحان ربي العظيم (٣×)',
      'سمع الله لمن حمده',
      'سبحان ربي الأعلى (٣×)',
      'رب اغفر لي',
      'التحيات لله والصلوات',
      'السلام عليكم ورحمة الله'
    ];
    const enTitles = [
      '1. Intention & Takbeer (Niyyah)',
      '2. Standing & Recitation (Qiyam)',
      '3. Bowing (Ruku)',
      '4. Standing from Ruku',
      '5. Prostration (Sujud)',
      '6. Sitting Between Sujuds',
      '7. Final Tashahhud & Salawat',
      '8. Concluding Tasleem'
    ];
    const enDesc = [
      'Make silent intention and raise hands to earlobes reciting Allahu Akbar.',
      'Place right hand over left upon chest, recite Surah Al-Fatiha and a passage.',
      'Bow with back flat, hands on knees, reciting Subhana Rabbiyal Azeem (3x).',
      'Stand upright and recite Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
      'Prostrate with forehead, nose, palms, knees and toes touching ground (3x).',
      'Sit briefly and supplicate Rabbi-ghfirli, then perform the 2nd Sujud.',
      'Sit in final rakaah, recite At-Tahiyyat, Durood Ibrahim, and Dua.',
      'Turn head right then left reciting Assalamu Alaykum wa Rahmatullah.'
    ];
    const titles = <String, List<String>>{
      'ar': [
        '١. النية والتكبير',
        '٢. القيام والقراءة',
        '٣. الركوع',
        '٤. الرفع من الركوع',
        '٥. السجود',
        '٦. الجلوس بين السجدتين',
        '٧. التشهد الأخير والصلاة على النبي',
        '٨. التسليم'
      ],
      'tr': [
        '1. Niyet ve Tekbir',
        '2. Kıyam ve Kıraat',
        '3. Rükû',
        '4. Rükûdan Doğrulma',
        '5. Secde',
        '6. İki Secde Arasında Oturuş',
        '7. Son Tahiyyat ve Salavat',
        '8. Selam ile Bitiriş'
      ],
      'de': [
        '1. Absicht & Takbir',
        '2. Stehen & Rezitation',
        '3. Verbeugung (Ruku)',
        '4. Aufrichten aus dem Ruku',
        '5. Niederwerfung (Sujud)',
        '6. Sitzen zwischen den Sujud',
        '7. Letzter Tashahhud & Salawat',
        '8. Abschließender Taslim'
      ],
      'fr': [
        '1. Intention et Takbir',
        '2. Station debout et récitation',
        '3. Inclinaison (Ruku)',
        '4. Redressement après le Ruku',
        '5. Prosternation (Sujud)',
        '6. Assise entre les prosternations',
        '7. Tashahhud final et Salawat',
        '8. Taslim final'
      ],
      'es': [
        '1. Intención y Takbir',
        '2. De pie y recitación',
        '3. Inclinación (Ruku)',
        '4. Levantarse del Ruku',
        '5. Postración (Sujud)',
        '6. Sentarse entre postraciones',
        '7. Tashahhud final y Salawat',
        '8. Taslim final'
      ],
      'pt': [
        '1. Intenção e Takbir',
        '2. Em pé e recitação',
        '3. Inclinação (Ruku)',
        '4. Erguer-se do Ruku',
        '5. Prostração (Sujud)',
        '6. Sentar entre prostrações',
        '7. Tashahhud final e Salawat',
        '8. Taslim final'
      ],
      'ru': [
        '1. Намерение и такбир',
        '2. Стояние и чтение',
        '3. Поясной поклон (руку)',
        '4. Выпрямление после руку',
        '5. Земной поклон (суджуд)',
        '6. Сидение между суджудами',
        '7. Последний ташаххуд и салават',
        '8. Завершающий таслим'
      ],
      'id': [
        '1. Niat & Takbir',
        '2. Berdiri & Bacaan',
        '3. Rukuk',
        '4. Bangkit dari Rukuk',
        '5. Sujud',
        '6. Duduk di Antara Dua Sujud',
        '7. Tasyahud Akhir & Salawat',
        '8. Salam Penutup'
      ],
      'ur': [
        '1. نیت اور تکبیر',
        '2. قیام اور قراءت',
        '3. رکوع',
        '4. رکوع سے اٹھنا',
        '5. سجدہ',
        '6. دو سجدوں کے درمیان بیٹھنا',
        '7. آخری تشہد اور درود',
        '8. سلام کے ساتھ اختتام'
      ],
      'ms': [
        '1. Niat & Takbir',
        '2. Berdiri & Bacaan',
        '3. Rukuk',
        '4. Bangun dari Rukuk',
        '5. Sujud',
        '6. Duduk Antara Dua Sujud',
        '7. Tasyahud Akhir & Selawat',
        '8. Salam Penutup'
      ],
    };
    const desc = <String, List<String>>{
      'ar': [
        'انوِ الصلاة في قلبك وارفع يديك وقل: الله أكبر.',
        'ضع اليد اليمنى فوق اليسرى على الصدر، واقرأ الفاتحة وما تيسر من القرآن.',
        'اركع وظهرك مستوٍ ويداك على ركبتيك وقل: سبحان ربي العظيم ثلاث مرات.',
        'ارفع من الركوع وقل: سمع الله لمن حمده، ربنا ولك الحمد.',
        'اسجد واضعًا الجبهة والأنف والكفين والركبتين وأطراف القدمين على الأرض.',
        'اجلس قليلًا وقل: رب اغفر لي، ثم اسجد السجدة الثانية.',
        'في الركعة الأخيرة اقرأ التشهد والصلاة الإبراهيمية والدعاء.',
        'التفت برأسك إلى اليمين ثم اليسار وقل: السلام عليكم ورحمة الله.'
      ],
      'tr': [
        'İçinizden niyet edin, ellerinizi kulak hizasına kaldırıp Allahu Ekber deyin.',
        'Sağ eli sol elin üzerine göğüste koyun; Fatiha ve bir sure/ayet okuyun.',
        'Sırt düz, eller dizlerde olacak şekilde rükûya eğilin ve 3 kez Subhane Rabbiyel Azim deyin.',
        'Doğrulun; Semi Allahu limen hamideh, Rabbena ve lekel hamd deyin.',
        'Alın, burun, avuçlar, dizler ve ayak parmakları yere değecek şekilde secde edin ve 3 kez tesbih edin.',
        'Kısa süre oturup Rabbiğfirli deyin, sonra ikinci secdeyi yapın.',
        'Son rekâtta oturun; Ettehiyyatü, Salli-Barik ve dua okuyun.',
        'Başınızı sağa sonra sola çevirerek Esselamu aleykum ve rahmetullah deyin.'
      ],
      'de': [
        'Fassen Sie still die Absicht, heben Sie die Hände zu den Ohren und sagen Sie Allahu Akbar.',
        'Legen Sie die rechte Hand über die linke auf die Brust und rezitieren Sie Al-Fatiha und einen weiteren Abschnitt.',
        'Beugen Sie sich mit geradem Rücken, Hände auf den Knien, und sprechen Sie dreimal Subhana Rabbiyal Azeem.',
        'Richten Sie sich auf und sprechen Sie Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Werfen Sie sich nieder, wobei Stirn, Nase, Handflächen, Knie und Zehen den Boden berühren.',
        'Setzen Sie sich kurz, sprechen Sie Rabbi-ghfirli und machen Sie den zweiten Sujud.',
        'Sitzen Sie in der letzten Rakaa und rezitieren Sie At-Tahiyyat, Salawat und Dua.',
        'Drehen Sie den Kopf nach rechts und links und sprechen Sie Assalamu Alaykum wa Rahmatullah.'
      ],
      'fr': [
        'Formez silencieusement l’intention, levez les mains aux oreilles et dites Allahu Akbar.',
        'Placez la main droite sur la gauche sur la poitrine, puis récitez Al-Fatiha et un passage.',
        'Inclinez-vous, dos droit et mains sur les genoux, en récitant Subhana Rabbiyal Azeem trois fois.',
        'Redressez-vous et récitez Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Prosternez-vous avec le front, le nez, les paumes, les genoux et les orteils au sol.',
        'Asseyez-vous brièvement, dites Rabbi-ghfirli, puis effectuez le deuxième Sujud.',
        'Lors de la dernière rakaah, récitez At-Tahiyyat, les Salawat et une invocation.',
        'Tournez la tête à droite puis à gauche en disant Assalamu Alaykum wa Rahmatullah.'
      ],
      'es': [
        'Haga la intención en silencio, levante las manos a la altura de las orejas y diga Allahu Akbar.',
        'Coloque la mano derecha sobre la izquierda en el pecho y recite Al-Fatiha y otro pasaje.',
        'Inclínese con la espalda recta y las manos en las rodillas, diciendo Subhana Rabbiyal Azeem tres veces.',
        'Levántese y recite Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Póstrese con frente, nariz, palmas, rodillas y dedos de los pies tocando el suelo.',
        'Siéntese brevemente, diga Rabbi-ghfirli y haga el segundo Sujud.',
        'En la última rakaah, recite At-Tahiyyat, Salawat y una súplica.',
        'Gire la cabeza a la derecha y luego a la izquierda diciendo Assalamu Alaykum wa Rahmatullah.'
      ],
      'pt': [
        'Faça a intenção em silêncio, levante as mãos à altura das orelhas e diga Allahu Akbar.',
        'Coloque a mão direita sobre a esquerda no peito e recite Al-Fatiha e outra passagem.',
        'Incline-se com as costas retas e mãos nos joelhos, dizendo Subhana Rabbiyal Azeem três vezes.',
        'Erga-se e recite Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Prostre-se com testa, nariz, palmas, joelhos e dedos dos pés no chão.',
        'Sente-se brevemente, diga Rabbi-ghfirli e faça o segundo Sujud.',
        'Na última rakaah, recite At-Tahiyyat, Salawat e uma súplica.',
        'Vire a cabeça à direita e depois à esquerda dizendo Assalamu Alaykum wa Rahmatullah.'
      ],
      'ru': [
        'Молча сделайте намерение, поднимите руки к ушам и произнесите «Аллаху Акбар».',
        'Положите правую руку на левую на груди, прочитайте Аль-Фатиху и другой отрывок.',
        'Совершите поясной поклон с прямой спиной и руками на коленях, трижды произнеся тасбих.',
        'Выпрямитесь и произнесите Сами Аллаху лиман хамидах, Раббана ва лакаль хамд.',
        'Совершите суджуд, касаясь пола лбом, носом, ладонями, коленями и пальцами ног.',
        'Ненадолго сядьте, произнесите Рабби-гфирли, затем совершите второй суджуд.',
        'В последнем ракаате прочитайте Ат-Тахият, салават и дуа.',
        'Поверните голову вправо, затем влево, произнося салям.'
      ],
      'id': [
        'Niat dalam hati, angkat tangan sejajar telinga dan ucapkan Allahu Akbar.',
        'Letakkan tangan kanan di atas tangan kiri di dada, baca Al-Fatihah dan ayat/surah lain.',
        'Rukuk dengan punggung rata, tangan di lutut, baca Subhana Rabbiyal Azeem tiga kali.',
        'Bangkit dan baca Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Sujud dengan dahi, hidung, telapak tangan, lutut, dan jari kaki menyentuh lantai.',
        'Duduk sebentar, baca Rabbi-ghfirli, lalu lakukan sujud kedua.',
        'Pada rakaat terakhir, baca At-Tahiyyat, salawat, dan doa.',
        'Putar kepala ke kanan lalu kiri sambil mengucapkan Assalamu Alaykum wa Rahmatullah.'
      ],
      'ur': [
        'دل میں نیت کریں، ہاتھ کانوں تک اٹھا کر اللہ اکبر کہیں۔',
        'دائیں ہاتھ کو بائیں پر سینے پر رکھیں، سورۃ الفاتحہ اور قرآن کا ایک حصہ پڑھیں۔',
        'کمر سیدھی رکھتے ہوئے رکوع کریں، ہاتھ گھٹنوں پر رکھیں اور تین بار تسبیح پڑھیں۔',
        'سیدھے کھڑے ہو کر سمع اللہ لمن حمدہ، ربنا ولک الحمد پڑھیں۔',
        'پیشانی، ناک، ہتھیلیاں، گھٹنے اور پاؤں کی انگلیاں زمین پر رکھ کر سجدہ کریں۔',
        'مختصر بیٹھ کر رب اغفر لی پڑھیں، پھر دوسرا سجدہ کریں۔',
        'آخری رکعت میں التحیات، درود اور دعا پڑھیں۔',
        'سر پہلے دائیں پھر بائیں موڑ کر السلام علیکم ورحمۃ اللہ کہیں۔'
      ],
      'ms': [
        'Niat dalam hati, angkat tangan ke paras telinga dan ucap Allahu Akbar.',
        'Letakkan tangan kanan di atas tangan kiri di dada, baca Al-Fatihah dan ayat/surah lain.',
        'Rukuk dengan belakang rata, tangan di lutut, baca Subhana Rabbiyal Azeem tiga kali.',
        'Bangun dan baca Sami Allahu Liman Hamidah, Rabbana wa Lakal Hamd.',
        'Sujud dengan dahi, hidung, tapak tangan, lutut dan jari kaki menyentuh lantai.',
        'Duduk sebentar, baca Rabbi-ghfirli, kemudian lakukan sujud kedua.',
        'Pada rakaat terakhir, baca At-Tahiyyat, selawat dan doa.',
        'Pusing kepala ke kanan kemudian kiri sambil mengucap Assalamu Alaykum wa Rahmatullah.'
      ],
    };
    final t = titles[lang] ?? enTitles;
    final d = desc[lang] ?? enDesc;
    return List.generate(
        8, (i) => {'title': t[i], 'arabic': ar[i], 'desc': d[i]});
  }

  List<Map<String, String>> _localizedWuduSteps(String lang) {
    const ar = [
      'بِسْمِ اللَّهِ',
      'غَسْلُ الْيَدَيْنِ',
      'الْمَضْمَضَةُ',
      'الِاسْتِنْشَاقُ',
      'غَسْلُ الْوَجْهِ',
      'غَسْلُ الْيَدَيْنِ إِلَى الْمِرْفَقَيْنِ',
      'مَسْحُ الرَّأْسِ',
      'مَسْحُ الأُذُنَيْنِ',
      'غَسْلُ الرِّجْلَيْنِ إِلَى الْكَعْبَيْنِ'
    ];
    const enTitles = [
      '1. Intention & Bismillah',
      '2. Washing Hands',
      '3. Rinsing Mouth',
      '4. Inhaling Water in Nose',
      '5. Washing Face',
      '6. Washing Arms to Elbows',
      '7. Wiping Head (Masah)',
      '8. Wiping Ears',
      '9. Washing Feet to Ankles',
    ];
    const enDesc = [
      'Make intention in your heart to perform wudu and say Bismillah.',
      'Wash both hands thoroughly up to the wrists 3 times.',
      'Rinse the mouth with water 3 times using the right hand.',
      'Inhale water gently into the nostrils and blow out 3 times.',
      'Wash the entire face from hairline to chin and ear to ear 3 times.',
      'Wash the right arm including the elbow 3 times, then the left arm 3 times.',
      'Wipe over the whole head once with wet hands from front to back.',
      'Wipe the inside and outside of both ears once with wet fingers.',
      'Wash the right foot including ankles 3 times, then the left foot 3 times.',
    ];
    const titles = <String, List<String>>{
      'ar': [
        '١. النية والتسمية',
        '٢. غسل اليدين',
        '٣. المضمضة',
        '٤. الاستنشاق والاستنثار',
        '٥. غسل الوجه',
        '٦. غسل اليدين إلى المرفقين',
        '٧. مسح الرأس',
        '٨. مسح الأذنين',
        '٩. غسل الرجلين إلى الكعبين'
      ],
      'tr': [
        '1. Niyet ve Besmele',
        '2. Elleri Yıkamak',
        '3. Ağza Su Vermek (Mazmaza)',
        '4. Burna Su Vermek (İstinsak)',
        '5. Yüzü Yıkamak',
        '6. Kolları Dirseklerle Yıkamak',
        '7. Başı Meshetmek',
        '8. Kulakları Meshetmek',
        '9. Ayakları Topuklarla Yıkamak'
      ],
      'de': [
        '1. Absicht & Bismillah',
        '2. Hände waschen',
        '3. Mund ausspülen',
        '4. Nase spülen',
        '5. Gesicht waschen',
        '6. Arme bis zu den Ellbogen',
        '7. Über den Kopf streichen',
        '8. Ohren auswischen',
        '9. Füße bis zu den Knöcheln'
      ],
      'fr': [
        '1. Intention et Bismillah',
        '2. Lavage des mains',
        '3. Rinçage de la bouche',
        '4. Rinçage du nez',
        '5. Lavage du visage',
        '6. Lavage des bras aux coudes',
        '7. Essuyage de la tête',
        '8. Essuyage des oreilles',
        '9. Lavage des pieds aux chevilles'
      ],
      'es': [
        '1. Intención y Bismillah',
        '2. Lavarse las manos',
        '3. Enjuagarse la boca',
        '4. Enjuagarse la nariz',
        '5. Lavarse la cara',
        '6. Brazos hasta los codos',
        '7. Pasar manos por la cabeza',
        '8. Limpiarse las orejas',
        '9. Pies hasta los tobillos'
      ],
      'pt': [
        '1. Intenção e Bismillah',
        '2. Lavar as mãos',
        '3. Enxaguar a boca',
        '4. Lavar as narinas',
        '5. Lavar o rosto',
        '6. Braços até os cotovelos',
        '7. Passar mãos na cabeça',
        '8. Limpar as orelhas',
        '9. Pés até os tornozelos'
      ],
      'ru': [
        '1. Намерение и Бисмиллях',
        '2. Мытье кистей рук',
        '3. Полоскание рта',
        '4. Промывание носа',
        '5. Умывание лица',
        '6. Мытье рук до локтей',
        '7. Протирание головы (масх)',
        '8. Протирание ушей',
        '9. Мытье ног до щиколоток'
      ],
      'id': [
        '1. Niat & Bismillah',
        '2. Membasuh Tangan',
        '3. Berkumur',
        '4. Membasuh Hidung',
        '5. Membasuh Wajah',
        '6. Membasuh Tangan hingga Siku',
        '7. Mengusap Kepala',
        '8. Mengusap Telinga',
        '9. Membasuh Kaki hingga Mata Kaki'
      ],
      'ur': [
        '1. نیت اور بسم اللہ',
        '2. ہاتھ دھونا',
        '3. کلی کرنا',
        '4. ناک میں پانی ڈالنا',
        '5. چہرہ دھونا',
        '6. کہنیوں تک ہاتھ دھونا',
        '7. سر کا مسح کرنا',
        '8. کانوں کا مسح کرنا',
        '9. ٹخنوں سمیت پاؤں دھونا'
      ],
      'ms': [
        '1. Niat & Bismillah',
        '2. Membasuh Tangan',
        '3. Berkumur',
        '4. Membasuh Hidung',
        '5. Membasuh Muka',
        '6. Membasuh Tangan ke Siku',
        '7. Menyapu Kepala',
        '8. Menyapu Telinga',
        '9. Membasuh Kaki ke Buku Lali'
      ],
    };
    const desc = <String, List<String>>{
      'ar': [
        'انوِ الوضوء في قلبك وقل: بسم الله.',
        'اغسل كفيك إلى الرسغين ثلاث مرات جيدًا.',
        'تمضمض بالماء ثلاث مرات بيدك اليمنى.',
        'استنشق الماء بأنفك برفق ثم انثره ثلاث مرات.',
        'اغسل كامل الوجه من منابت الشعر إلى الذقن ثلاث مرات.',
        'اغسل يدك اليمنى إلى المرفق ثلاث مرات، ثم اليسرى ثلاث مرات.',
        'امسح رأسك بيدين مبللتين مرة واحدة من الأمام إلى الخلف.',
        'امسح باطن الأذنين وظاهرهما مرة واحدة.',
        'اغسل رجلك اليمنى مع الكعبين ثلاث مرات، ثم اليسرى ثلاث مرات.'
      ],
      'tr': [
        'Kalpten abdest almaya niyet edin ve "Bismillah" deyin.',
        'Her iki eli bileklere kadar 3 kez güzelce yıkayın.',
        'Sağ elinizle ağzınıza 3 kez su verip çalkalayın.',
        'Burna sağ elle 3 kez su çekip sol elle temizleyin.',
        'Saç bitiminden çene altına kadar yüzün tamamını 3 kez yıkayın.',
        'Önce sağ kolu dirsekle beraber 3 kez, sonra sol kolu 3 kez yıkayın.',
        'Islak elle başın tamamını veya dörtte birini bir kez meshedin.',
        'Parmaklarınızla kulakların içini ve arkasını bir kez meshedin.',
        'Önce sağ ayağı topuklarla beraber 3 kez, sonra sol ayağı 3 kez yıkayın.'
      ],
      'de': [
        'Fassen Sie die Absicht im Herzen und sagen Sie „Bismillah“.',
        'Waschen Sie beide Hände bis zu den Handgelenken dreimal gründlich.',
        'Spülen Sie den Mund dreimal mit der rechten Hand aus.',
        'Ziehen Sie sanft Wasser in die Nase und schnäuzen Sie es dreimal aus.',
        'Waschen Sie das gesamte Gesicht vom Haaransatz bis zum Kinn dreimal.',
        'Waschen Sie den rechten Arm bis zum Ellbogen dreimal, dann den linken dreimal.',
        'Streichen Sie einmal mit feuchten Händen über den Kopf.',
        'Wischen Sie die Ohren innen und außen einmal ab.',
        'Waschen Sie den rechten Fuß samt Knöcheln dreimal, dann den linken dreimal.'
      ],
      'fr': [
        'Formez l’intention dans votre cœur et dites « Bismillah ».',
        'Lavez soigneusement les deux mains jusqu’aux poignets 3 fois.',
        'Rincez-vous la bouche 3 fois avec la main droite.',
        'Aspirez doucement de l’eau par le nez et rejetez-la 3 fois.',
        'Lavez tout le visage de la racine des cheveux au menton 3 fois.',
        'Lavez le bras droit jusqu’au coude 3 fois, puis le gauche 3 fois.',
        'Passez les mains mouillées sur l’ensemble de la tête une fois.',
        'Essuyez l’intérieur et l’extérieur des deux oreilles une fois.',
        'Lavez le pied droit avec les chevilles 3 fois, puis le gauche 3 fois.'
      ],
      'es': [
        'Haga la intención en el corazón y diga «Bismillah».',
        'Lave ambas manos hasta las muñecas 3 veces cuidadosamente.',
        'Enjuáguese la boca 3 veces con la mano derecha.',
        'Aspire suavemente agua por la nariz y expúlsela 3 veces.',
        'Lave todo el rostro desde el nacimiento del cabello hasta la barbilla 3 veces.',
        'Lave el brazo derecho hasta el codo 3 veces, luego el izquierdo 3 veces.',
        'Pase las manos húmedas sobre la cabeza una vez.',
        'Limpie el interior y el exterior de las orejas una vez.',
        'Lave el pie derecho incluyendo los tobillos 3 veces, luego el izquierdo 3 veces.'
      ],
      'pt': [
        'Faça a intenção no coração e diga «Bismillah».',
        'Lave bem as duas mãos até os pulsos 3 vezes.',
        'Enxágue a boca 3 vezes com a mão direita.',
        'Aspire suavemente água pelo nariz e assoe 3 vezes.',
        'Lave todo o rosto, da linha do cabelo até o queixo, 3 vezes.',
        'Lave o braço direito até o cotovelo 3 vezes, depois o esquerdo 3 vezes.',
        'Passe as mãos molhadas sobre a cabeça uma vez.',
        'Limpe o interior e o exterior das orelhas uma vez.',
        'Lave o pé direito incluindo os tornozelos 3 vezes, depois o esquerdo 3 vezes.'
      ],
      'ru': [
        'Сделайте намерение в сердце и скажите «Бисмиллях».',
        'Тщательно вымойте обе кисти рук до запястий 3 раза.',
        'Прополощите рот 3 раза правой рукой.',
        'Втяните воду носом и осторожно высморкайтесь 3 раза.',
        'Вымойте лицо полностью от линии волос до подбородка 3 раза.',
        'Вымойте правую руку до локтя 3 раза, затем левую 3 раза.',
        'Протрите влажными руками голову один раз.',
        'Протрите уши внутри и снаружи один раз.',
        'Вымойте правую ногу со щиколоткой 3 раза, затем левую 3 раза.'
      ],
      'id': [
        'Niatkan wudhu di dalam hati dan ucapkan "Bismillah".',
        'Basuh kedua tangan hingga pergelangan 3 kali dengan bersih.',
        'Berkumurlah 3 kali menggunakan tangan kanan.',
        'Hirup air ke dalam hidung lalu keluarkan 3 kali.',
        'Basuh seluruh wajah dari batas tumbuhnya rambut hingga dagu 3 kali.',
        'Basuh tangan kanan sampai siku 3 kali, lalu tangan kiri 3 kali.',
        'Usaplah kepala dengan tangan yang basah satu kali.',
        'Usap bagian dalam dan luar kedua telinga satu kali.',
        'Basuh kaki kanan termasuk mata kaki 3 kali, lalu kaki kiri 3 kali.'
      ],
      'ur': [
        'دل میں وضو کی نیت کریں اور "بسم اللہ" پڑھیں۔',
        'دونوں ہاتھوں کو کلائیوں تک تین بار اچھی طرح دھوئیں',
        'دائیں ہاتھ سے تین بار منہ میں پانی ڈال کر کلی کریں۔',
        'ناک میں تین بار پانی چڑھا کر صاف کریں۔',
        'پیشانی کے بالوں سے ٹھوڑی تک پورا چہرہ تین بار دھوئیں',
        'پہلے دایاں ہاتھ کہنی سمیت تین بار، پھر بایاں ہاتھ تین بار دھوئیں',
        'تر ہاتھوں سے ایک بار سر کا مسح کریں۔',
        'انگلیوں سے دونوں کانوں کا مسح کریں۔',
        'پہلے دایاں پاؤں ٹخنوں سمیت تین بار، پھر بایاں پاؤں تین بار دھوئیں'
      ],
      'ms': [
        'Niatkan wuduk di dalam hati dan ucapkan "Bismillah".',
        'Basuh kedua-dua belah tangan hingga ke pergelangan 3 kali.',
        'Berkumur sebanyak 3 kali menggunakan tangan kanan.',
        'Sedut air ke dalam hidung dan hembuskan sebanyak 3 kali.',
        'Basuh seluruh muka dari anak rambut hingga ke dagu 3 kali.',
        'Basuh tangan kanan hingga ke siku 3 kali, kemudian tangan kiri 3 kali.',
        'Sapukan kepala dengan tangan yang basah 1 kali.',
        'Sapukan bahagian dalam dan luar telinga 1 kali.',
        'Basuh kaki kanan termasuk buku lali 3 kali, kemudian kaki kiri 3 kali.'
      ],
    };
    final t = titles[lang] ?? enTitles;
    final d = desc[lang] ?? enDesc;
    return List.generate(
        9, (i) => {'title': t[i], 'arabic': ar[i], 'desc': d[i]});
  }

  Widget _buildSalahGuideTab(double bottomInset, DeenThemeTokens deen) {
    final langCode = Localizations.localeOf(context).languageCode;
    final steps = _guideMode == 'salah'
        ? _localizedSalahSteps(langCode)
        : _localizedWuduSteps(langCode);

    return ListView(
      padding: EdgeInsets.only(
        left: AppSpacing.screenMargin,
        right: AppSpacing.screenMargin,
        top: 14,
        bottom: bottomInset + 32,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'salah',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child:
                      Text(UiTranslationService.text('salahGuide', langCode)),
                ),
              ),
              ButtonSegment(
                value: 'wudu',
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(UiTranslationService.text('wuduGuide', langCode)),
                ),
              ),
            ],
            selected: {_guideMode},
            onSelectionChanged: (value) =>
                setState(() => _guideMode = value.first),
            showSelectedIcon: false,
          ),
        ),
        for (final step in steps)
          DeenCard(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        step['title']!,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      step['arabic']!,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: deen.arabicPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  step['desc']!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: deen.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
