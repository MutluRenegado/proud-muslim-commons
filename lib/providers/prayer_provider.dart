import 'dart:async';

import 'package:flutter/material.dart';

import '../models/prayer_time_model.dart';
import '../core/services/prayer_calculation_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/hijri_calendar_service.dart';
import '../core/services/notification_service.dart';

class PrayerProvider extends ChangeNotifier {
  PrayerTimesModel? _todayPrayerTimes;
  String _currentPrayer = 'Fajr';
  String _nextPrayer = 'Dhuhr';
  Duration _timeUntilNextPrayer = Duration.zero;
  Timer? _ticker;

  CalculationMethod _method = CalculationMethod.muslimWorldLeague;
  JuristicMethod _juristic = JuristicMethod.standard;
  HighLatitudeRule _highLatitude = HighLatitudeRule.none;
  RoundingMethod _rounding = RoundingMethod.nearestMinute;

  String _locationMode = StorageService.locationMode;
  double _lat = StorageService.latitude;
  double _lng = StorageService.longitude;
  String _city = StorageService.city;
  String _country = StorageService.country;

  String _homeCity = StorageService.homeCity;
  String _homeCountry = StorageService.homeCountry;
  double _homeLat = StorageService.homeLat;
  double _homeLng = StorageService.homeLng;

  final Map<String, int> _minuteOffsets = StorageService.getPrayerOffsets();
  final Map<String, bool> _prayerNotificationToggles =
      StorageService.getPrayerNotificationToggles();
  final Map<String, bool> _prayerAdhanToggles =
      StorageService.getPrayerAdhanToggles();
  final Map<String, String> _prayerAdhanSelections =
      StorageService.getPrayerAdhanSelections();

  // Azan Settings
  bool _azanEnabled = StorageService.azanEnabled;
  String _azanSound = StorageService.azanSound;
  double _azanVolume = StorageService.azanVolume;
  bool _vibrateOnAzan = StorageService.vibrateOnAzan;
  bool _silentModeDnd = StorageService.silentModeDnd;
  int _reminderBeforeAzanMin = StorageService.reminderBeforeAzanMinutes;
  int _iqamahReminderMin = StorageService.iqamahReminderMinutes;

  PrayerTimesModel? get todayPrayerTimes => _todayPrayerTimes;
  String get currentPrayer => _currentPrayer;
  String get nextPrayer => _nextPrayer;
  Duration get timeUntilNextPrayer => _timeUntilNextPrayer;

  CalculationMethod get method => _method;
  JuristicMethod get juristic => _juristic;
  HighLatitudeRule get highLatitude => _highLatitude;
  RoundingMethod get rounding => _rounding;

  String get locationMode => _locationMode;
  String get city => _city;
  String get country => _country;
  double get latitude => _lat;
  double get longitude => _lng;

  String get homeCity => _homeCity;
  String get homeCountry => _homeCountry;
  double get homeLat => _homeLat;
  double get homeLng => _homeLng;

  Map<String, int> get minuteOffsets => _minuteOffsets;
  Map<String, bool> get prayerNotificationToggles => _prayerNotificationToggles;
  Map<String, bool> get prayerAdhanToggles => _prayerAdhanToggles;
  Map<String, String> get prayerAdhanSelections => _prayerAdhanSelections;

  bool isPrayerAdhanEnabled(String prayerName) =>
      _prayerAdhanToggles[prayerName.toLowerCase()] ?? false;
  String prayerAdhanAsset(String prayerName) =>
      _prayerAdhanSelections[prayerName.toLowerCase()] ??
      StorageService.defaultPrayerAdhanAssets[prayerName.toLowerCase()] ??
      '';

  bool get azanEnabled => _azanEnabled;
  String get azanSound => _azanSound;
  double get azanVolume => _azanVolume;
  bool get vibrateOnAzan => _vibrateOnAzan;
  bool get silentModeDnd => _silentModeDnd;
  int get reminderBeforeAzanMin => _reminderBeforeAzanMin;
  int get iqamahReminderMin => _iqamahReminderMin;
  int get reminderBeforeAzan => _reminderBeforeAzanMin;
  int get iqamahReminder => _iqamahReminderMin;

