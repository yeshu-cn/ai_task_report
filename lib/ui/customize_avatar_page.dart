import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';

class CustomizeAvatarPage extends StatefulWidget {
  const CustomizeAvatarPage({super.key});

  @override
  State<CustomizeAvatarPage> createState() => _CustomizeAvatarPageState();
}

class _CustomizeAvatarPageState extends State<CustomizeAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Avatar'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FluttermojiSaveWidget(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'avatar',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FluttermojiCircleAvatar(
                    radius: 100,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FluttermojiCustomizer(
                autosave: false,
                theme: FluttermojiThemeData(boxDecoration: const BoxDecoration(boxShadow: [BoxShadow()])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
