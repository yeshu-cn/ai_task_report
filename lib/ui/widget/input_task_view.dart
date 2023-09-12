import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/ui/add_task_page.dart';
import 'package:flutter/material.dart';

class InputTaskView extends StatefulWidget {
  final Collection collection;
  const InputTaskView({super.key, required this.collection});

  @override
  State<InputTaskView> createState() => _InputTaskViewState();
}

class _InputTaskViewState extends State<InputTaskView> {
  final TextEditingController _textEditingController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _bottomSheetKey = GlobalKey();

  @override
  void initState() {
    _textEditingController.addListener(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _showMenu() async {
    final overlay = Overlay.of(context);

    // Step 1: Insert the menu into the overlay but offscreen.
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: -1000.0, // initially offscreen
        left: 0.0,
        child: _buildPriorityMenu(_menuKey),
      ),
    );
    overlay.insert(_overlayEntry!);

    // Step 3: After layout is done, get height, remove the temp entry and show the actual one.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox menuRenderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
      final double menuHeight = menuRenderBox.size.height;
      _overlayEntry!.remove();

      final RenderBox renderBox = _bottomSheetKey.currentContext!.findRenderObject() as RenderBox;
      final double height = renderBox.size.height;
      final position = MediaQuery.of(context).size.height - height;

      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top: position - menuHeight - 10,
          left: 24,
          child: _buildPriorityMenu(null),
        ),
      );
      overlay.insert(_overlayEntry!);
    });
  }

  Widget _buildPriorityMenu(Key? key) {
    return Material(
      color: Colors.transparent,
      child: Container(
        key: key,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // 四种优先级
            InkWell(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '高优先级',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '中优先级',
                      style: TextStyle(color: Colors.orange),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '低优先级',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '无优先级',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _bottomSheetKey,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '准备做什么?',
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (_overlayEntry != null) {
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTaskPage(collection: widget.collection,)));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (_overlayEntry != null) {
                      _overlayEntry!.remove();
                      _overlayEntry = null;
                    } else {
                      _showMenu();
                    }
                  },
                  icon: const Icon(Icons.tag_outlined)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    if (_overlayEntry != null) {
                      _overlayEntry!.remove();
                      _overlayEntry = null;
                    }

                    Navigator.of(context).pop(_textEditingController.text.trim());
                  },
                  icon: const Icon(Icons.send_outlined)),
            ],
          ),
        ],
      ),
    );
  }
}
