import 'package:flutter/material.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/get_reminders_usecase.dart';
import '../../domain/usecases/set_reminder_usecase.dart';
import 'package:alarm/alarm.dart';

class ReminderProvider extends ChangeNotifier {
  final GetRemindersUseCase getRemindersUseCase;
  final SetReminderUseCase setReminderUseCase;

  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  ReminderProvider({
    required this.getRemindersUseCase,
    required this.setReminderUseCase,
  });

  Future<void> loadReminders() async {
    _reminders = await getRemindersUseCase.execute();
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    await setReminderUseCase.execute(reminder);
    await loadReminders();
  }

  Future<void> updateReminder(Reminder updatedReminder) async {
    if (updatedReminder.id != null) {
      await Alarm.stop(updatedReminder.id!);
    }
    await setReminderUseCase.execute(updatedReminder);
    await loadReminders();
  }

  Future<void> deleteReminder(int id) async {
    await Alarm.stop(id);
    await loadReminders();
  }
}