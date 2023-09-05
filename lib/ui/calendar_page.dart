import 'package:ai_todo/ui/add_task_page.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("日历"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // to AddTaskPage
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTaskPage()));
        },
        tooltip: '添加任务',
        child: const Icon(Icons.add),
      ),
    );
  }
}
