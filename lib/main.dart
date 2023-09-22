import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/ui/home_page.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

void main() {
  OpenAI.apiKey = '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';
  OpenAI.baseUrl = 'https://openai.yeshu.fun';
  setupDi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

