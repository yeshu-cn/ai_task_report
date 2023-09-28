import 'package:ai_todo/utils/sp_utils.dart';

Future<bool> isApiKeySet() async {
  var apiKey = await SpUtils.getOpenAiKey();
  return apiKey != null && apiKey.isNotEmpty;
}
