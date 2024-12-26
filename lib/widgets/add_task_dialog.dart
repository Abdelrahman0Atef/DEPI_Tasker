import 'package:flutter/material.dart';
import 'package:tasker/models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _dueDate;
  Priority _selectedPriority = Priority.medium;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
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
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      _dueDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      Navigator.of(context).pop(
                        Task(
                          title: _titleController.text,
                          dueDate: _dueDate,
                          priority: _selectedPriority,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
