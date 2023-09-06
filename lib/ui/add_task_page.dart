import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  var _isCompleted = false;

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("添加任务"),
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
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value!;
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
    );
  }
}
