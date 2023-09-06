import 'package:ai_todo/domain/model/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(int collectionId);

  Future<Task> addTask({
    required String title,
    required int collectionId,
    required String description,
    required List<String> tags,
    required TaskPriority priority,
    required int createTime,
    required bool isDone,
  });

  // get Task
  Future<Task?> getTask(int id);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(int id);
}
