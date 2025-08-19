import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/reminder_provider.dart';
import 'add_reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    checkAndroidNotificationPermission();
    checkAndroidScheduleExactAlarmPermission();
    Provider.of<ReminderProvider>(context, listen: false).loadReminders();
    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      showRingDialog(alarmSettings);
    });
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting notification permission...');
      }
      final res = await Permission.notification.request();
      if (kDebugMode) {
        print('Notification permission ${res.isGranted ? '' : 'not '}granted');
      }
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) {
      print('Schedule exact alarm permission: $status.');
    }
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting schedule exact alarm permission...');
      }
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }
    }
  }

  void showRingDialog(AlarmSettings alarmSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alarmSettings.notificationSettings.title ?? 'Alarm'),
        content: Text(alarmSettings.notificationSettings.body ?? 'Wake up!'),
        actions: [
          TextButton(
            onPressed: () async {
              final now = DateTime.now();
              final newDate = now.add(const Duration(minutes: 5));
              await Alarm.set(
                alarmSettings: alarmSettings.copyWith(dateTime: newDate),
              );
              if (context.mounted) Navigator.pop(context);
              Provider.of<ReminderProvider>(context, listen: false).loadReminders();
            },
            child: const Text('Snooze'),
          ),
          TextButton(
            onPressed: () async {
              await Alarm.stop(alarmSettings.id);
              if (context.mounted) Navigator.pop(context);
              Provider.of<ReminderProvider>(context, listen: false).loadReminders();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: reminderProvider.reminders.isEmpty
          ? const Center(child: Text('No alarms set'))
          : ListView.builder(
              itemCount: reminderProvider.reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminderProvider.reminders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(reminder.title),
                    subtitle: Text(reminder.body),
                    trailing: Text(
                      reminder.dateTime.toString().substring(0, 19),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReminderScreen()),
          ).then((_) {
            reminderProvider.loadReminders();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}