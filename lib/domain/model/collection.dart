import 'package:ai_todo/domain/model/task.dart';

class Collection {
  final String id;
  final String name;
  final List<Task> tasks;

  const Collection({
    required this.id,
    required this.name,
    required this.tasks,
  });
}