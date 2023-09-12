import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/service/task_service.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final Collection collection;

  const AddTaskPage({super.key, this.task, required this.collection});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  var _isDone = false;

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _isDone = widget.task!.isDone;
    }

    _descController.addListener(() {
      if (_descController.text.isEmpty && !_titleFocusNode.hasFocus) {
        _titleFocusNode.requestFocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    _descFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // handle back button

    return WillPopScope(
      onWillPop: () {
        if (widget.task == null) {
          _onCreateTask();
        } else {
          _onUpdateTask();
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.collection.name),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // checkbox
                  Checkbox(
                    value: _isDone,
                    onChanged: (value) {
                      setState(() {
                        _isDone = value!;
                      });
                    },
                  ),
                  const Spacer(),
                  const Text('日期'),
                  const Spacer(),
                  // icon flag
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.flag),
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  maxLines: 1,
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  decoration: const InputDecoration(
                    hintText: '标题',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(fontSize: 20),
                  onEditingComplete: () {
                    _descFocusNode.requestFocus();
                  },
                ),
                // desc
                TextField(
                  controller: _descController,
                  focusNode: _descFocusNode,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '描述',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ],
            )),
            Row(
              children: [
                // flag icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tag),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onCreateTask() async {
    var title = _titleController.text.trim();
    var desc = _descController.text.trim();
    await getIt<TaskService>().createTask(
      title: title,
      collectionId: widget.collection.id,
      description: desc,
      isDone: _isDone,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  _onUpdateTask() async {
    if (widget.task == null) {
      return;
    }

    var updatedTask = widget.task!.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      isDone: _isDone,
    );
    await getIt<TaskService>().updateTask(updatedTask);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
