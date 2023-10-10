import 'dart:io';

import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/ui/home_page.dart';
import 'package:ai_todo/ui/desktop_home_page.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SpUtils.setOpenAiKey("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");
  setupDi();
  initOpenAi();
  if (Platform.isMacOS) {
    // Must add this line.
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });


    runApp(const MacApp());
  } else {
    runApp(const MobileApp());
  }
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

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

class MacApp extends StatelessWidget {
  const MacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppFlowyEditorLocalizations.delegate,
      ],
      title: 'AI Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DesktopHomePage(),
    );
  }
}