  bool get fajrEnabled => _prayerNotificationToggles['fajr'] ?? true;
  bool get sunriseEnabled => _prayerNotificationToggles['sunrise'] ?? false;
  bool get dhuhrEnabled => _prayerNotificationToggles['dhuhr'] ?? true;
  bool get asrEnabled => _prayerNotificationToggles['asr'] ?? true;
  bool get maghribEnabled => _prayerNotificationToggles['maghrib'] ?? true;
  bool get ishaEnabled => _prayerNotificationToggles['isha'] ?? true;

  void setReminderBeforeAzan(int min) => setReminderBeforeAzanMinutes(min);
  void setIqamahReminder(int min) => setIqamahReminderMinutes(min);

  PrayerProvider() {
    _loadStoredPreferences();
    _initPrayerTimes();
    _startTimer();
  }

  void _loadStoredPreferences() {
    // Load method from name
    final mName = StorageService.calculationMethodName;
    _method = CalculationMethod.values.firstWhere(
      (e) => e.name == mName,
      orElse: () => CalculationMethod.muslimWorldLeague,
    );

    // Load juristic from name
    final jName = StorageService.juristicMethodName;
    _juristic = JuristicMethod.values.firstWhere(
      (e) => e.name == jName,
      orElse: () => JuristicMethod.standard,
    );

    // Load high latitude rule
    final hlName = StorageService.highLatitudeRule;
    _highLatitude = HighLatitudeRule.values.firstWhere(
      (e) => e.name == hlName,
      orElse: () => HighLatitudeRule.none,
    );

    // Load rounding method
    final rName = StorageService.roundingMethod;
    _rounding = RoundingMethod.values.firstWhere(
      (e) => e.name == rName,
      orElse: () => RoundingMethod.nearestMinute,
    );
  }

