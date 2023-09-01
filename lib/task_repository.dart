import 'package:ai_todo/task.dart';

abstract class TaskRepository {
  // add task
  Future<void> addNewTask(Task task);

  // get all tasks
  Future<List<Task>> getAllTasks();

  // update task
  Future<void> updateTask(Task task);

  // delete task
  Future<void> deleteTask(Task task);
}
