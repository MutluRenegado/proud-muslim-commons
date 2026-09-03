import 'dart:async';

import 'package:flutter/material.dart';

import '../models/prayer_time_model.dart';
import '../core/services/prayer_calculation_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/timezone_service.dart';
import '../core/services/time_service.dart';
import '../core/services/hijri_calendar_service.dart';
import '../core/services/notification_service.dart';

class PrayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  PrayerTimesModel? _todayPrayerTimes;
  PrayerTimesModel? _tomorrowPrayerTimes;
  List<PrayerTimesModel> _monthlySchedule = [];

  String _currentPrayer = 'Fajr';
  String _nextPrayer = 'Dhuhr';
  Duration _timeUntilNextPrayer = Duration.zero;
  Timer? _ticker;

  CalculationMethod _method = CalculationMethod.turkeyDiyanet;
  JuristicMethod _juristic = JuristicMethod.standard;
  HighLatitudeRule _highLatitude = HighLatitudeRule.none;
  RoundingMethod _rounding = RoundingMethod.nearestMinute;

  String _locationMode = StorageService.locationMode;
  double _lat = StorageService.latitude;
  double _lng = StorageService.longitude;
  double _elevation = StorageService.elevation;
  String _city = StorageService.city;
  String _country = StorageService.country;
  String _ianaTimeZone = StorageService.ianaTimeZone;

  String _homeCity = StorageService.homeCity;
  String _homeCountry = StorageService.homeCountry;
  double _homeLat = StorageService.homeLat;
  double _homeLng = StorageService.homeLng;
  String _homeIanaTimeZone = StorageService.homeIanaTimeZone;

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
  PrayerTimesModel? get tomorrowPrayerTimes => _tomorrowPrayerTimes;
  List<PrayerTimesModel> get monthlySchedule => _monthlySchedule;

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
  double get elevation => _elevation;
  String get ianaTimeZone => _ianaTimeZone;

  String get homeCity => _homeCity;
  String get homeCountry => _homeCountry;
  double get homeLat => _homeLat;
  double get homeLng => _homeLng;
  String get homeIanaTimeZone => _homeIanaTimeZone;

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
    WidgetsBinding.instance.addObserver(this);
    TimezoneService.init();
    _loadStoredPreferences();
    _initPrayerTimes();
    _startTimer();

    // Async network time sync in background
    TimeService.syncNetworkTime().then((_) {
      _updateNextPrayerStatus();
      notifyListeners();
    });

    // Listen for major clock jumps
    TimeService.addClockJumpListener(_onClockJumpDetected);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      TimeService.checkClockJump();
      _initPrayerTimes();
      _updateNextPrayerStatus();
      notifyListeners();
    }
  }

  void _onClockJumpDetected() {
    _initPrayerTimes();
    _updateNextPrayerStatus();
    notifyListeners();
  }

  void _loadStoredPreferences() {
    // Load method from name
    final mName = StorageService.calculationMethodName;
    _method = CalculationMethod.values.firstWhere(
      (e) => e.name == mName,
      orElse: () => CalculationMethod.turkeyDiyanet,
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

    _lat = StorageService.latitude;
    _lng = StorageService.longitude;
    _elevation = StorageService.elevation;
    _city = StorageService.city;
    _country = StorageService.country;
    _ianaTimeZone = StorageService.ianaTimeZone;
    _locationMode = StorageService.locationMode;

    _homeLat = StorageService.homeLat;
    _homeLng = StorageService.homeLng;
    _homeCity = StorageService.homeCity;
    _homeCountry = StorageService.homeCountry;
    _homeIanaTimeZone = StorageService.homeIanaTimeZone;
  }

  void _initPrayerTimes() {
    final nowUtc = TimeService.nowUtc();
    final todayLocal = TimezoneService.getLocalDate(nowUtc, _ianaTimeZone);
    final tomorrowLocal = todayLocal.add(const Duration(days: 1));

    // Calculate today's prayer times
    _todayPrayerTimes = PrayerCalculationService.calculatePrayerTimes(
      date: todayLocal,
      latitude: _lat,
      longitude: _lng,
      elevation: _elevation,
      ianaTimeZone: _ianaTimeZone,
      method: _method,
      juristic: _juristic,
      highLatitude: _highLatitude,
      rounding: _rounding,
      minuteOffsets: _minuteOffsets,
    );

    // Calculate tomorrow's prayer times (for Isha -> Fajr transition)
    _tomorrowPrayerTimes = PrayerCalculationService.calculatePrayerTimes(
      date: tomorrowLocal,
      latitude: _lat,
      longitude: _lng,
      elevation: _elevation,
      ianaTimeZone: _ianaTimeZone,
      method: _method,
      juristic: _juristic,
      highLatitude: _highLatitude,
      rounding: _rounding,
      minuteOffsets: _minuteOffsets,
    );

    // Generate and cache 35-day offline schedule
    _monthlySchedule = PrayerCalculationService.generateMonthlySchedule(
      startDate: todayLocal,
      latitude: _lat,
      longitude: _lng,
      elevation: _elevation,
      ianaTimeZone: _ianaTimeZone,
      method: _method,
      juristic: _juristic,
      highLatitude: _highLatitude,
      rounding: _rounding,
      minuteOffsets: _minuteOffsets,
      daysCount: 35,
    );
    StorageService.saveOfflinePrayerSchedule(_monthlySchedule);

    _updateNextPrayerStatus();

    if (_todayPrayerTimes != null) {
      NotificationService.schedulePrayerNotifications(_todayPrayerTimes!);
    }
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowUtc = TimeService.nowUtc();
      final currentLocalDate =
          TimezoneService.getLocalDate(nowUtc, _ianaTimeZone);

      // Check if local midnight has passed
      if (_todayPrayerTimes != null &&
          (currentLocalDate.year != _todayPrayerTimes!.date.year ||
              currentLocalDate.month != _todayPrayerTimes!.date.month ||
              currentLocalDate.day != _todayPrayerTimes!.date.day)) {
        _initPrayerTimes();
      } else {
        _updateNextPrayerStatus();
      }
      notifyListeners();
    });
  }

  /// Evaluates next prayer status comparing UTC instants directly.
  void _updateNextPrayerStatus() {
    if (_todayPrayerTimes == null) return;
    final nowUtc = TimeService.nowUtc();
    final times = _todayPrayerTimes!;

    final prayerScheduleUtc = [
      MapEntry('Fajr', times.fajrUtc),
      MapEntry('Sunrise', times.sunriseUtc),
      MapEntry('Dhuhr', times.dhuhrUtc),
      MapEntry('Asr', times.asrUtc),
      MapEntry('Maghrib', times.maghribUtc),
      MapEntry('Isha', times.ishaUtc),
    ];

    String cur = 'Isha';
    String nxt = 'Fajr';
    DateTime nxtTimeUtc = _tomorrowPrayerTimes?.fajrUtc ??
        times.fajrUtc.add(const Duration(days: 1));

    bool found = false;
    for (int i = 0; i < prayerScheduleUtc.length; i++) {
      if (nowUtc.isBefore(prayerScheduleUtc[i].value)) {
        nxt = prayerScheduleUtc[i].key;
        nxtTimeUtc = prayerScheduleUtc[i].value;
        cur = i > 0 ? prayerScheduleUtc[i - 1].key : 'Isha (Previous)';
        found = true;
        break;
      }
    }

    if (!found) {
      // After today's Isha, the next prayer is tomorrow's Fajr
      cur = 'Isha';
      nxt = 'Fajr';
      nxtTimeUtc = _tomorrowPrayerTimes?.fajrUtc ??
          times.fajrUtc.add(const Duration(days: 1));
    }

    _currentPrayer = cur;
    _nextPrayer = nxt;
    _timeUntilNextPrayer = nxtTimeUtc.difference(nowUtc);
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
    String? ianaTimeZone,
    double? elevation,
  }) {
    _lat = lat;
    _lng = lng;
    _city = city;
    _country = country;
    _locationMode = mode;

    if (ianaTimeZone != null && ianaTimeZone.isNotEmpty) {
      _ianaTimeZone = ianaTimeZone;
    } else {
      _ianaTimeZone = TimezoneService.detectIanaTimeZone(
        lat: lat,
        lng: lng,
        country: country,
        city: city,
      );
    }

    if (elevation != null) {
      _elevation = elevation;
    }

    StorageService.saveLocation(
      lat,
      lng,
      city,
      country,
      ianaTimeZone: _ianaTimeZone,
      elevation: _elevation,
    );
    StorageService.setLocationMode(mode);

    _initPrayerTimes();
    notifyListeners();
  }

  void updateHomeLocation(
    double lat,
    double lng,
    String city,
    String country, {
    String? ianaTimeZone,
  }) {
    _homeLat = lat;
    _homeLng = lng;
    _homeCity = city;
    _homeCountry = country;
    _homeIanaTimeZone = ianaTimeZone ??
        TimezoneService.detectIanaTimeZone(
          lat: lat,
          lng: lng,
          country: country,
          city: city,
        );

    StorageService.saveHomeLocation(
      lat,
      lng,
      city,
      country,
      ianaTimeZone: _homeIanaTimeZone,
    );
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
    final nowUtc = TimeService.nowUtc();
    final localDate = TimezoneService.getLocalDate(nowUtc, _ianaTimeZone);
    final res = HijriCalendarService.gregorianToHijri(
      localDate,
      StorageService.hijriOffset,
    );
    return res['formatted'] as String;
  }

  String getHijriDateFormattedArabic() {
    final nowUtc = TimeService.nowUtc();
    final localDate = TimezoneService.getLocalDate(nowUtc, _ianaTimeZone);
    final res = HijriCalendarService.gregorianToHijri(
      localDate,
      StorageService.hijriOffset,
    );
    return res['formattedArabic'] as String;
  }

  String getFormattedLocalTime({bool use24Hour = false}) {
    final nowUtc = TimeService.nowUtc();
    return TimezoneService.formatTime(nowUtc, _ianaTimeZone,
        use24Hour: use24Hour);
  }

  /// Returns the live local time formatted as HH:mm:ss in the location's timezone.
  String getFormattedLocalTimeWithSeconds() {
    final nowUtc = TimeService.nowUtc();
    return TimezoneService.formatTime(
      nowUtc,
      _ianaTimeZone,
      use24Hour: true,
      showSeconds: true,
    );
  }

  /// Returns the Gregorian date formatted with pattern (default: dd.MM.yyyy) in location's timezone.
  String getFormattedGregorianDate({String pattern = 'dd.MM.yyyy'}) {
    final nowUtc = TimeService.nowUtc();
    return TimezoneService.formatDate(
      nowUtc,
      _ianaTimeZone,
      pattern: pattern,
    );
  }

  String getFormattedLocalDate() {
    final nowUtc = TimeService.nowUtc();
    return TimezoneService.formatDate(nowUtc, _ianaTimeZone);
  }

  String getUtcOffsetDisplay() {
    final nowUtc = TimeService.nowUtc();
    return TimezoneService.getUtcOffsetString(nowUtc, _ianaTimeZone);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    TimeService.removeClockJumpListener(_onClockJumpDetected);
    _ticker?.cancel();
    super.dispose();
  }
}
