import 'package:alarm/alarm.dart';
import 'dart:io';
import '../../domain/entities/reminder.dart';

extension ReminderMapper on Reminder {
  AlarmSettings toAlarmSettings() {
    return AlarmSettings(
      id: id ?? DateTime.now().millisecondsSinceEpoch % 1000000,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm_rooster.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: 'Stop',
      ),
    );
  }
}

Reminder fromAlarmSettings(AlarmSettings settings) {
  return Reminder(
    id: settings.id,
    title: settings.notificationSettings.title ?? 'No Title',
    body: settings.notificationSettings.body ?? 'No Body',
    dateTime: settings.dateTime,
  );
}