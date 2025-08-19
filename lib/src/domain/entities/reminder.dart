class Reminder {
  final int? id;
  final String title;
  final String body;
  final DateTime dateTime;

  Reminder({
    this.id,
    required this.title,
    required this.body,
    required this.dateTime,
  });
}