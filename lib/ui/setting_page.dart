import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SettingPage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('About'),
              onTap: () {
                showAbout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'AI Task Report ',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.rocket),
      children: [
        const Text('AI Task Report '),
      ],
    );
  }
}
