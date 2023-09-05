import 'package:ai_todo/ui/add_task_page.dart';
import 'package:ai_todo/ui/month_report_page.dart';
import 'package:flutter/material.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('清单'),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('今日'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('收件箱'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('清单'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // to AddTaskPage
          showAddTaskInputArea();
        },
        tooltip: '添加任务',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddTaskInputArea() {
    TextEditingController controller = TextEditingController();
    // show a input up of keyboard
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  // input area
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '输入任务',
                      ),
                    ),
                  ),
                  // more icon
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTaskPage()));
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              Row(
                children: [
                  // tag icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tag),
                  ),
                  const Spacer(),
                  // send icon
                  IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
