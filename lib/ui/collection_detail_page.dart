import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/domain/service/task_service.dart';
import 'package:ai_todo/ui/month_report_page.dart';
import 'package:ai_todo/ui/widget/drawer_view.dart';
import 'package:ai_todo/ui/widget/input_task_view.dart';
import 'package:flutter/material.dart';

import '../domain/model/collection.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  Collection? _collection;
  List<Task> _tasks = [];

  @override
  void initState() {
    _initWithInboxCollection();
    super.initState();
  }

  void _initWithInboxCollection() async {
    _collection = await getIt.get<CollectionService>().getInboxCollection();
    _tasks = await getIt.get<TaskService>().getTasksByCollectionId(_collection!.id);
    setState(() {

    });
  }

  void _loadTasks() async {
    _tasks = await getIt.get<TaskService>().getTasksByCollectionId(_collection!.id);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _collection == null ? const Text('清单') : Text(_collection!.name),
        actions: [
          IconButton(
            onPressed: () {
              // to MonthReportPage
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MonthReportPage()));
            },
            icon: const Icon(Icons.summarize_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerView(onCollectionSelected: (collection) {
          setState(() {
            _collection = collection;
          });
        }),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          var task = _tasks[index];
          return CheckboxListTile(
            value: task.isDone,
            onChanged: (value) async {
              task.isDone = value!;
              await getIt.get<TaskService>().updateTask(task);
              _loadTasks();
            },
            title: Text(task.title),
            subtitle: Text(task.description),
            secondary: IconButton(
              onPressed: () async {
                await getIt.get<TaskService>().deleteTask(task.id);
                _loadTasks();
              },
              icon: const Icon(Icons.delete_outline),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // to AddTaskPage
          _showInputSheet();
        },
        tooltip: '添加任务',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showInputSheet() async {
    // set bottom sheet border corner
    const RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(6),
      ),
    );
    var title = await showModalBottomSheet(
      context: context,
      shape: roundedRectangleBorder,
      builder: (context) {
        return const InputTaskView();
      },
    );
    if (null != title) {
      await getIt.get<TaskService>().createTask(title: title, collectionId: _collection!.id);
      _loadTasks();
    }
  }
}
