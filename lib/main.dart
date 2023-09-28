import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/ui/home_page.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SpUtils.setOpenAiKey("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");
  setupDi();
  initOpenAi();
  runApp(const MyApp());
}

void initOpenAi() async {
  var openAI = await SpUtils.getOpenAiKey();
  var baseUrl = await SpUtils.getOpenAiBaseUrl();
  if (null != openAI) {
    OpenAI.apiKey = openAI;
  }
  if (null != baseUrl) {
    OpenAI.baseUrl = baseUrl;
  }
  OpenAI.showLogs = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppFlowyEditorLocalizations.delegate,
      ],
      title: 'AI Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

