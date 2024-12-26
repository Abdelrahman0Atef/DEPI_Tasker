import 'package:flutter/material.dart';
import 'package:tasker/screens/home_screen.dart';

void main() {
  runApp(const TaskerApp());
}

class TaskerApp extends StatelessWidget {
  const TaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system, // Use system theme mode by default
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}