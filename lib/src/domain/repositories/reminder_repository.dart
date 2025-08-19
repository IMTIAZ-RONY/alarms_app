import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<void> setReminder(Reminder reminder);
  Future<List<Reminder>> getReminders();
}