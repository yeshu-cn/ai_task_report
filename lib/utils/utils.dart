import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:flutter/material.dart';

Future<bool> isApiKeySet() async {
  var apiKey = await SpUtils.getOpenAiKey();
  return apiKey != null && apiKey.isNotEmpty;
}


Color getPriorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return Colors.red;
    case TaskPriority.medium:
      return Colors.orange;
    case TaskPriority.low:
      return Colors.blue;
    case TaskPriority.none:
      return Colors.grey;
  }
}