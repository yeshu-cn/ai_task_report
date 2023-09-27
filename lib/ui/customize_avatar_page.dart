import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiController.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'package:get/get.dart';

class CustomizeAvatarPage extends StatefulWidget {
  const CustomizeAvatarPage({super.key});

  @override
  State<CustomizeAvatarPage> createState() => _CustomizeAvatarPageState();
}

class _CustomizeAvatarPageState extends State<CustomizeAvatarPage> {
  FluttermojiFunctions _fluttermojiFunctions = FluttermojiFunctions();

  _loadData() async {
    final encoded =
        await _fluttermojiFunctions.encodeMySVGtoString();
    print(encoded);
    _fluttermojiFunctions.decodeFluttermojifromString(encoded);
  }
  @override
  void initState() {
    Get.put(FluttermojiController());
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customize Avatar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ));
  }
}
