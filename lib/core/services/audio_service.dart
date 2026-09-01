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
      await _tts.setSpeechRate(0.46);
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

  /// Configure TTS voice (Male / Female) for the active locale
  static Future<void> applyTtsVoice(String languageCode,
      {String? gender}) async {
    await _initTts();
    final targetGender =
        (gender ?? StorageService.ttsVoiceGender).toLowerCase();
    final locale = getTtsLocale(languageCode);
    await _tts.setLanguage(locale);

    try {
      final voices = await _tts.getVoices;
      if (voices is List && voices.isNotEmpty) {
        final localePrefix = locale.toLowerCase().split('-').first;
        final matchingVoices = voices.where((v) {
          if (v is! Map) return false;
          final vLocale = (v['locale'] ?? '').toString().toLowerCase();
          return vLocale.startsWith(localePrefix) ||
              vLocale.contains(localePrefix);
        }).toList();

        Map? chosenVoice;
        for (final v in matchingVoices) {
          if (v is! Map) continue;
          final name = (v['name'] ?? '').toString().toLowerCase();
          final vGender = (v['gender'] ?? '').toString().toLowerCase();

          if (targetGender == 'male') {
            if (vGender == 'male' ||
                name.contains('male') ||
                name.contains('#male') ||
                name.contains('-male') ||
                name.contains('man') ||
                name.contains('guy')) {
              chosenVoice = v;
              break;
            }
          } else {
            if (vGender == 'female' ||
                name.contains('female') ||
                name.contains('#female') ||
                name.contains('-female') ||
                name.contains('woman')) {
              chosenVoice = v;
              break;
            }
          }
        }

        if (chosenVoice != null) {
          await _tts.setVoice({
            'name': chosenVoice['name'].toString(),
            'locale': chosenVoice['locale'].toString(),
          });
          await _tts.setPitch(targetGender == 'male' ? 0.92 : 1.05);
          return;
        }

        if (matchingVoices.isNotEmpty && matchingVoices.first is Map) {
          final first = matchingVoices.first as Map;
          await _tts.setVoice({
            'name': first['name'].toString(),
            'locale': first['locale'].toString(),
          });
        }
      }
    } catch (_) {}

    await _tts.setPitch(targetGender == 'male' ? 0.88 : 1.08);
  }

  /// Read a full translated Surah in manageable TTS chunks.
  static Future<void> speakLongText(
    String text, {
    required String languageCode,
    required String speechId,
  }) async {
    if (text.trim().isEmpty) return;
    _initListener();
    await _initTts();
    await applyTtsVoice(languageCode);
    await stop();
    final session = ++_playbackSession;
    _currentAudioId = speechId;
    currentPlayingIdNotifier.value = speechId;
    await _tts.awaitSpeakCompletion(true);
    final words = text.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
    final chunks = <String>[];
    var chunk = StringBuffer();
    for (final word in words) {
      if (chunk.length + word.length > 2800) {
        chunks.add(chunk.toString());
        chunk = StringBuffer();
      }
      chunk.write('$word ');
    }
    if (chunk.isNotEmpty) chunks.add(chunk.toString());
    for (final part in chunks) {
      if (session != _playbackSession) return;
      await _tts.speak(part);
    }
    if (session == _playbackSession) await stop();
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
      await applyTtsVoice(langCode);
      await _tts.speak(explanationText);
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
