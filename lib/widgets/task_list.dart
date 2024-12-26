import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onDelete;
  final Function(Task, bool) onToggleCompletion;
  final Function(Task) onEdit;
  final bool isDarkMode;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.onEdit,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.title),
          onDismissed: (direction) {
            onDelete(task);
          },
          child: ListTile(
            title: Text(
              task.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.dueDate != null)
                  Text(
                    DateFormat('yyyy-MM-dd').format(task.dueDate!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                Text(
                  task.priority.toString().split('.').last,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    onToggleCompletion(task, value!);
                  },
                  activeColor: Colors.teal,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onEdit(task);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}