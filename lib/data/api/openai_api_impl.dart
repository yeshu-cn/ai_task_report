import 'package:ai_todo/data/api/openai_api.dart';
import 'package:dart_openai/dart_openai.dart';

class OpenAiApiImpl implements OpenAiApi {
  @override
  Future<String> createCollectionReport(String content) async {
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: content,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    return chatCompletion.choices.first.message.content;
  }

}