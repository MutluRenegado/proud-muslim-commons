import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../services/storage_service.dart';
import '../services/timezone_service.dart';
import '../services/time_service.dart';
import '../../models/prayer_time_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    try {
      TimezoneService.init();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification clicked: ${details.payload}');
        },
      );

      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  static Future<void> schedulePrayerNotifications(
    PrayerTimesModel times,
  ) async {
    if (!_isInitialized) return;
    if (!StorageService.showNotifications ||
        !StorageService.azanNotificationsEnabled) {
      await cancelAll();
      return;
    }

    final toggles = StorageService.getPrayerNotificationToggles();
    final adhanToggles = StorageService.getPrayerAdhanToggles();
    final adhanSelections = StorageService.getPrayerAdhanSelections();
    final masterAdhanEnabled = StorageService.azanEnabled;
    final vibrate = StorageService.vibrateOnAzan;
    final preAzanMin = StorageService.reminderBeforeAzanMinutes;

    final scheduleList = [
      {'name': 'Fajr', 'timeUtc': times.fajrUtc, 'id': 101},
      {'name': 'Sunrise', 'timeUtc': times.sunriseUtc, 'id': 102},
      {'name': 'Dhuhr', 'timeUtc': times.dhuhrUtc, 'id': 103},
      {'name': 'Asr', 'timeUtc': times.asrUtc, 'id': 104},
      {'name': 'Maghrib', 'timeUtc': times.maghribUtc, 'id': 105},
      {'name': 'Isha', 'timeUtc': times.ishaUtc, 'id': 106},
    ];

    String androidRawResourceFor(String prayerName) {
      switch (prayerName.toLowerCase()) {
        case 'fajr':
          return 'fajr_adhan';
        case 'dhuhr':
          return 'dhuhr_edhan';
        case 'asr':
          return 'asr_adhan';
        case 'maghrib':
          return 'magrib_edhan';
        case 'isha':
          return 'isha_edhan';
        default:
          return '';
      }
    }

    final location = TimezoneService.getLocation(times.ianaTimeZone);
    final nowUtc = TimeService.nowUtc();

    for (final item in scheduleList) {
      final name = item['name'] as String;
      final key = name.toLowerCase();
      final timeUtc = item['timeUtc'] as DateTime;
      final id = item['id'] as int;
      final isPrayer = key != 'sunrise';
      final playAdhan = isPrayer &&
          masterAdhanEnabled &&
          (adhanToggles[key] ?? false) &&
          (adhanSelections[key]?.isNotEmpty ?? false);

      if (toggles[key] != true) {
        await _notifications.cancel(id);
        await _notifications.cancel(id + 100);
        continue;
      }

      if (timeUtc.isAfter(nowUtc)) {
        try {
          final tzTime = tz.TZDateTime.from(timeUtc, location);
          final rawResource = androidRawResourceFor(name);
          final channelId = playAdhan
              ? 'proud_muslim_${key}_${rawResource}_${vibrate ? 'vib' : 'novib'}_v2'
              : 'proud_muslim_${key}_silent_${vibrate ? 'vib' : 'novib'}_v2';

          await _notifications.zonedSchedule(
            id,
            'Time for $name Prayer',
            isPrayer
                ? '$name prayer time has begun.'
                : 'Sunrise time has begun.',
            tzTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId,
                isPrayer ? 'Prayer & Adhan Alerts' : 'Sunrise Reminder',
                channelDescription: 'Prayer-time alerts for Proud Muslim',
                importance: Importance.max,
                priority: Priority.high,
                enableVibration: vibrate,
                vibrationPattern: vibrate
                    ? Int64List.fromList(<int>[0, 700, 350, 700])
                    : null,
                playSound: playAdhan,
                sound: playAdhan && rawResource.isNotEmpty
                    ? RawResourceAndroidNotificationSound(rawResource)
                    : null,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: playAdhan,
              ),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );

          if (preAzanMin > 0 &&
              timeUtc.subtract(Duration(minutes: preAzanMin)).isAfter(nowUtc)) {
            final preTime = tz.TZDateTime.from(
              timeUtc.subtract(Duration(minutes: preAzanMin)),
              location,
            );
            await _notifications.zonedSchedule(
              id + 100,
              '$name Prayer in $preAzanMin Minutes',
              'Prepare for $name prayer with Wudu and remembrance.',
              preTime,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'deen_reminder_channel',
                  'Pre-Prayer Reminders',
                  importance: Importance.defaultImportance,
                  priority: Priority.defaultPriority,
                ),
                iOS: DarwinNotificationDetails(),
              ),
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.inexact,
            );
          }
        } catch (e) {
          debugPrint('Error scheduling prayer notification for $name: $e');
        }
      }
    }
  }

  static Future<void> cancelAll() async {
    if (!_isInitialized) return;
    try {
      await _notifications.cancelAll();
    } catch (_) {}
  }
}
