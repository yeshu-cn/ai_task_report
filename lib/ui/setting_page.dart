import 'package:ai_todo/ui/customize_avatar_page.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

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
    _avatar = await SpUtils.getAvatar() ?? 'assets/images/emoji/0.svg';
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
            Hero(
              tag: 'avatar',
              child: GestureDetector(
                child: FluttermojiCircleAvatar(
                  radius: 50,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomizeAvatarPage()));
                },
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              child: Text(_nickname, style: const TextStyle(fontSize: 16),),
              onTap: () {
                _setNickname();
              },
            ),
            const SizedBox(height: 10,),
            // avatar
            // ListTile(
            //   title: const Text('Avatar'),
            //   trailing: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       CircleAvatar(
            //         child: SvgPicture.asset(_avatar),
            //       ),
            //       const Icon(Icons.chevron_right),
            //     ],
            //   ),
            //   onTap: () {
            //     // _setAvatar();
            //   },
            // ),
            // set api key
            ListTile(
              title: const Text('Set OpenAi Key'),
              subtitle: Text(_getOpenAiKey(), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                OpenAI.apiKey = _openaiKey!;
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
    var controller = TextEditingController(text: "https://");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set OpenAi Base URL'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'OpenAi Base URL',
            ),
            controller: controller,
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
                OpenAI.baseUrl = _openaiBaseUrl;
                SpUtils.setOpenAiBaseUrl(_openaiBaseUrl);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    ).then((value) => controller.dispose());
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
    if (null == _openaiKey || _openaiKey!.isEmpty) {
      return 'Not Set';
    } else {
      // replace others with *, only show last 4 chars, like: ******1234, keep the length
      // var length = _openaiKey!.length;
      // var last4 = _openaiKey!.substring(length - 4, length);
      // var others = '';
      // for (var i = 0; i < length - 4; i++) {
      //   others += '*';
      // }
      // return '$others$last4';
      return _openaiKey!;
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
