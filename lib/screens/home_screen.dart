import 'package:flutter/material.dart';
import 'package:tasker/models/task.dart';
import 'package:tasker/widgets/add_task_dialog.dart';
import 'package:tasker/widgets/edit_task_dialog.dart';
import 'package:tasker/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: _isDarkMode ? Colors.grey[900] : Colors.blue,
        scaffoldBackgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
        textTheme: _isDarkMode
            ? ThemeData.dark().textTheme
            : ThemeData.light().textTheme,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tasker'),
          leading: IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Add Your Tasks',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const AddTaskDialog(),
                  ).then((value) {
                    if (value != null && value is Task) {
                      setState(() {
                        _tasks.add(value);
                      });
                    }
                  });
                },
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: TaskList(
                  tasks: _tasks,
                  onDelete: (Task task) {
                    setState(() {
                      _tasks.remove(task);
                    });
                  },
                  onToggleCompletion: (Task task, bool isCompleted) {
                    setState(() {
                      task.isCompleted = isCompleted;
                    });
                  },
                  onEdit: (Task task) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => EditTaskDialog(task: task),
                    ).then((value) {
                      if (value != null && value is Task) {
                        setState(() {
                          int index = _tasks.indexOf(task);
                          _tasks[index] = value;
                        });
                      }
                    });
                  },
                  isDarkMode: _isDarkMode, // Pass isDarkMode to TaskList
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}