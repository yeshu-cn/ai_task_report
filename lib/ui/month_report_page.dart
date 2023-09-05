import 'package:flutter/material.dart';

class MonthReportPage extends StatefulWidget {
  const MonthReportPage({super.key});

  @override
  State<MonthReportPage> createState() => _MonthReportPageState();
}

class _MonthReportPageState extends State<MonthReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("月报"),
      ),
    );
  }
}
