import 'package:ai_todo/domain/model/task.dart';

abstract class TaskService {
  Future<Task?> getTask(int id);

  Future<List<Task>> getTasksByCollectionId(int collectionId);

  Future<Task> createTask({
    required String title,
    required int collectionId,
    String description = '',
    List<String> tag = const [],
    TaskPriority priority = TaskPriority.none,
  });

  Future<void> updateTask(Task task);

  Future<void> deleteTask(int id);
}
