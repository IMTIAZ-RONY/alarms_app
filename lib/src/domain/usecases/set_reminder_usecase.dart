import '../repositories/reminder_repository.dart';
import '../entities/reminder.dart';

class SetReminderUseCase {
  final ReminderRepository repository;

  SetReminderUseCase(this.repository);

  Future<void> execute(Reminder reminder) {
    return repository.setReminder(reminder);
  }
}