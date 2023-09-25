import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/service/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReportDetailPage extends StatefulWidget {
  final int reportId;

  const ReportDetailPage({super.key, required this.reportId});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  CollectionReport? _report;

  void _loadData() async {
    _report = await getIt.get<ReportService>().getReportById(widget.reportId);
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
          centerTitle: true,
          title: _report == null ? const Text('Report Detail') : Text(_report!.name),
          actions: [
            // delete report
            IconButton(
              onPressed: () async {
                _deleteReport();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _report == null ? const Center(child: CircularProgressIndicator()) : Markdown(data: _report!.content),
        ));
  }

  Future<bool> _showConfirmDeleteDialog() async {
    var ret = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认删除？'),
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
    return ret ?? false;
  }

  _deleteReport() async {
    var ret = await _showConfirmDeleteDialog();
    if (ret) {
      await getIt.get<ReportService>().deleteReportById(widget.reportId);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }
}
