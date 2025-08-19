import '../repositories/reminder_repository.dart';
import '../entities/reminder.dart';

class GetRemindersUseCase {
  final ReminderRepository repository;

  GetRemindersUseCase(this.repository);

  Future<List<Reminder>> execute() {
    return repository.getReminders();
  }
}