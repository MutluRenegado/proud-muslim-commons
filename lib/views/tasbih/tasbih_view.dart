import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../providers/tasbih_provider.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

class TasbihView extends StatelessWidget {
  const TasbihView({super.key});

  @override
  Widget build(BuildContext context) {
    final tasbihProv = Provider.of<TasbihProvider>(context);
    final preset = tasbihProv.currentPreset;
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          '${l10n.digitalTasbih} (السبحة)',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpTasbihTitle,
            description: l10n.helpTasbihDesc,
          ),
          IconButton(
            icon: Icon(
              tasbihProv.vibrateOnCount
                  ? Icons.vibration_rounded
                  : Icons.smartphone_rounded,
              color:
                  tasbihProv.vibrateOnCount ? deen.accentGold : deen.textMuted,
            ),
            tooltip: l10n.toggleVibration,
            onPressed: () => tasbihProv.toggleVibration(),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: deen.accentPrimary),
            tooltip: l10n.resetCounter,
            onPressed: () => _confirmReset(context, tasbihProv, l10n, deen),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14,
          bottom: bottomInset + 32,
        ),
        child: Column(
          children: [
            // Presets Horizontal Selector
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: TasbihProvider.defaultPresets.length,
                itemBuilder: (context, idx) {
                  final p = TasbihProvider.defaultPresets[idx];
                  final isSelected = tasbihProv.selectedPresetIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(p.transliteration),
                      selected: isSelected,
                      selectedColor: deen.accentPrimary,
                      backgroundColor: deen.cardBackground,
                      side: BorderSide(
                        color:
                            isSelected ? deen.accentPrimary : deen.cardBorder,
                      ),
                      labelStyle: GoogleFonts.plusJakartaSans(
                        color: isSelected ? Colors.white : deen.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (_) => tasbihProv.selectPreset(idx),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Active Dhikr Display Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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
                    preset.arabic,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: deen.accentGoldBright,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    preset.transliteration,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${_localizedPresetMeaning(preset.id, langCode, preset.meaning)}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Big Tap Button / Luminous Bead Circle
            GestureDetector(
              onTap: () => tasbihProv.increment(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [deen.accentSecondary, deen.accentPrimary],
                  ),
                  border: Border.all(color: deen.accentGold, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: deen.accentPrimary.withOpacity(0.45),
                      blurRadius: 28,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${tasbihProv.currentCount}',
                      style: GoogleFonts.outfit(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${UiTranslationService.text('target', langCode)}: ${tasbihProv.targetCount}",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: deen.accentGoldBright,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Target Quick Adjust Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [33, 99, 100, 1000].map((t) {
                final isSelected = tasbihProv.targetCount == t;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                    onPressed: () => tasbihProv.setTarget(t),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isSelected ? deen.accentGold : deen.cardBackground,
                      foregroundColor:
                          isSelected ? Colors.black : deen.textPrimary,
                      side: BorderSide(
                        color: isSelected ? deen.accentGold : deen.cardBorder,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      '$t',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Dhikr inspiration changes automatically after every 10 counts.
            _buildDhikrVerse(
              deen,
              _dhikrVerses[tasbihProv.inspirationIndex],
              tasbihProv.currentCount,
              langCode,
            ),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, String>> _dhikrVerses = [
    {
      'arabic': 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      'meaning': 'Remember Me; I will remember you.',
      'reference': 'Quran 2:152',
    },
    {
      'arabic': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      'meaning': 'Surely, hearts find comfort in the remembrance of Allah.',
      'reference': 'Quran 13:28',
    },
    {
      'arabic': 'وَاذْكُر رَّبَّكَ كَثِيرًا',
      'meaning': 'Remember your Lord often.',
      'reference': 'Quran 3:41',
    },
    {
      'arabic': 'وَاذْكُرِ اسْمَ رَبِّكَ بُكْرَةً وَأَصِيلًا',
      'meaning': 'Remember the Name of your Lord morning and evening.',
      'reference': 'Quran 76:25',
    },
    {
      'arabic': 'وَالذَّاكِرِينَ اللَّهَ كَثِيرًا وَالذَّاكِرَاتِ',
      'meaning':
          'For men and women who remember Allah often, He has prepared forgiveness and a great reward.',
      'reference': 'Quran 33:35',
    },
    {
      'arabic':
          'يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا اللَّهَ ذِكْرًا كَثِيرًا',
      'meaning': 'Believers, remember Allah with much remembrance.',
      'reference': 'Quran 33:41',
    },
  ];

  String _localizedDhikrMeaning(
      String reference, String langCode, String fallback) {
    const values = <String, Map<String, String>>{
      'Quran 2:152': {
        'tr': 'Beni anın ki Ben de sizi anayım.',
        'de': 'Gedenkt Meiner, so gedenke Ich eurer.',
        'fr': 'Souvenez-vous de Moi, Je Me souviendrai de vous.',
        'es': 'Recordadme y Yo os recordaré.',
        'pt': 'Lembrai-vos de Mim e Eu Me lembrarei de vós.',
        'ru': 'Поминайте Меня, и Я буду помнить о вас.',
        'id': 'Ingatlah Aku, niscaya Aku mengingatmu.',
        'ur': 'تم مجھے یاد کرو، میں تمہیں یاد کروں گا۔',
        'ms': 'Ingatlah Aku, nescaya Aku mengingati kamu.'
      },
      'Quran 13:28': {
        'tr': 'Kalpler ancak Allah’ı anmakla huzur bulur.',
        'de': 'Im Gedenken Allahs finden die Herzen Ruhe.',
        'fr': 'C’est par l’évocation d’Allah que les cœurs se tranquillisent.',
        'es': 'Los corazones encuentran sosiego en el recuerdo de Allah.',
        'pt': 'Os corações encontram tranquilidade na lembrança de Allah.',
        'ru': 'Поистине, поминанием Аллаха успокаиваются сердца.',
        'id': 'Ingatlah, dengan mengingat Allah hati menjadi tenteram.',
        'ur': 'خبردار! اللہ کے ذکر سے دلوں کو اطمینان ملتا ہے۔',
        'ms': 'Sesungguhnya dengan mengingati Allah hati menjadi tenteram.'
      },
      'Quran 3:41': {
        'tr': 'Rabbini çokça zikret.',
        'de': 'Gedenke deines Herrn viel.',
        'fr': 'Invoque beaucoup ton Seigneur.',
        'es': 'Recuerda mucho a tu Señor.',
        'pt': 'Recorda muito o teu Senhor.',
        'ru': 'Много поминай своего Господа.',
        'id': 'Ingatlah Tuhanmu sebanyak-banyaknya.',
        'ur': 'اپنے رب کو بہت یاد کرو۔',
        'ms': 'Ingatlah Tuhanmu sebanyak-banyaknya.'
      },
      'Quran 76:25': {
        'tr': 'Sabah akşam Rabbinin adını an.',
        'de': 'Gedenke morgens und abends des Namens deines Herrn.',
        'fr': 'Invoque le nom de ton Seigneur matin et soir.',
        'es': 'Recuerda el nombre de tu Señor mañana y tarde.',
        'pt': 'Recorda o nome do teu Senhor de manhã e à tarde.',
        'ru': 'Поминай имя своего Господа утром и вечером.',
        'id': 'Sebutlah nama Tuhanmu pada pagi dan petang.',
        'ur': 'صبح و شام اپنے رب کا نام یاد کرو۔',
        'ms': 'Sebutlah nama Tuhanmu pada waktu pagi dan petang.'
      },
      'Quran 33:35': {
        'tr':
            'Allah’ı çokça anan erkekler ve kadınlar için Allah bağışlanma ve büyük bir ödül hazırlamıştır.',
        'de':
            'Für Männer und Frauen, die Allah häufig gedenken, hat Er Vergebung und großen Lohn bereitet.',
        'fr':
            'Pour les hommes et les femmes qui évoquent souvent Allah, Il a préparé pardon et immense récompense.',
        'es':
            'Para los hombres y mujeres que recuerdan mucho a Allah, Él ha preparado perdón y una gran recompensa.',
        'pt':
            'Para homens e mulheres que muito recordam Allah, Ele preparou perdão e grande recompensa.',
        'ru':
            'Мужчинам и женщинам, часто поминающим Аллаха, Он приготовил прощение и великую награду.',
        'id':
            'Bagi lelaki dan perempuan yang banyak mengingat Allah, Dia menyediakan ampunan dan pahala besar.',
        'ur':
            'اللہ کو کثرت سے یاد کرنے والے مردوں اور عورتوں کے لیے اس نے مغفرت اور بڑا اجر تیار کیا ہے۔',
        'ms':
            'Bagi lelaki dan wanita yang banyak mengingati Allah, Dia menyediakan keampunan dan pahala yang besar.'
      },
      'Quran 33:41': {
        'tr': 'Ey iman edenler! Allah’ı çokça zikredin.',
        'de': 'Ihr Gläubigen, gedenkt Allahs in häufigem Gedenken.',
        'fr': 'Ô croyants, évoquez Allah abondamment.',
        'es': 'Creyentes, recordad mucho a Allah.',
        'pt': 'Ó crentes, recordai Allah abundantemente.',
        'ru': 'Верующие, поминайте Аллаха многократно.',
        'id': 'Wahai orang beriman, ingatlah Allah sebanyak-banyaknya.',
        'ur': 'اے ایمان والو! اللہ کو کثرت سے یاد کرو۔',
        'ms': 'Wahai orang beriman, ingatlah Allah sebanyak-banyaknya.'
      },
    };
    return values[reference]?[langCode] ?? fallback;
  }

  String _localizedPresetMeaning(String id, String langCode, String fallback) {
    const values = <String, Map<String, String>>{
      'subhanallah': {
        'tr': 'Allah her türlü eksiklikten münezzehtir.',
        'de': 'Gepriesen sei Allah.',
        'fr': 'Gloire à Allah.',
        'es': 'Gloria a Allah.',
        'pt': 'Glória a Allah.',
        'ru': 'Пречист Аллах.',
        'id': 'Maha Suci Allah.',
        'ur': 'اللہ ہر عیب سے پاک ہے۔',
        'ms': 'Maha Suci Allah.',
      },
      'alhamdulillah': {
        'tr': 'Hamd Allah\'a mahsustur.',
        'de': 'Alles Lob gebührt Allah.',
        'fr': 'Louange à Allah.',
        'es': 'Alabado sea Allah.',
        'pt': 'Louvado seja Allah.',
        'ru': 'Хвала Аллаху.',
        'id': 'Segala puji bagi Allah.',
        'ur': 'تمام تعریفیں اللہ کے لیے ہیں۔',
        'ms': 'Segala puji bagi Allah.',
      },
      'allahuakbar': {
        'tr': 'Allah en büyüktür.',
        'de': 'Allah ist der Größte.',
        'fr': 'Allah est le Plus Grand.',
        'es': 'Allah es el Más Grande.',
        'pt': 'Allah é o Maior.',
        'ru': 'Аллах Велик.',
        'id': 'Allah Maha Besar.',
        'ur': 'اللہ سب سے بڑا ہے۔',
        'ms': 'Allah Maha Besar.',
      },
      'astaghfirullah': {
        'tr': 'Allah\'tan bağışlanma dilerim.',
        'de': 'Ich bitte Allah um Vergebung.',
        'fr': 'Je demande pardon à Allah.',
        'es': 'Pido perdón a Allah.',
        'pt': 'Peço perdão a Allah.',
        'ru': 'Я прошу прощения у Аллаха.',
        'id': 'Aku memohon ampun kepada Allah.',
        'ur': 'میں اللہ سے بخشش مانگتا ہوں۔',
        'ms': 'Aku memohon ampun kepada Allah.',
      },
      'lailahaillallah': {
        'tr': 'Allah\'tan başka ilah yoktur.',
        'de': 'Es gibt keinen Gott außer Allah.',
        'fr': 'Il n\'y a de divinité digne d\'adoration qu\'Allah.',
        'es': 'No hay más dios que Allah.',
        'pt': 'Não há divindade exceto Allah.',
        'ru': 'Нет божества, кроме Аллаха.',
        'id': 'Tidak ada Tuhan selain Allah.',
        'ur': 'اللہ کے سوا کوئی معبود نہیں ہے۔',
        'ms': 'Tiada Tuhan selain Allah.',
      },
      'salawat': {
        'tr': 'Allah\'ım, Muhammed\'e salat ve selam eyle.',
        'de': 'O Allah, segne Muhammad.',
        'fr': 'Ô Allah, répands Tes bénédictions sur Muhammad.',
        'es': 'Oh Allah, bendice a Muhammad.',
        'pt': 'Ó Allah, abençoa Muhammad.',
        'ru': 'О Аллах, благослови Мухаммада.',
        'id': 'Ya Allah, limpahkanlah rahmat kepada Muhammad.',
        'ur': 'اے اللہ! محمد (ﷺ) پر رحمت نازل فرما۔',
        'ms': 'Ya Allah, limpahkanlah rahmat ke atas Muhammad.',
      },
    };
    return values[id]?[langCode] ?? fallback;
  }

  Widget _buildDhikrVerse(
    DeenThemeTokens deen,
    Map<String, String> verse,
    int count,
    String langCode,
  ) {
    final nextChange = ((count ~/ 10) + 1) * 10;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Container(
        key: ValueKey(verse['reference']),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: deen.cardGlowGradient,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: deen.cardBorder),
          boxShadow: [
            BoxShadow(
              color: deen.cardShadow,
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_rounded, color: deen.accentGold, size: 20),
            const SizedBox(height: 8),
            Text(
              verse['arabic']!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: deen.arabicPrimary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _localizedDhikrMeaning(
                  verse['reference']!, langCode, verse['meaning']!),
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: deen.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${verse['reference']} • ${UiTranslationService.text('nextReflection', langCode, params: {
                    'count': '$nextChange'
                  })}",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: deen.accentPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(
    BuildContext context,
    TasbihProvider tasbihProv,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final langCode = Localizations.localeOf(context).languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.surfacePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          UiTranslationService.text('resetCounter', langCode),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: deen.textPrimary,
          ),
        ),
        content: Text(
          UiTranslationService.text('resetConfirm', langCode),
          style: GoogleFonts.plusJakartaSans(color: deen.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              UiTranslationService.text('cancel', langCode),
              style: GoogleFonts.plusJakartaSans(color: deen.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              tasbihProv.reset();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deen.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              UiTranslationService.text('resetCounter', langCode),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
