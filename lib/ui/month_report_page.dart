import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/service/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MonthReportPage extends StatefulWidget {
  final Collection collection;

  const MonthReportPage({super.key, required this.collection});

  @override
  State<MonthReportPage> createState() => _MonthReportPageState();
}

class _MonthReportPageState extends State<MonthReportPage> {
  String _markdownData = '';

  void _loadMarkdownData() async {
    var report = await getIt.get<ReportService>().getCollectionReport(widget.collection.id);
    report ??= await getIt.get<ReportService>().createCollectionReport(widget.collection);
    _markdownData = report.content;
    setState(() {});
  }

  void _regenerateReport() async {
    _markdownData = '';
    setState(() {});
    var report = await getIt.get<ReportService>().createCollectionReport(widget.collection);
    _markdownData = report.content;
    setState(() {});
  }

  @override
  void initState() {
    _loadMarkdownData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("月报"),
        actions: [
          // regenerating report
          IconButton(
            onPressed: () async {
              _regenerateReport();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _markdownData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: MarkdownBody(data: _markdownData),
              ),
            ),
    );
  }
}
