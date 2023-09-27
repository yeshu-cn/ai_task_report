import 'package:ai_todo/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _nickname = 'nickname';
  var _avatar = 'assets/images/emoji/0.svg';
  String? _openaiKey;
  var _openaiBaseUrl = 'https://api.openai.com';

  _loadData() async {
    _nickname = await SpUtils.getNickname() ?? 'nickname';
    _avatar = await SpUtils.getAvatar() ?? 'assets/images/avatar.jpg';
    _openaiKey = await SpUtils.getOpenAiKey();
    _openaiBaseUrl = await SpUtils.getOpenAiBaseUrl() ?? 'https://api.openai.com';
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

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
            // avatar
            ListTile(
              title: const Text('Avatar'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    child: SvgPicture.asset(_avatar),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {
                _setAvatar();
              },
            ),
            // nickname
            ListTile(
              title: const Text('Nickname'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_nickname),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {
                _setNickname();
              },
            ),
            // set api key
            ListTile(
              title: const Text('Set OpenAi Key'),
              subtitle: Text(_getOpenAiKey()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _setOpenAiKey();
              },
            ),
            // set api base url
            ListTile(
              title: const Text('Set OpenAi Base URL'),
              subtitle: Text(_openaiBaseUrl),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _setOpenAiBaseUrl();
              },
            ),
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

  void _setOpenAiKey() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set OpenAi Key'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'OpenAi Key',
            ),
            onChanged: (value) {
              _openaiKey = value.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SpUtils.setOpenAiKey(_openaiKey!);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _setOpenAiBaseUrl() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set OpenAi Base URL'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'OpenAi Base URL',
            ),
            onChanged: (value) {
              _openaiBaseUrl = value.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SpUtils.setOpenAiBaseUrl(_openaiBaseUrl);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _setNickname() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Nickname'),
          content: TextField(
            decoration: InputDecoration(
              hintText: _nickname,
            ),
            onChanged: (value) {
              _nickname = value.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SpUtils.setNickname(_nickname);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _setAvatar() {
    // show bottom sheet with emoji avatar grid list
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                child: CircleAvatar(child: SvgPicture.asset('assets/images/emoji/$index.svg')),
                onTap: () {
                  _avatar = 'assets/images/emoji/$index.svg';
                  SpUtils.setAvatar(_avatar);
                  setState(() {});
                  Navigator.of(context).pop();
                },
              );
            },
            itemCount: 11,
          ),
        );
      },
    );
  }

  String _getOpenAiKey() {
    if (null == _openaiKey) {
      return 'Not Set';
    } else {
      // replace others with *, only show last 4 chars, like: ******1234, keep the length
      var length = _openaiKey!.length;
      var last4 = _openaiKey!.substring(length - 4, length);
      var others = '';
      for (var i = 0; i < length - 4; i++) {
        others += '*';
      }
      return '$others$last4';
    }
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
