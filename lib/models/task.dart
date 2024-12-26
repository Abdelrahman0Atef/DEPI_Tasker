enum Priority { low, medium, high }

class Task {
  final String title;
  DateTime? dueDate;
  bool isCompleted;
  Priority priority;

  Task({
    required this.title,
    this.dueDate,
    this.isCompleted = false,
    this.priority = Priority.medium,
  });
}