import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tasbih_model.dart';
import '../core/services/storage_service.dart';

class TasbihProvider extends ChangeNotifier {
  static const List<DhikrPreset> defaultPresets = [
    DhikrPreset(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'SubhanAllah',
      meaning: 'Glory be to Allah',
      defaultTarget: 33,
    ),
    DhikrPreset(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'Praise be to Allah',
      defaultTarget: 33,
    ),
    DhikrPreset(
      id: 'allahuakbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'Allah is the Greatest',
      defaultTarget: 33,
    ),
    DhikrPreset(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'I seek forgiveness from Allah',
      defaultTarget: 100,
    ),
    DhikrPreset(
      id: 'lailahaillallah',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illallah',
      meaning: 'None has the right to be worshipped but Allah',
      defaultTarget: 100,
    ),
    DhikrPreset(
      id: 'salawat',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma Salli Ala Muhammad',
      meaning: 'O Allah, send blessings upon Muhammad',
      defaultTarget: 100,
    ),
  ];

  int _selectedPresetIndex = 0;
  int _currentCount = 0;
  int _targetCount = 33;
  int _totalLaps = 0;
  bool _vibrateOnCount = true;

  int get selectedPresetIndex => _selectedPresetIndex;
  DhikrPreset get currentPreset => defaultPresets[_selectedPresetIndex];
  int get currentCount => _currentCount;
  int get targetCount => _targetCount;
  int get totalLaps => _totalLaps;
  bool get vibrateOnCount => _vibrateOnCount;
  int get inspirationIndex => (_currentCount ~/ 10) % 6;

  TasbihProvider() {
    _loadCountForPreset();
  }

  void selectPreset(int index) {
    _selectedPresetIndex = index;
    _targetCount = defaultPresets[index].defaultTarget;
    _loadCountForPreset();
    notifyListeners();
  }

  void _loadCountForPreset() {
    _currentCount = StorageService.getDhikrCount(currentPreset.id);
  }

  void increment() {
    _currentCount++;
    if (_vibrateOnCount) {
      HapticFeedback.lightImpact();
    }
    if (_currentCount >= _targetCount) {
      _totalLaps++;
      _currentCount = 0;
      HapticFeedback.mediumImpact();
    }
    StorageService.setDhikrCount(currentPreset.id, _currentCount);
    notifyListeners();
  }

  void reset() {
    _currentCount = 0;
    StorageService.setDhikrCount(currentPreset.id, 0);
    notifyListeners();
  }

  void setTarget(int target) {
    _targetCount = target;
    notifyListeners();
  }

  void toggleVibration() {
    _vibrateOnCount = !_vibrateOnCount;
    notifyListeners();
  }
}
