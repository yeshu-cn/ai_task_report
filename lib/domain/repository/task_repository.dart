import 'package:ai_todo/domain/model/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
}