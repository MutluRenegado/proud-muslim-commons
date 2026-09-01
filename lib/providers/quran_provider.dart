import 'package:flutter/material.dart';

import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/quran_language.dart';
import '../models/quran_edition.dart';
import '../core/repositories/quran_repository.dart';
import '../core/repositories/quran_edition_repository.dart';
import '../core/services/quran_preferences_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/audio_service.dart';

class QuranProvider extends ChangeNotifier {
  List<SurahModel> _surahs = [];
  List<AyahModel> _currentAyahs = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentSurahNumber = 1;
  double _arabicFontSize = StorageService.arabicFontSize;
  double _translationFontSize = StorageService.translationFontSize;
  String? _currentlyPlayingAudio;

  // 14-Language Quran Translation System State
  String _selectedLanguageCode =
      QuranPreferencesService.getSelectedLanguageCode();
  String _selectedEditionId = QuranPreferencesService.getSelectedEditionId();
  bool _showTranslation = QuranPreferencesService.getShowTranslation();

  // Offline Download State
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadingLanguageCode;

  // Getters
  List<SurahModel> get surahs => _surahs;
  List<AyahModel> get currentAyahs => _currentAyahs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentSurahNumber => _currentSurahNumber;
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  String? get currentlyPlayingAudio => _currentlyPlayingAudio;

  String get selectedLanguageCode => _selectedLanguageCode;
  String get selectedEditionId => _selectedEditionId;
  bool get showTranslation => _showTranslation;
  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  String? get downloadingLanguageCode => _downloadingLanguageCode;

  Future<void> playFullSurahArabic() async {
    final urls = _currentAyahs
        .map((ayah) => ayah.audioUrl)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();
    await AudioService.playAudioSequence(
      urls,
      sequenceId: 'surah_ar_$_currentSurahNumber',
    );
  }

  Future<void> playFullSurahTranslation() async {
    final text = _currentAyahs
        .map((ayah) => ayah.translation.trim())
        .where((value) => value.isNotEmpty)
        .join('. ');
    await AudioService.speakLongText(
      text,
      languageCode: _selectedLanguageCode,
      speechId:
          'surah_translation_${_currentSurahNumber}_$_selectedLanguageCode',
    );
  }

  Future<void> stopFullSurahAudio() => AudioService.stop();

  List<QuranLanguage> get supportedLanguages =>
      QuranEditionRepository.supportedLanguages;

  QuranLanguage? get selectedLanguage =>
      QuranEditionRepository.getLanguageByCode(_selectedLanguageCode);

  QuranEdition? get selectedEdition =>
      QuranEditionRepository.getEditionById(_selectedEditionId) ??
      QuranEditionRepository.getDefaultEditionForLanguage(
        _selectedLanguageCode,
      );

  List<QuranEdition> get availableEditionsForCurrentLanguage =>
      QuranEditionRepository.getEditionsForLanguage(_selectedLanguageCode);

  QuranProvider() {
    _initPreferences();
    loadSurahs();
  }

  void _initPreferences() {
    _selectedLanguageCode = QuranPreferencesService.getSelectedLanguageCode();
    _selectedEditionId = QuranPreferencesService.getSelectedEditionId(
      _selectedLanguageCode,
    );
    _showTranslation = QuranPreferencesService.getShowTranslation();
    _arabicFontSize = QuranPreferencesService.getArabicFontSize();
    _translationFontSize = QuranPreferencesService.getTranslationFontSize();
  }

  Future<void> loadSurahs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _surahs = await QuranRepository.loadSurahs();
      if (_surahs.isEmpty) {
        _errorMessage = 'Quran data could not be loaded.';
      }
    } catch (error) {
      _errorMessage = error.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSurahDetail(int surahNum) async {
    _currentSurahNumber = surahNum;
    _isLoading = true;
    notifyListeners();

    _currentAyahs = await QuranRepository.getSurahVerses(
      surahNum,
      editionId: _selectedEditionId,
      showTranslation: _showTranslation,
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Change translation language (auto-selects first approved edition)
  Future<void> changeTranslationLanguage(String langCode) async {
    if (_selectedLanguageCode == langCode &&
        QuranEditionRepository.getEditionById(_selectedEditionId)
                ?.languageCode ==
            langCode) {
      return;
    }

    _selectedLanguageCode = langCode;
    await QuranPreferencesService.setSelectedLanguageCode(langCode);

    final defaultEdition = QuranEditionRepository.getDefaultEditionForLanguage(
      langCode,
    );
    if (defaultEdition != null) {
      _selectedEditionId = defaultEdition.id;
      await QuranPreferencesService.setSelectedEditionId(defaultEdition.id);
    }

    notifyListeners();

    // Reload active surah if loaded
    if (_currentAyahs.isNotEmpty) {
      await loadSurahDetail(_currentSurahNumber);
    }
  }

  /// Change translation edition / translator
  Future<void> changeTranslationEdition(String editionId) async {
    if (_selectedEditionId == editionId) return;

    final edition = QuranEditionRepository.getEditionById(editionId);
    if (edition != null && edition.approved && edition.enabled) {
      _selectedEditionId = edition.id;
      _selectedLanguageCode = edition.languageCode;
      await QuranPreferencesService.setSelectedEditionId(edition.id);
      await QuranPreferencesService.setSelectedLanguageCode(
        edition.languageCode,
      );
      notifyListeners();

      if (_currentAyahs.isNotEmpty) {
        await loadSurahDetail(_currentSurahNumber);
      }
    }
  }

  /// Toggle showing translation beneath Arabic text
  Future<void> toggleShowTranslation(bool show) async {
    _showTranslation = show;
    await QuranPreferencesService.setShowTranslation(show);
    notifyListeners();

    if (_currentAyahs.isNotEmpty) {
      await loadSurahDetail(_currentSurahNumber);
    }
  }

  /// Download full language for offline use
  Future<bool> downloadLanguageForOffline(String langCode) async {
    _isDownloading = true;
    _downloadingLanguageCode = langCode;
    _downloadProgress = 0.0;
    notifyListeners();

    final success = await QuranRepository.downloadLanguageForOffline(
      langCode,
      editionId: _selectedLanguageCode == langCode ? _selectedEditionId : null,
      onProgress: (p) {
        _downloadProgress = p;
        notifyListeners();
      },
    );

    _isDownloading = false;
    _downloadingLanguageCode = null;
    notifyListeners();
    return success;
  }

  void playAyahAudio(String? audioUrl) async {
    if (audioUrl == null) return;
    if (_currentlyPlayingAudio == audioUrl && AudioService.isPlaying) {
      await AudioService.pause();
      _currentlyPlayingAudio = null;
    } else {
      _currentlyPlayingAudio = audioUrl;
      await AudioService.playAyahAudio(audioUrl);
    }
    notifyListeners();
  }

  void setArabicFontSize(double size) {
    _arabicFontSize = size;
    StorageService.setArabicFontSize(size);
    notifyListeners();
  }

  void setTranslationFontSize(double size) {
    _translationFontSize = size;
    StorageService.setTranslationFontSize(size);
    notifyListeners();
  }

  void toggleBookmark(int ayahNum) {
    StorageService.toggleBookmark(_currentSurahNumber, ayahNum);
    notifyListeners();
  }

  bool isAyahBookmarked(int ayahNum) {
    return StorageService.isBookmarked(_currentSurahNumber, ayahNum);
  }
}
