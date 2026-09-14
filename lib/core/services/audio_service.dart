// audio_service.dart
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'storage_service.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static final FlutterTts _tts = FlutterTts();

  static bool _isPlaying = false;
  static bool _isLoading = false;
  static String? _currentAudioId;
  static bool _isInitialized = false;
  static bool _isTtsInitialized = false;
  static int _playbackSession = 0;

  static final ValueNotifier<String?> currentPlayingIdNotifier =
      ValueNotifier<String?>(null);
  static final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(
    false,
  );
  static final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(
    false,
  );
  static final ValueNotifier<String?> errorMessageNotifier =
      ValueNotifier<String?>(null);

  static AudioPlayer get player => _player;
  static bool get isPlaying => _isPlaying;
  static bool get isLoading => _isLoading;
  static String? get currentAudioId => _currentAudioId;

  static void _initListener() {
    if (_isInitialized) return;
    _isInitialized = true;

    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _isLoading = false;
      _currentAudioId = null;
      isPlayingNotifier.value = false;
      isLoadingNotifier.value = false;
      currentPlayingIdNotifier.value = null;
    });

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      isPlayingNotifier.value = _isPlaying;
      if (!_isPlaying && state == PlayerState.stopped) {
        _isLoading = false;
        isLoadingNotifier.value = false;
        if (_currentAudioId != null && !_currentAudioId!.startsWith('tts_')) {
          _currentAudioId = null;
          currentPlayingIdNotifier.value = null;
        }
      }
    });
  }

  static Future<void> _initTts() async {
    if (_isTtsInitialized) return;
    _isTtsInitialized = true;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final engines = await _tts.getEngines;
        if (engines is List && engines.contains('com.google.android.tts')) {
          await _tts.setEngine('com.google.android.tts');
        }
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          ],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      }

      await _tts.setSpeechRate(0.50);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      _tts.setStartHandler(() {
        _isPlaying = true;
        _isLoading = false;
        isPlayingNotifier.value = true;
        isLoadingNotifier.value = false;
      });

      _tts.setCompletionHandler(() {
        _isPlaying = false;
        _isLoading = false;
        _currentAudioId = null;
        isPlayingNotifier.value = false;
        isLoadingNotifier.value = false;
        currentPlayingIdNotifier.value = null;
      });

      _tts.setErrorHandler((msg) {
        _isPlaying = false;
        _isLoading = false;
        _currentAudioId = null;
        isPlayingNotifier.value = false;
        isLoadingNotifier.value = false;
        currentPlayingIdNotifier.value = null;
        errorMessageNotifier.value = msg.toString();
      });
    } catch (_) {}
  }

  static String _normalizeAssetPath(String rawPath) {
    var p = rawPath.replaceAll('\\', '/').trim();
    if (p.startsWith('assets/')) {
      p = p.substring('assets/'.length);
    }
    if (p.startsWith('/')) {
      p = p.substring(1);
    }
    return p;
  }

  /// Map language code to TTS locale
  static String getTtsLocale(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'tr':
        return 'tr-TR';
      case 'ar':
        return 'ar-SA';
      case 'de':
        return 'de-DE';
      case 'fr':
        return 'fr-FR';
      case 'es':
        return 'es-ES';
      case 'ru':
        return 'ru-RU';
      case 'ur':
        return 'ur-PK';
      case 'id':
        return 'id-ID';
      case 'ms':
        return 'ms-MY';
      case 'pt':
        return 'pt-PT';
      case 'hi':
        return 'hi-IN';
      case 'bn':
        return 'bn-BD';
      case 'fa':
        return 'fa-IR';
      case 'en':
      default:
        return 'en-US';
    }
  }

  /// Clean Quranic and translation text for natural, dignified audio synthesis across all 14 languages
  static String cleanTextForSpeech(String rawText, String langCode) {
    var text = rawText;

    // 1. Remove footnote numbers and bracket citations like [1], [2], (1), [i.e., ...]
    text = text.replaceAll(RegExp(r'\[\d+\]'), '');
    text = text.replaceAll(RegExp(r'\(\d+\)'), '');
    text = text.replaceAll(RegExp(r'\[.*?\]'), '');

    // 2. Expand honorific abbreviations according to language
    final code = langCode.toLowerCase();
    switch (code) {
      case 'tr':
        text = text.replaceAll(RegExp(r'\b\(s\.a\.v\.\)\b', caseSensitive: false), ' sallallahu aleyhi ve sellem ');
        text = text.replaceAll(RegExp(r'\b\(sav\)\b', caseSensitive: false), ' sallallahu aleyhi ve sellem ');
        text = text.replaceAll(RegExp(r'\b\(a\.s\.\)\b', caseSensitive: false), ' aleyhisselam ');
        text = text.replaceAll(RegExp(r'\b\(as\)\b', caseSensitive: false), ' aleyhisselam ');
        text = text.replaceAll(RegExp(r'\b\(r\.a\.\)\b', caseSensitive: false), ' radiyallahu anh ');
        text = text.replaceAll(RegExp(r'\b\(c\.c\.\)\b', caseSensitive: false), ' celle celaluhu ');
        break;
      case 'ar':
        text = text.replaceAll('ﷺ', ' صلى الله عليه وسلم ');
        text = text.replaceAll('(ص)', ' صلى الله عليه وسلم ');
        text = text.replaceAll('(ع)', ' عليه السلام ');
        text = text.replaceAll('(رض)', ' رضي الله عنه ');
        text = text.replaceAll('(ج)', ' جل جلاله ');
        break;
      case 'fr':
        text = text.replaceAll(RegExp(r'\b\(pbsl\)\b', caseSensitive: false), ' paix et bénédictions sur lui ');
        text = text.replaceAll(RegExp(r'\b\(saw\)\b', caseSensitive: false), ' paix et bénédictions sur lui ');
        text = text.replaceAll(RegExp(r'\b\(swt\)\b', caseSensitive: false), ' Subhanahu wa Ta\'ala ');
        break;
      case 'de':
        text = text.replaceAll(RegExp(r'\b\(saw\)\b', caseSensitive: false), ' Friede sei auf ihm ');
        text = text.replaceAll(RegExp(r'\b\(a\.s\.\)\b', caseSensitive: false), ' Friede sei auf ihm ');
        text = text.replaceAll(RegExp(r'\b\(swt\)\b', caseSensitive: false), ' Subhanahu wa Ta\'ala ');
        break;
      case 'es':
        text = text.replaceAll(RegExp(r'\b\(pbd\)\b', caseSensitive: false), ' la paz sea con él ');
        text = text.replaceAll(RegExp(r'\b\(saw\)\b', caseSensitive: false), ' la paz sea con él ');
        text = text.replaceAll(RegExp(r'\b\(swt\)\b', caseSensitive: false), ' Subhanahu wa Ta\'ala ');
        break;
      case 'id':
      case 'ms':
        text = text.replaceAll(RegExp(r'\b\(saw\)\b', caseSensitive: false), ' shallallahu \'alaihi wa sallam ');
        text = text.replaceAll(RegExp(r'\b\(swt\)\b', caseSensitive: false), ' Subhanahu wa Ta\'ala ');
        text = text.replaceAll(RegExp(r'\b\(as\)\b', caseSensitive: false), ' \'alaihissalam ');
        text = text.replaceAll(RegExp(r'\b\(ra\)\b', caseSensitive: false), ' radhiyallahu \'anhu ');
        break;
      case 'ru':
        text = text.replaceAll(RegExp(r'\b\(с\.а\.с\.\)\b', caseSensitive: false), ' да благословит его Аллах и приветствует ');
        text = text.replaceAll(RegExp(r'\b\(мир ему\)\b', caseSensitive: false), ' мир ему ');
        text = text.replaceAll(RegExp(r'\b\(свт\)\b', caseSensitive: false), ' Субханаху ва Та\'аля ');
        break;
      case 'ur':
        text = text.replaceAll('ﷺ', ' صلی اللہ علیہ وسلم ');
        text = text.replaceAll('(ص)', ' صلی اللہ علیہ وسلم ');
        text = text.replaceAll('(ع)', ' علیہ السلام ');
        text = text.replaceAll('(رض)', ' رضی اللہ عنہ ');
        break;
      case 'en':
      default:
        text = text.replaceAll(RegExp(r'\b\(pbuh\)\b', caseSensitive: false), ', peace be upon him, ');
        text = text.replaceAll(RegExp(r'\b\(saw\)\b', caseSensitive: false), ', peace be upon him, ');
        text = text.replaceAll(RegExp(r'\b\(p\.b\.u\.h\)\b', caseSensitive: false), ', peace be upon him, ');
        text = text.replaceAll(RegExp(r'\b\(swt\)\b', caseSensitive: false), ' Subhanahu wa Ta\'ala ');
        text = text.replaceAll(RegExp(r'\b\(as\)\b', caseSensitive: false), ', peace be upon him, ');
        text = text.replaceAll(RegExp(r'\b\(ra\)\b', caseSensitive: false), ', may Allah be pleased with him, ');
        break;
    }

    // 3. Clean editorial symbols, asterisks, brackets, repeated punctuation
    text = text.replaceAll(RegExp(r'[\*\#\_\~]'), '');
    text = text.replaceAll(RegExp(r'(\.{2,})'), '. ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Stop all playback (AudioPlayer & TTS)
  static Future<void> stop() async {
    _playbackSession++;
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}

    _isPlaying = false;
    _isLoading = false;
    _currentAudioId = null;
    isPlayingNotifier.value = false;
    isLoadingNotifier.value = false;
    currentPlayingIdNotifier.value = null;
  }

  /// Play every ayah in order as one complete Surah recitation.
  static Future<void> playAudioSequence(
    List<String> urls, {
    required String sequenceId,
  }) async {
    if (urls.isEmpty) return;
    _initListener();
    await stop();
    final session = ++_playbackSession;
    _currentAudioId = sequenceId;
    currentPlayingIdNotifier.value = sequenceId;
    for (final url in urls) {
      if (session != _playbackSession) return;
      try {
        _isLoading = true;
        isLoadingNotifier.value = true;
        await _player.play(UrlSource(url));
        _isPlaying = true;
        _isLoading = false;
        isPlayingNotifier.value = true;
        isLoadingNotifier.value = false;
        await _player.onPlayerComplete.first;
      } catch (error) {
        errorMessageNotifier.value = error.toString();
        break;
      }
    }
    if (session == _playbackSession) await stop();
  }

  /// Configure high-quality neural / natural TTS voice (Male / Female) for the active locale
  static Future<void> applyTtsVoice(String languageCode,
      {String? gender}) async {
    await _initTts();
    final targetGender =
        (gender ?? StorageService.ttsVoiceGender).toLowerCase();
    final locale = getTtsLocale(languageCode);
    await _tts.setLanguage(locale);

    // Male voice uses deep, masculine pitch (0.76) and reverent rate (0.44)
    // Female voice uses natural bright pitch (1.08) and smooth rate (0.48)
    if (targetGender == 'male') {
      await _tts.setSpeechRate(0.44);
      await _tts.setPitch(0.76);
    } else {
      await _tts.setSpeechRate(0.48);
      await _tts.setPitch(1.08);
    }

    try {
      final voices = await _tts.getVoices;
      if (voices is List && voices.isNotEmpty) {
        final localePrefix = locale.toLowerCase().split('-').first;

        int scoreVoice(Map v) {
          int score = 0;
          final name = (v['name'] ?? '').toString().toLowerCase();
          final vLocale =
              (v['locale'] ?? '').toString().toLowerCase().replaceAll('_', '-');
          final rawGender = (v['gender'] ?? '').toString().toLowerCase();
          final isExplicitMale = rawGender == 'male' ||
              rawGender == '1' ||
              v['gender'] == 1 ||
              name.contains('male') ||
              name.contains('#male') ||
              name.contains('-male') ||
              name.contains('male-') ||
              name.contains('man') ||
              name.contains('guy') ||
              name.contains('david') ||
              name.contains('george') ||
              name.contains('alex') ||
              name.contains('mark') ||
              name.contains('james') ||
              name.contains('daniel') ||
              name.contains('oliver') ||
              name.contains('arthur') ||
              name.contains('tom') ||
              name.contains('-m0') ||
              name.contains('-m1') ||
              name.contains('-iom') ||
              name.contains('-sfg') ||
              name.contains('-iob') ||
              name.contains('-tpc') ||
              name.contains('-tpf') ||
              name.contains('-iol') ||
              name.contains('-ama') ||
              name.contains('-dfz') ||
              name.contains('-ard') ||
              name.contains('-arc') ||
              name.contains('-vda') ||
              name.contains('-frd') ||
              name.contains('-deb') ||
              name.contains('-deg') ||
              name.contains('-eed') ||
              name.contains('-esd') ||
              name.contains('-idc') ||
              name.contains('-rud') ||
              name.contains('-urb') ||
              name.contains('-bnb') ||
              name.contains('-hid') ||
              name.contains('-fab') ||
              name.contains('-rjs') ||
              name.contains('-gbg') ||
              name.contains('-gbb') ||
              name.contains('-aud') ||
              name.contains('-enc') ||
              name.contains('-end');

          final isExplicitFemale = rawGender == 'female' ||
              rawGender == '2' ||
              v['gender'] == 2 ||
              name.contains('female') ||
              name.contains('#female') ||
              name.contains('-female') ||
              name.contains('female-') ||
              name.contains('woman') ||
              name.contains('girl') ||
              name.contains('eva') ||
              name.contains('zira') ||
              name.contains('samantha') ||
              name.contains('victoria') ||
              name.contains('karen') ||
              name.contains('tpa') ||
              name.contains('tpd') ||
              name.contains('gbf') ||
              name.contains('aub') ||
              name.contains('cxx') ||
              name.contains('ena');

          // Locale Match
          if (vLocale == locale.toLowerCase()) {
            score += 100;
          } else if (vLocale.startsWith(localePrefix)) {
            score += 50;
          } else {
            return -200; // Incompatible language
          }

          // Premium / Neural / High Quality identifiers
          if (name.contains('neural') ||
              name.contains('wavenet') ||
              name.contains('studio') ||
              name.contains('natural') ||
              name.contains('network') ||
              name.contains('enhanced') ||
              name.contains('high') ||
              name.contains('hq')) {
            score += 60;
          }

          // Gender match preference
          if (targetGender == 'male') {
            if (isExplicitMale) {
              score += 150;
            }
            if (isExplicitFemale) {
              score -= 200;
            }
          } else {
            if (isExplicitFemale) {
              score += 150;
            }
            if (isExplicitMale) {
              score -= 200;
            }
          }

          // Deprioritize robotic/compact voices
          if (name.contains('compact') ||
              name.contains('low') ||
              name.contains('synthetic') ||
              name.contains('fallback')) {
            score -= 40;
          }

          return score;
        }

        Map? bestVoice;
        int highestScore = -999;

        for (final item in voices) {
          if (item is! Map) continue;
          final s = scoreVoice(item);
          if (s > highestScore && s > 0) {
            highestScore = s;
            bestVoice = item;
          }
        }

        if (bestVoice != null) {
          await _tts.setVoice({
            'name': bestVoice['name'].toString(),
            'locale': bestVoice['locale'].toString(),
          });
          return;
        }
      }
    } catch (_) {}
  }

  /// High-Definition Cloud Neural Voice URL generator with native language accents
  static String getCloudTtsUrl(String phrase, String langCode) {
    final cleanCode = langCode.toLowerCase().trim();
    final tl = cleanCode == 'fa' ? 'fa' : (cleanCode == 'ur' ? 'ur' : cleanCode);
    final encoded = Uri.encodeComponent(phrase);
    return 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=$tl&q=$encoded';
  }

  /// Quick sample preview for testing Male or Female AI Voice across any language
  static Future<void> previewTtsVoice(String languageCode, String gender) async {
    await stop();
    final sample = languageCode.toLowerCase() == 'tr'
        ? 'Rahman ve Rahim olan Allah\'ın adıyla.'
        : (languageCode.toLowerCase() == 'ar'
            ? 'بسم الله الرحمن الرحيم'
            : (languageCode.toLowerCase() == 'fr'
                ? 'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux.'
                : (languageCode.toLowerCase() == 'de'
                    ? 'Im Namen Allahs, des Allerbarmers, des Barmherzigen.'
                    : (languageCode.toLowerCase() == 'es'
                        ? 'En el nombre de Alá, el Compasivo, el Misericordioso.'
                        : (languageCode.toLowerCase() == 'id'
                            ? 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.'
                            : (languageCode.toLowerCase() == 'ru'
                                ? 'Во имя Аллаха, Милостивого, Милосердного.'
                                : 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'))))));
    await speakLongText(
      sample,
      languageCode: languageCode,
      speechId: 'preview_${gender}_${DateTime.now().millisecondsSinceEpoch}',
      forcedGender: gender,
    );
  }

  /// Reads translated Quranic text with studio-grade Neural Speech & instant offline fallback.
  static Future<void> speakLongText(
    String text, {
    required String languageCode,
    required String speechId,
    String? forcedGender,
  }) async {
    final cleaned = cleanTextForSpeech(text, languageCode);
    if (cleaned.trim().isEmpty) return;

    _initListener();
    await stop();

    final session = ++_playbackSession;
    _currentAudioId = speechId;
    currentPlayingIdNotifier.value = speechId;

    final targetGender = (forcedGender ?? StorageService.ttsVoiceGender).toLowerCase();
    final isMale = targetGender == 'male';

    // Initialize TTS once cleanly prior to reading
    if (isMale) {
      await _initTts();
      await applyTtsVoice(languageCode, gender: 'male');
    }

    // Split text into coherent clauses/sentences (<180 chars per phrase)
    final rawSentences = cleaned
        .split(RegExp(r'(?<=[.!?;\n])\s+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    final phrases = <String>[];
    for (final sent in rawSentences) {
      if (sent.length <= 180) {
        phrases.add(sent);
      } else {
        // Break long compound sentences cleanly by comma/semicolon/words
        final subParts = sent.split(RegExp(r'(?<=[,;:])\s+'));
        var currentChunk = StringBuffer();
        for (final part in subParts) {
          if (currentChunk.length + part.length > 170) {
            if (currentChunk.isNotEmpty) phrases.add(currentChunk.toString());
            currentChunk = StringBuffer();
          }
          currentChunk.write('$part ');
        }
        if (currentChunk.isNotEmpty) phrases.add(currentChunk.toString().trim());
      }
    }

    _isPlaying = true;
    isPlayingNotifier.value = true;

    for (final phrase in phrases) {
      if (session != _playbackSession) return;
      final trimmed = phrase.trim();
      if (trimmed.isEmpty) continue;

      bool playedAudio = false;

      // 1. If Female is selected, use high-definition Cloud Stream
      if (!isMale) {
        try {
          final cloudUrl = getCloudTtsUrl(trimmed, languageCode);
          _isLoading = true;
          isLoadingNotifier.value = true;
          await _player.play(UrlSource(cloudUrl));
          _isLoading = false;
          isLoadingNotifier.value = false;
          await _player.onPlayerComplete.first;
          playedAudio = true;
        } catch (_) {
          playedAudio = false;
        }
      }

      // 2. Dedicated Male Voice / High-Quality Neural TTS
      if (!playedAudio && session == _playbackSession) {
        try {
          await _tts.awaitSpeakCompletion(true);
          await _tts.speak(trimmed);
          playedAudio = true;
        } catch (_) {}
      }

      // Peaceful, serene pause between sentences
      if (session == _playbackSession) {
        await Future.delayed(const Duration(milliseconds: 280));
      }
    }

    if (session == _playbackSession) {
      await stop();
    }
  }

  /// Play Ayah audio stream
  static Future<void> playAyahAudio(String url, {String? ayahId}) async {
    _initListener();
    final id = ayahId ?? url;
    if (_currentAudioId == id && _isPlaying) {
      await stop();
      return;
    }
    await stop();

    _currentAudioId = id;
    currentPlayingIdNotifier.value = id;
    _isLoading = true;
    isLoadingNotifier.value = true;

    try {
      await _player.play(UrlSource(url));
      _isPlaying = true;
      _isLoading = false;
      isPlayingNotifier.value = true;
      isLoadingNotifier.value = false;
    } catch (e) {
      await stop();
      errorMessageNotifier.value = e.toString();
    }
  }

  /// Play 99 Names of Allah native Arabic pronunciation (AUDIO 1)
  static Future<void> playNativeArabicName(
    int number, {
    required String arabicText,
    String? assetPath,
  }) async {
    _initListener();
    await _initTts();
    final audioId = 'ar_$number';
    if (_currentAudioId == audioId && _isPlaying) {
      await stop();
      return;
    }
    await stop();

    _currentAudioId = audioId;
    currentPlayingIdNotifier.value = audioId;
    _isLoading = true;
    isLoadingNotifier.value = true;

    final targetPath = (assetPath != null && assetPath.isNotEmpty)
        ? assetPath
        : 'assets/audio/names/arabic_pronunciation/$number.mp3';

    try {
      final normPath = _normalizeAssetPath(targetPath);
      await _player.play(AssetSource(normPath));
      _isPlaying = true;
      _isLoading = false;
      isPlayingNotifier.value = true;
      isLoadingNotifier.value = false;
      return;
    } catch (error) {
      try {
        await _tts.setLanguage('ar-SA');
        await _tts.speak(arabicText);
      } catch (_) {
        await stop();
        errorMessageNotifier.value = error.toString();
      }
    }
  }

  /// Play 99 Names of Allah Turkish pronunciation of the Arabic Name (AUDIO 3)
  static Future<void> playTurkishPronunciation(
    int number,
    String pronunciationText, {
    String? assetPath,
  }) async {
    _initListener();
    await _initTts();

    final audioId = 'tr_pron_$number';
    if (_currentAudioId == audioId && _isPlaying) {
      await stop();
      return;
    }
    await stop();

    _currentAudioId = audioId;
    currentPlayingIdNotifier.value = audioId;
    _isLoading = true;
    isLoadingNotifier.value = true;

    try {
      if (assetPath != null && assetPath.isNotEmpty) {
        final normPath = _normalizeAssetPath(assetPath);
        await _player.play(AssetSource(normPath));
        _isPlaying = true;
        _isLoading = false;
        isPlayingNotifier.value = true;
        isLoadingNotifier.value = false;
        return;
      }
      await _tts.setLanguage('tr-TR');
      await _tts.speak(pronunciationText);
    } catch (e) {
      await stop();
      errorMessageNotifier.value = e.toString();
    }
  }

  /// Play 99 Names of Allah explanation in current app language (AUDIO 2 & AUDIO 4)
  static Future<void> playExplanationAudio({
    required int number,
    required String langCode,
    required String explanationText,
    String? assetPath,
  }) async {
    _initListener();
    await _initTts();

    final audioId = 'expl_${langCode}_$number';
    if (_currentAudioId == audioId && _isPlaying) {
      await stop();
      return;
    }
    await stop();

    _currentAudioId = audioId;
    currentPlayingIdNotifier.value = audioId;
    _isLoading = true;
    isLoadingNotifier.value = true;

    // Check if bundled pre-recorded narration asset exists for EN or TR
    if (assetPath != null && assetPath.isNotEmpty) {
      try {
        final normPath = _normalizeAssetPath(assetPath);
        await _player.play(AssetSource(normPath));
        _isPlaying = true;
        _isLoading = false;
        isPlayingNotifier.value = true;
        isLoadingNotifier.value = false;
        return;
      } catch (_) {
        // If asset missing, fallback seamlessly to TTS narration below
      }
    }

    // TTS Narration for the current language
    try {
      await _tts.setLanguage(getTtsLocale(langCode));
      final cleanText = cleanTextForSpeech(explanationText, langCode);
      await _tts.speak(cleanText);
    } catch (e) {
      await stop();
      errorMessageNotifier.value = e.toString();
    }
  }

  /// Legacy playNameAudio compatibility
  static Future<void> playNameAudio(String audioId, String audioUrl) async {
    _initListener();
    if (_currentAudioId == audioId && _isPlaying) {
      await stop();
      return;
    }
    await stop();

    _currentAudioId = audioId;
    currentPlayingIdNotifier.value = audioId;
    _isLoading = true;
    isLoadingNotifier.value = true;

    try {
      if (audioUrl.startsWith('http://') || audioUrl.startsWith('https://')) {
        await _player.play(UrlSource(audioUrl));
      } else {
        final normPath = _normalizeAssetPath(audioUrl);
        await _player.play(AssetSource(normPath));
      }
      _isPlaying = true;
      _isLoading = false;
      isPlayingNotifier.value = true;
      isLoadingNotifier.value = false;
    } catch (e) {
      await stop();
      errorMessageNotifier.value = e.toString();
    }
  }

  /// Bundled prayer-specific Adhan asset. The selection is persisted by
  /// PrayerProvider/StorageService; this helper is also used by previews.
  static String getPrayerAdhanAsset(String prayerName) {
    return StorageService.getPrayerAdhanSelections()[
            prayerName.toLowerCase()] ??
        StorageService.defaultPrayerAdhanAssets[prayerName.toLowerCase()] ??
        '';
  }

  static Future<void> playPrayerAdhan(String prayerName) async {
    final asset = getPrayerAdhanAsset(prayerName);
    if (asset.isEmpty) return;
    await playNameAudio(
      'prayer_adhan_${prayerName.toLowerCase()}',
      asset,
    );
  }

  static Future<void> playAdhanAssetPreview(
    String prayerName,
    String assetPath,
  ) async {
    await playNameAudio(
      'prayer_adhan_${prayerName.toLowerCase()}',
      assetPath,
    );
  }

  static Future<void> pause() async {
    try {
      await _player.pause();
      await _tts.stop();
      _isPlaying = false;
      isPlayingNotifier.value = false;
    } catch (_) {}
  }

  static Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
      isPlayingNotifier.value = true;
    } catch (_) {}
  }
}
