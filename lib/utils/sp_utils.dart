import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const String _keyOpenAiKey = 'openai_key';
  static const String _keyOpenAiBaseUrl = 'openai_base_url';
  static const String _keyNickname = 'nickname';
  static const String _keyAvatar = 'avatar';

  // set openai key
  static Future<void> setOpenAiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOpenAiKey, key);
  }

  // get openai key
  static Future<String?> getOpenAiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOpenAiKey);
  }

  // set openai base url
  static Future<void> setOpenAiBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOpenAiBaseUrl, url);
  }

  // get openai base url
  static Future<String?> getOpenAiBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOpenAiBaseUrl);
  }

  // set nickname
  static Future<void> setNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNickname, nickname);
  }

  // get nickname
  static Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNickname);
  }

  // set avatar
  static Future<void> setAvatar(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAvatar, avatar);
  }

  // get avatar
  static Future<String?> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAvatar);
  }
}