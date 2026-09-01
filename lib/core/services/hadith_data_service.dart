// hadith_data_service.dart
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/hadith_model.dart';

class HadithDataService {
  static List<HadithModel>? _cachedHadiths;

  static Future<List<HadithModel>> loadNawawiHadiths() async {
    if (_cachedHadiths != null) return _cachedHadiths!;
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/hadith_nawawi.json',
      );
      final list = jsonDecode(jsonStr) as List<dynamic>;
      Map<int, Map<String, dynamic>> additionalTranslations = {};
      try {
        final additionalJson = await rootBundle.loadString(
          'assets/data/hadith_nawawi_additional_translations.json',
        );
        final decoded = jsonDecode(additionalJson) as Map<String, dynamic>;
        additionalTranslations = decoded.map(
          (key, value) => MapEntry(
            int.parse(key),
            Map<String, dynamic>.from(value as Map),
          ),
        );
      } catch (_) {
        additionalTranslations = {};
      }
      _cachedHadiths = list
          .map((e) => HadithModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (_cachedHadiths!.length < 40) {
        _cachedHadiths!.addAll(
          _additionalHadiths.where((entry) => (entry[0] as int) <= 40).map(
                (entry) => HadithModel(
                  id: entry[0] as int,
                  title: entry[1] as String,
                  arabic: entry[2] as String,
                  translation: entry[3] as String,
                  narrator: entry[4] as String,
                  source: entry[5] as String,
                  explanation: entry[6] as String,
                  translations: additionalTranslations[entry[0] as int],
                ),
              ),
        );
      }
      _cachedHadiths!.sort((a, b) => a.id.compareTo(b.id));
      return _cachedHadiths!;
    } catch (e) {
      return [];
    }
  }

  static Future<HadithModel> getDailyHadith() async {
    final list = await loadNawawiHadiths();
    if (list.isEmpty) {
      return HadithModel(
        id: 1,
        title: "Actions are by Intentions",
        arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
        translation: "Actions are judged by intentions.",
        narrator: "Umar ibn Al-Khattab (RA)",
        source: "Sahih al-Bukhari",
        explanation: "Sincerity is essential in every act of worship.",
      );
    }
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return list[dayOfYear % list.length];
  }

  /// Remaining entries required for the complete in-app Forty Hadith reader.
  /// The Arabic lines are identifying excerpts; the English is a concise
  /// meaning so cards remain readable on mobile.
  static const List<List<Object>> _additionalHadiths = [
    [
      7,
      'Religion is Sincere Counsel',
      'الدِّينُ النَّصِيحَةُ',
      'Religion is sincere counsel: to Allah, His Book, His Messenger, Muslim leaders, and the people.',
      'Tamim al-Dari (RA)',
      'Sahih Muslim',
      'Faith includes honest concern, loyalty, and sound advice.',
    ],
    [
      8,
      'The Sanctity of Muslim Life',
      'أُمِرْتُ أَنْ أُقَاتِلَ النَّاسَ حَتَّى يَشْهَدُوا',
      'People who profess faith, establish prayer, and give zakat have protected lives and property, except by right.',
      'Abdullah ibn Umar (RA)',
      'Sahih al-Bukhari & Muslim',
      'Human life and property are protected by sacred law and due process.',
    ],
    [
      9,
      'Avoid What Is Forbidden',
      'مَا نَهَيْتُكُمْ عَنْهُ فَاجْتَنِبُوهُ',
      'Avoid what I forbid, and perform what I command as much as you are able.',
      'Abu Huraira (RA)',
      'Sahih al-Bukhari & Muslim',
      'Islam joins firm avoidance of prohibitions with mercy regarding ability.',
    ],
    [
      10,
      'Allah Accepts What Is Pure',
      'إِنَّ اللَّهَ طَيِّبٌ لَا يَقْبَلُ إِلَّا طَيِّبًا',
      'Allah is pure and accepts only what is pure.',
      'Abu Huraira (RA)',
      'Sahih Muslim',
      'Lawful earnings and wholesome conduct are foundations of accepted worship.',
    ],
    [
      11,
      'Leave What Makes You Doubt',
      'دَعْ مَا يَرِيبُكَ إِلَى مَا لَا يَرِيبُكَ',
      'Leave what makes you doubt for what does not make you doubt.',
      'Al-Hasan ibn Ali (RA)',
      'Jami at-Tirmidhi',
      'A clear conscience grows by leaving doubtful matters.',
    ],
    [
      12,
      'Leave What Does Not Concern You',
      'مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ',
      'Part of a person’s excellence in Islam is leaving what does not concern them.',
      'Abu Huraira (RA)',
      'Jami at-Tirmidhi',
      'Faith teaches focus, dignity, and respect for others’ affairs.',
    ],
    [
      13,
      'Protection of Life',
      'لَا يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ إِلَّا بِإِحْدَى ثَلَاثٍ',
      'A Muslim’s blood is not lawful except in narrowly defined cases judged under lawful authority.',
      'Abdullah ibn Masud (RA)',
      'Sahih al-Bukhari & Muslim',
      'Private violence is forbidden; justice belongs to legitimate due process.',
    ],
    [
      14,
      'Speak Good or Remain Silent',
      'فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
      'Whoever believes in Allah and the Last Day should speak good or remain silent, honour neighbours, and honour guests.',
      'Abu Huraira (RA)',
      'Sahih al-Bukhari & Muslim',
      'Good speech and hospitality are signs of faith.',
    ],
    [
      15,
      'Do Not Become Angry',
      'لَا تَغْضَبْ',
      'The Prophet repeatedly advised: Do not become angry.',
      'Abu Huraira (RA)',
      'Sahih al-Bukhari',
      'Strength includes mastering anger before it becomes harmful action.',
    ],
    [
      16,
      'Excellence in Every Action',
      'إِنَّ اللَّهَ كَتَبَ الْإِحْسَانَ عَلَى كُلِّ شَيْءٍ',
      'Allah has prescribed excellence and kindness in every matter.',
      'Shaddad ibn Aws (RA)',
      'Sahih Muslim',
      'Mercy and excellence govern even difficult responsibilities.',
    ],
    [
      17,
      'Follow a Bad Deed with a Good One',
      'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ',
      'Be mindful of Allah wherever you are; follow a bad deed with a good one, and treat people with good character.',
      'Abu Dharr (RA)',
      'Jami at-Tirmidhi',
      'Repentance, repair, and character belong together.',
    ],
    [
      18,
      'Be Mindful of Allah',
      'احْفَظِ اللَّهَ يَحْفَظْكَ',
      'Be mindful of Allah and He will protect you. Ask Allah and seek help from Allah.',
      'Abdullah ibn Abbas (RA)',
      'Jami at-Tirmidhi',
      'Reliance on Allah brings courage and steadiness.',
    ],
    [
      19,
      'Modesty Is Part of Prophetic Teaching',
      'إِذَا لَمْ تَسْتَحِ فَاصْنَعْ مَا شِئْتَ',
      'If you feel no shame, then do as you wish.',
      'Abu Masud al-Ansari (RA)',
      'Sahih al-Bukhari',
      'Healthy modesty restrains conduct when external rules are absent.',
    ],
    [
      20,
      'Believe and Remain Steadfast',
      'قُلْ آمَنْتُ بِاللَّهِ ثُمَّ اسْتَقِمْ',
      'Say, “I believe in Allah,” and then remain steadfast.',
      'Sufyan ibn Abdullah (RA)',
      'Sahih Muslim',
      'Faith is confirmed through consistent upright living.',
    ],
    [
      21,
      'The Obligatory Path to Paradise',
      'أَرَأَيْتَ إِذَا صَلَّيْتُ الْمَكْتُوبَاتِ',
      'Fulfilling the obligatory prayers, fasting, and lawful limits is a path to Paradise.',
      'Jabir ibn Abdullah (RA)',
      'Sahih Muslim',
      'Begin spiritual growth by faithfully protecting the obligations.',
    ],
    [
      22,
      'Purity Is Half of Faith',
      'الطُّهُورُ شَطْرُ الْإِيمَانِ',
      'Purity is half of faith; remembrance, prayer, charity, and patience illuminate the believer.',
      'Abu Malik al-Ashari (RA)',
      'Sahih Muslim',
      'Worship purifies both outward conduct and the heart.',
    ],
    [
      23,
      'Allah Has Forbidden Injustice',
      'يَا عِبَادِي إِنِّي حَرَّمْتُ الظُّلْمَ عَلَى نَفْسِي',
      'Allah has forbidden injustice and commands His servants not to wrong one another.',
      'Abu Dharr (RA)',
      'Sahih Muslim — Hadith Qudsi',
      'Divine mercy requires justice between people.',
    ],
    [
      24,
      'Every Good Deed Is Charity',
      'كُلُّ مَعْرُوفٍ صَدَقَةٌ',
      'Every act of remembrance and every good deed is charity.',
      'Abu Dharr (RA)',
      'Sahih Muslim',
      'Charity includes words, service, restraint, and worship—not only money.',
    ],
    [
      25,
      'Charity for Every Joint',
      'كُلُّ سُلَامَى مِنَ النَّاسِ عَلَيْهِ صَدَقَةٌ',
      'Each day, every joint owes charity through justice, help, kind speech, prayer, and removing harm.',
      'Abu Huraira (RA)',
      'Sahih al-Bukhari & Muslim',
      'Daily service expresses gratitude for the body.',
    ],
    [
      26,
      'Righteousness Is Good Character',
      'الْبِرُّ حُسْنُ الْخُلُقِ',
      'Righteousness is good character; wrongdoing is what troubles the heart and you dislike people discovering.',
      'Al-Nawwas ibn Saman (RA)',
      'Sahih Muslim',
      'Revelation and an honest conscience guide moral discernment.',
    ],
    [
      27,
      'Hold Fast to the Sunnah',
      'عَلَيْكُمْ بِسُنَّتِي',
      'Hold firmly to my Sunnah and the way of the rightly guided successors; avoid invented religious matters.',
      'Al-Irbad ibn Sariyah (RA)',
      'Abu Dawud & Jami at-Tirmidhi',
      'Sound guidance is protected through revealed teaching and verified practice.',
    ],
    [
      28,
      'The Gates of Goodness',
      'رَأْسُ الْأَمْرِ الْإِسْلَامُ وَعَمُودُهُ الصَّلَاةُ',
      'Islam is the foundation, prayer its pillar, and disciplined striving its summit; guarding the tongue protects it all.',
      'Muadh ibn Jabal (RA)',
      'Jami at-Tirmidhi',
      'Worship and responsible speech lead to lasting good.',
    ],
    [
      29,
      'Sacred Limits',
      'إِنَّ اللَّهَ فَرَضَ فَرَائِضَ فَلَا تُضَيِّعُوهَا',
      'Allah established obligations and limits: do not neglect or transgress them, and do not pry into what He left unmentioned.',
      'Abu Thalabah al-Khushani (RA)',
      'Al-Daraqutni',
      'Religion balances obedience, boundaries, and mercy.',
    ],
    [
      30,
      'True Detachment',
      'ازْهَدْ فِي الدُّنْيَا يُحِبَّكَ اللَّهُ',
      'Be detached from worldly excess and Allah will love you; do not covet what people possess and they will love you.',
      'Sahl ibn Sad (RA)',
      'Sunan Ibn Majah',
      'Contentment frees the heart from envy and dependence.',
    ],
    [
      31,
      'No Harm and No Reciprocating Harm',
      'لَا ضَرَرَ وَلَا ضِرَارَ',
      'There must be neither harm nor reciprocating harm.',
      'Abu Said al-Khudri (RA)',
      'Sunan Ibn Majah & al-Daraqutni',
      'Preventing harm is a foundational principle of Islamic ethics and law.',
    ],
    [
      32,
      'Evidence Is Required',
      'الْبَيِّنَةُ عَلَى الْمُدَّعِي وَالْيَمِينُ عَلَى مَنْ أَنْكَرَ',
      'The claimant must provide evidence, and an oath belongs to the one who denies the claim.',
      'Abdullah ibn Abbas (RA)',
      'Al-Bayhaqi',
      'Justice requires evidence rather than unsupported accusation.',
    ],
    [
      33,
      'Change Wrongdoing Responsibly',
      'مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ',
      'Whoever sees wrongdoing should change it within lawful ability—with action, speech, or rejection in the heart.',
      'Abu Said al-Khudri (RA)',
      'Sahih Muslim',
      'Correcting wrong requires wisdom, authority, and avoidance of greater harm.',
    ],
    [
      34,
      'Muslim Brotherhood',
      'لَا تَحَاسَدُوا وَلَا تَنَاجَشُوا وَلَا تَبَاغَضُوا',
      'Do not envy, deceive, hate, or abandon one another; be servants of Allah as brothers and sisters.',
      'Abu Huraira (RA)',
      'Sahih Muslim',
      'Human dignity, solidarity, and freedom from contempt are sacred.',
    ],
    [
      35,
      'Relieve the Distress of Others',
      'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً',
      'Whoever relieves a believer’s distress, helps someone in difficulty, or seeks knowledge receives Allah’s help.',
      'Abu Huraira (RA)',
      'Sahih Muslim',
      'Allah’s help accompanies service, learning, and protection of others.',
    ],
    [
      36,
      'Good Deeds Are Multiplied',
      'إِنَّ اللَّهَ كَتَبَ الْحَسَنَاتِ وَالسَّيِّئَاتِ',
      'Allah records intentions and deeds with immense generosity, multiplying good and limiting the record of evil.',
      'Abdullah ibn Abbas (RA)',
      'Sahih al-Bukhari & Muslim',
      'Divine accounting is governed by justice and abundant mercy.',
    ],
    [
      37,
      'Drawing Near to Allah',
      'مَنْ عَادَى لِي وَلِيًّا فَقَدْ آذَنْتُهُ بِالْحَرْبِ',
      'The servant draws near to Allah through obligations and voluntary worship until Allah loves them.',
      'Abu Huraira (RA)',
      'Sahih al-Bukhari — Hadith Qudsi',
      'Obligatory worship comes before voluntary spiritual growth.',
    ],
    [
      38,
      'Mistakes and Forgetfulness Are Pardoned',
      'إِنَّ اللَّهَ تَجَاوَزَ لِي عَنْ أُمَّتِي الْخَطَأَ وَالنِّسْيَانَ',
      'Allah has pardoned this community for genuine mistakes, forgetfulness, and what they are compelled to do.',
      'Abdullah ibn Abbas (RA)',
      'Sunan Ibn Majah & al-Bayhaqi',
      'Responsibility takes intention, knowledge, and freedom into account.',
    ],
    [
      39,
      'Be in This World as a Traveller',
      'كُنْ فِي الدُّنْيَا كَأَنَّكَ غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ',
      'Be in this world as though you were a stranger or a traveller.',
      'Abdullah ibn Umar (RA)',
      'Sahih al-Bukhari',
      'Remembering life’s brevity helps prioritise the Hereafter.',
    ],
    [
      40,
      'Desire Must Follow Revelation',
      'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يَكُونَ هَوَاهُ تَبَعًا لِمَا جِئْتُ بِهِ',
      'Faith is not complete until personal desire follows the guidance brought by the Prophet.',
      'Abdullah ibn Amr (RA)',
      'Kitab al-Hujjah',
      'Mature faith disciplines preference through revealed guidance.',
    ],
  ];
}
