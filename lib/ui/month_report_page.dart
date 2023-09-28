import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/result.dart';
import 'package:ai_todo/domain/service/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../utils/utils.dart';

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

    if (null == report) {
      var result = await getIt.get<ReportService>().createCollectionReport(widget.collection);
      if (result.isSuccess) {
        _markdownData = (result as Success).value.content;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((result as Failure).exception.toString()),
          ),
        );
        _markdownData = 'generate report failed';
      }
    } else {
      _markdownData = report.content;
    }

    setState(() {});
  }

  void _regenerateReport() async {
    _markdownData = '';
    setState(() {});
    var result = await getIt.get<ReportService>().createCollectionReport(widget.collection);
    if (result.isSuccess) {
      _markdownData = (result as Success).value.content;
    } else {
      _markdownData = 'generate report failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((result as Failure).exception.toString()),
        ),
      );
    }
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
              _showConfirmRegenerateReportDialog();
            },
            icon: const Icon(Icons.refresh),
          ),
          // copy report
          IconButton(
            onPressed: () async {
              await _copyToClipboard(_markdownData);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已复制到剪贴板'),
                ),
              );
            },
            icon: const Icon(Icons.copy),
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

  // show confirm regenerate report dialog
  void _showConfirmRegenerateReportDialog() async {
    var isSet = await isApiKeySet();
    if (!isSet && mounted) {
      // show snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先设置 OpenAI API Key'),
        ),
      );
      return;
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认重新生成月报？'),
          content: const Text('重新生成月报会覆盖原有月报内容'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _regenerateReport();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  // copy to clipboard
  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
