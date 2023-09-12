import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/repository/task_repository.dart';
import 'package:ai_todo/domain/service/task_service.dart';

class TaskServiceImpl implements TaskService {
  TaskRepository repository;

  TaskServiceImpl(this.repository);

  @override
  Future<Task> createTask({
    required String title,
    required int collectionId,
    bool isDone = false,
    String description = '',
    List<String> tag = const [],
    TaskPriority priority = TaskPriority.none,
  }) {
    return repository.addTask(
      title: title,
      collectionId: collectionId,
      description: description,
      tags: tag,
      priority: priority,
      createTime: DateTime.now().millisecondsSinceEpoch,
      isDone: isDone,
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    return await repository.deleteTask(id);
  }

  @override
  Future<Task?> getTask(int id) async {
    return await repository.getTask(id);
  }

  @override
  Future<void> updateTask(Task task) async {
    return await repository.updateTask(task);
  }

  @override
  Future<List<Task>> getTasksByCollectionId(int collectionId) async {
    return await repository.getTasksByCollectionId(collectionId);
  }
}
