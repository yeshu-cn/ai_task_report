import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报告'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('报告'),
      ),
    );
  }
}
