import 'package:alarm/alarm.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../models/reminder_mapper.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  @override
  Future<void> setReminder(Reminder reminder) async {
    int id = reminder.id ?? DateTime.now().millisecondsSinceEpoch % 1000000;
    final updatedReminder = Reminder(
      id: id,
      title: reminder.title,
      body: reminder.body,
      dateTime: reminder.dateTime,
    );
    final settings = updatedReminder.toAlarmSettings();
    await Alarm.set(alarmSettings: settings);
  }

  @override
  Future<List<Reminder>> getReminders() async {
    final alarms = await Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    return alarms.map((settings) => fromAlarmSettings(settings)).toList();
  }
}