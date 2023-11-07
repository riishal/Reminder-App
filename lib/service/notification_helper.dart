import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification
  initializeNotification() async {
    _configureLocalTimeZone();
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    print('///////////date: $scheduleDate');
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Scheduled Notification
  Future scheduledNotification({
    required int hour,
    required int minutes,
    required int id,
    required String sound,
  }) async {
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   Random().nextInt(10000),
    //   'It\'s time to drink water!',
    //   'After drinking, touch the cup to confirm',
    //   // _convertTime(hour, minutes),
    //   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'your channel id $sound',
    //       'your channel name',
    //       channelDescription: 'your channel description',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //       // sound: RawResourceAndroidNotificationSound(sound),
    //     ),
    //     iOS: const DarwinNotificationDetails(
    //         // sound: '$sound.mp3'
    //         ),
    //   ),
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    //   payload: 'It could be anything you pass',
    // );
    var date = DateTime(2023, 11, 07, 15, 5);
    int id = Random().nextInt(10000);
    print(date.toString());
    print(tz.TZDateTime.parse(tz.local, date.toString()).toString());
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'It\'s time to drink water!',
        'After drinking, touch the cup to confirm',
        tz.TZDateTime.parse(tz.local, date.toString()),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
            playSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      print("Error at zonedScheduleNotification----------------------------$e");
      if (e ==
          "Invalid argument (scheduledDate): Must be a date in the future: Instance of 'TZDateTime'") {
        print("Select future date");
      }
      return -1;
    }
  }

  /// Request IOS permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}
