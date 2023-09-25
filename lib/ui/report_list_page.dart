import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/domain/service/report_service.dart';
import 'package:ai_todo/ui/month_report_page.dart';
import 'package:ai_todo/ui/report_detail_page.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List<CollectionReport> _list = [];

  _loadData() async {
    _list = await getIt<ReportService>().getAllReports();
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_list[index].name),
            subtitle: Text(_formatTime(_list[index].createTime)),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportDetailPage(
                        reportId: _list[index].id,
                      )));
              _loadData();
            },
          );
        },
        itemCount: _list.length,
      ),
    );
  }

  String _formatTime(int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    return '${date.year}-${date.month}-${date.day}';
  }
}
