import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Alarm is ringing......."),
          Text(widget.alarmSettings.notificationSettings.title ?? 'Alarm Title'),
          Text(widget.alarmSettings.notificationSettings.body ?? 'Alarm Body'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await Alarm.stop(widget.alarmSettings.id);
                    final now = DateTime.now();
                    final newDate = DateTime(now.year, now.month, now.day, now.hour, now.minute).add(const Duration(minutes: 1));
                    await Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(dateTime: newDate),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Snooze")),
              ElevatedButton(
                  onPressed: () async {
                    await Alarm.stop(widget.alarmSettings.id);
                    Navigator.pop(context);
                  },
                  child: const Text("Stop")),
            ],
          )
        ],
      ),
    );
  }
}