import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/domain/service/task_service.dart';
import 'package:ai_todo/ui/add_task_page.dart';
import 'package:ai_todo/ui/month_report_page.dart';
import 'package:ai_todo/ui/widget/drawer_view.dart';
import 'package:ai_todo/ui/widget/input_task_view.dart';
import 'package:ai_todo/utils/utils.dart';
import 'package:flutter/material.dart';

import '../domain/model/collection.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> with AutomaticKeepAliveClientMixin {
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
    setState(() {});
  }

  void _loadTasks() async {
    _tasks = await getIt.get<TaskService>().getTasksByCollectionId(_collection!.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _collection == null ? const Text('清单') : Text(_collection!.name),
        actions: [
          IconButton(
            onPressed: () async {
              // to MonthReportPage
              var isSet = await isApiKeySet();
              if (!mounted) {
                return;
              }
              if (!isSet) {
                // show snack bar
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先设置 OpenAI API Key')));
                return;
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MonthReportPage(
                        collection: _collection!,
                      )));
            },
            icon: const Icon(Icons.summarize_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerView(onCollectionSelected: (collection) {
          setState(() {
            _collection = collection;
            _loadTasks();
          });
        }),
      ),
      body: ReorderableListView.builder(
        itemBuilder: (context, index) {
          return _buildItem(_tasks[index], index);
        },
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          moveTaskAndUpdateOrder(oldIndex, newIndex);
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
        return InputTaskView(
          collection: _collection!,
        );
      },
    );
    if (null != title) {
      await getIt.get<TaskService>().createTask(title: title, collectionId: _collection!.id);
      _loadTasks();
    }
  }

  Widget _buildItem(Task task, int index) {
    // swipe to show delete button
    return Dismissible(
      key: Key('${task.id} $index'),
      onDismissed: (direction) async {
        await getIt.get<TaskService>().deleteTask(task.id);
        _loadTasks();
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('确认'),
              content: const Text('确认删除该任务吗？'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('确认'),
                ),
              ],
            );
          },
        );
      },
      child: _buildTaskItem(task),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Checkbox(
              fillColor: MaterialStateProperty.all(getPriorityColor(task.priority)),
              value: task.isDone,
              onChanged: (value) async {
                task.isDone = value!;
                await getIt.get<TaskService>().updateTask(task);
                _loadTasks();
              }),
          Expanded(
              child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title,
                    style: TextStyle(
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                      fontSize: 16,
                    )),
              ],
            ),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddTaskPage(
                        collection: _collection!,
                        task: task,
                      )));
              _loadTasks();
            },
          )),
        ],
      ),
    );
  }

  Future<void> moveTaskAndUpdateOrder(int oldIndex, int newIndex) async {
    // 如果移到列表的末尾，将newIndex设置为最后一个有效索引。
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    Task taskToMove = _tasks[oldIndex];

    // Updating in-memory list
    _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, taskToMove);

    // Now, update the database for each task
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].taskOrder = i;
      await getIt.get<TaskService>().updateTask(_tasks[i]);
    }

    // Now, optionally refresh the UI
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
