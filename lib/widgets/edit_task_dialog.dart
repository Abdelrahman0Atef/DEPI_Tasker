import 'package:flutter/material.dart';
import 'package:tasker/models/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _dueDate;
  Priority _selectedPriority = Priority.medium;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _dueDate = widget.task.dueDate;
    _selectedPriority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<Priority>(
              value: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              items: Priority.values.map((Priority priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_dueDate == null) {
                    // If no due date is selected, keep the existing due date
                    _dueDate = widget.task.dueDate;
                  }

                  Navigator.of(context).pop(
                    Task(
                      title: _titleController.text,
                      dueDate: _dueDate,
                      priority: _selectedPriority,
                      isCompleted: widget.task.isCompleted,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
                  );

                  if (pickedTime != null) {
                    _dueDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    setState(() {});
                  }
                }
              },
              child: const Text('Edit Due Date'),
            ),
          ],
        ),
      ),
    );
  }
}