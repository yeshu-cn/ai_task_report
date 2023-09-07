import 'package:flutter/material.dart';

class InputCollectionView extends StatefulWidget {
  const InputCollectionView({super.key});

  @override
  State<InputCollectionView> createState() => _InputCollectionViewState();
}

class _InputCollectionViewState extends State<InputCollectionView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // cancel
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            const Spacer(),
            // title add collection
            const Text('添加清单'),
            // confirm
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context, _controller.text.trim());
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                // icon folder
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.folder),
                ),
                // text field
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '名称',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
