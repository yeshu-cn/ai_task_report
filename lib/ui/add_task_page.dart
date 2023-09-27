import 'dart:convert';

import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/service/task_service.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final Collection collection;

  const AddTaskPage({super.key, this.task, required this.collection});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  var _isDone = false;
  var _priority = TaskPriority.none;

  var _editorState = EditorState.blank(withInitialText: true);
  late final EditorScrollController _editorScrollController;
  late EditorStyle _editorStyle;
  late Map<String, BlockComponentBuilder> _blockComponentBuilders;

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _editorState = EditorState(
        document: markdownToDocument(widget.task!.description),
      );
      if (widget.task!.description.isNotEmpty) {
        _editorState = EditorState(
          document: Document.fromJson(
            Map<String, Object>.from(
              json.decode(jsonEncode(markdownToDocument(widget.task!.description).toJson())),
            ),
          ),
        );
      }
      _isDone = widget.task!.isDone;
      _priority = widget.task!.priority;
    }

    // listen editor state
    _editorState.transactionStream.listen((event) {
      if (event.$1 == TransactionTime.after) {
        // update editor state
        var content = documentToMarkdown(_editorState.document);
        if (content.isEmpty && !_titleFocusNode.hasFocus) {
          _titleFocusNode.requestFocus();
        }
      }
    });

    _editorScrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: false,
    );
    _editorStyle = _buildMobileEditorStyle();
    _blockComponentBuilders = _buildBlockComponentBuilders();

    super.initState();
  }

  @override
  void dispose() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  PopupMenuButton(
                      surfaceTintColor: Colors.white,
                      icon: Icon(
                        Icons.flag,
                        color: _getPriorityColor(_priority),
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {},
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '高优先级',
                                  style: TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                // checkbox
                                CupertinoCheckbox(
                                  value: _priority == TaskPriority.high,
                                  onChanged: (value) {
                                    setState(() {
                                      _priority = TaskPriority.high;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  shape: const CircleBorder(),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.orange,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '中优先级',
                                  style: TextStyle(color: Colors.orange),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CupertinoCheckbox(
                                  value: _priority == TaskPriority.medium,
                                  onChanged: (value) {
                                    setState(() {
                                      _priority = TaskPriority.medium;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  shape: const CircleBorder(),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '低优先级',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CupertinoCheckbox(
                                  value: _priority == TaskPriority.low,
                                  onChanged: (value) {
                                    setState(() {
                                      _priority = TaskPriority.low;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  shape: const CircleBorder(),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '无优先级',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CupertinoCheckbox(
                                  value: _priority == TaskPriority.none,
                                  onChanged: (value) {
                                    setState(() {
                                      _priority = TaskPriority.none;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  shape: const CircleBorder(),
                                ),
                              ],
                            ),
                          ),
                        ];
                      }),
                ],
              ),
            ),
            // title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text('标题', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            TextField(
              maxLines: 1,
              controller: _titleController,
              focusNode: _titleFocusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type something...',
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(14),
              ),
              style: const TextStyle(fontSize: 18),
              onSubmitted: (value) {
                _descFocusNode.requestFocus();
                debugPrint('onSubmitted');
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text('描述', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            Expanded(
                child: AppFlowyEditor(
              focusNode: _descFocusNode,
              editorStyle: _editorStyle,
              editorState: _editorState,
              editorScrollController: _editorScrollController,
              blockComponentBuilders: _blockComponentBuilders,
            )),
            MobileToolbar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              editorState: _editorState,
              toolbarItems: [
                // textDecorationMobileToolbarItem,
                // buildTextAndBackgroundColorMobileToolbarItem(),
                // headingMobileToolbarItem,
                todoListMobileToolbarItem,
                listMobileToolbarItem,
                // linkMobileToolbarItem,
                // quoteMobileToolbarItem,
                // dividerMobileToolbarItem,
                // codeMobileToolbarItem,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  _onCreateTask() async {
    var title = _titleController.text.trim();
    var desc = documentToMarkdown(_editorState.document);
    await getIt<TaskService>().createTask(
      title: title,
      collectionId: widget.collection.id,
      description: desc,
      isDone: _isDone,
      priority: _priority,
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
      description: documentToMarkdown(_editorState.document),
      isDone: _isDone,
      priority: _priority,
    );
    await getIt<TaskService>().updateTask(updatedTask);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildMobileEditorStyle() {
    return EditorStyle.mobile(
      cursorColor: Colors.blue,
      selectionColor: Colors.blue.shade200,
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        code: GoogleFonts.badScript(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // customize the heading block component
    final levelToFontSize = [
      24.0,
      22.0,
      20.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => GoogleFonts.poppins(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
    map[ParagraphBlockKeys.type] = TextBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
      ),
    );
    return map;
  }
}