  void _initPrayerTimes() {
    final now = DateTime.now();
    _todayPrayerTimes = PrayerCalculationService.calculatePrayerTimes(
      date: now,
      latitude: _lat,
      longitude: _lng,
      method: _method,
      juristic: _juristic,
      highLatitude: _highLatitude,
      rounding: _rounding,
      minuteOffsets: _minuteOffsets,
    );
    _updateNextPrayerStatus();
    if (_todayPrayerTimes != null) {
      NotificationService.schedulePrayerNotifications(_todayPrayerTimes!);
    }
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateNextPrayerStatus();
      notifyListeners();
    });
  }

  void _updateNextPrayerStatus() {
    if (_todayPrayerTimes == null) return;
    final now = DateTime.now();
    final times = _todayPrayerTimes!;

    final prayerSchedule = [
      MapEntry('Fajr', times.fajr),
      MapEntry('Sunrise', times.sunrise),
      MapEntry('Dhuhr', times.dhuhr),
      MapEntry('Asr', times.asr),
      MapEntry('Maghrib', times.maghrib),
      MapEntry('Isha', times.isha),
    ];

    String cur = 'Isha';
    String nxt = 'Fajr';
    DateTime nxtTime = times.fajr.add(const Duration(days: 1));

    for (int i = 0; i < prayerSchedule.length; i++) {
      if (now.isBefore(prayerSchedule[i].value)) {
        nxt = prayerSchedule[i].key;
        nxtTime = prayerSchedule[i].value;
        cur = i > 0 ? prayerSchedule[i - 1].key : 'Isha (Previous)';
        break;
      }
    }

    _currentPrayer = cur;
    _nextPrayer = nxt;
    _timeUntilNextPrayer = nxtTime.difference(now);
  }

  void setCalculationMethod(CalculationMethod newMethod) {
    _method = newMethod;
    StorageService.setCalculationMethodName(newMethod.name);
    _initPrayerTimes();
    notifyListeners();
  }

  void setJuristicMethod(JuristicMethod newJuristic) {
    _juristic = newJuristic;
    StorageService.setJuristicMethodName(newJuristic.name);
    _initPrayerTimes();
    notifyListeners();
  }

  void setHighLatitudeRule(HighLatitudeRule rule) {
    _highLatitude = rule;
    StorageService.setHighLatitudeRule(rule.name);
    _initPrayerTimes();
    notifyListeners();
  }

  void setRoundingMethod(RoundingMethod method) {
    _rounding = method;
    StorageService.setRoundingMethod(method.name);
    _initPrayerTimes();
    notifyListeners();
  }

  void setLocationMode(String mode) {
    _locationMode = mode;
    StorageService.setLocationMode(mode);
    notifyListeners();
  }

  void updateLocation(
    double lat,
    double lng,
    String city,
    String country, {
    String mode = 'manual',
  }) {
    _lat = lat;
    _lng = lng;
    _city = city;
    _country = country;
    _locationMode = mode;
    StorageService.saveLocation(lat, lng, city, country);
    StorageService.setLocationMode(mode);
    _initPrayerTimes();
    notifyListeners();
  }

  void updateHomeLocation(double lat, double lng, String city, String country) {
    _homeLat = lat;
    _homeLng = lng;
    _homeCity = city;
    _homeCountry = country;
    StorageService.saveHomeLocation(lat, lng, city, country);
    notifyListeners();
  }

  void updatePrayerOffset(String prayerName, int offsetMinutes) {
    _minuteOffsets[prayerName] = offsetMinutes;
    StorageService.savePrayerOffsets(_minuteOffsets);
    _initPrayerTimes();
    notifyListeners();
  }

  void setAzanEnabled(bool val) {
    _azanEnabled = val;
    StorageService.setAzanEnabled(val);
    _initPrayerTimes();
    notifyListeners();
  }

  void setAzanSound(String sound) {
    _azanSound = sound;
    StorageService.setAzanSound(sound);
    _initPrayerTimes();
    notifyListeners();
  }

  void setAzanVolume(double vol) {
    _azanVolume = vol;
    StorageService.setAzanVolume(vol);
    notifyListeners();
  }

  void setVibrateOnAzan(bool val) {
    _vibrateOnAzan = val;
    StorageService.setVibrateOnAzan(val);
    _initPrayerTimes();
    notifyListeners();
  }

  void setSilentModeDnd(bool val) {
    _silentModeDnd = val;
    StorageService.setSilentModeDnd(val);
    notifyListeners();
  }

  void setReminderBeforeAzanMinutes(int min) {
    _reminderBeforeAzanMin = min;
    StorageService.setReminderBeforeAzanMinutes(min);
    _initPrayerTimes();
    notifyListeners();
  }

  void setIqamahReminderMinutes(int min) {
    _iqamahReminderMin = min;
    StorageService.setIqamahReminderMinutes(min);
    notifyListeners();
  }

  void setPrayerAdhanEnabled(String prayerName, bool isEnabled) {
    _prayerAdhanToggles[prayerName.toLowerCase()] = isEnabled;
    StorageService.savePrayerAdhanToggles(_prayerAdhanToggles);
    _initPrayerTimes();
    notifyListeners();
  }

  void setPrayerAdhanAsset(String prayerName, String assetPath) {
    _prayerAdhanSelections[prayerName.toLowerCase()] = assetPath;
    StorageService.savePrayerAdhanSelections(_prayerAdhanSelections);
    _initPrayerTimes();
    notifyListeners();
  }

  void togglePrayerNotification(String prayerName, bool isEnabled) {
    _prayerNotificationToggles[prayerName.toLowerCase()] = isEnabled;
    StorageService.savePrayerNotificationToggles(_prayerNotificationToggles);
    _initPrayerTimes();
    notifyListeners();
  }

  String getHijriDateFormatted() {
    final res = HijriCalendarService.gregorianToHijri(
      DateTime.now(),
      StorageService.hijriOffset,
    );
    return res['formatted'] as String;
  }

  String getHijriDateFormattedArabic() {
    final res = HijriCalendarService.gregorianToHijri(
      DateTime.now(),
      StorageService.hijriOffset,
    );
    return res['formattedArabic'] as String;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
