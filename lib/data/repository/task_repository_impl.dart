import 'package:ai_todo/data/repository/db_helper.dart';
import 'package:ai_todo/data/repository/dao/task_dao.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:ai_todo/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DbHelper _dbHelper;

  TaskRepositoryImpl(this._dbHelper);

  @override
  Future<Task> addTask({
    required String title,
    required int collectionId,
    required String description,
    required List<String> tags,
    required TaskPriority priority,
    required int createTime,
    required bool isDone,
  }) async {
    var taskDao = TaskDao(collectionId: collectionId, title: title, description: description, createTime: createTime, tags: tags, isDone: isDone);
    var id =  await _dbHelper.insertTask(taskDao);
    taskDao.id = id;
    return _toTask(taskDao);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
  }

  @override
  Future<List<Task>> fetchTasks(int collectionId) async {
    var data = await _dbHelper.getTaskByCollectionId(collectionId);
    return data.map((e) {
      return _toTask(e);
    }).toList();
  }

  @override
  Future<Task?> getTask(int id) async {
    var taskDao =  await _dbHelper.getTask(id);
    if (null == taskDao) {
      return null;
    } else {
      return _toTask(taskDao);
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(_toTaskDao(task));
  }

  Task _toTask(TaskDao taskDao) {
    return Task.fromJson(taskDao.toJson());
  }

  TaskDao _toTaskDao(Task task) {
    return TaskDao.fromJson(task.toJson());
  }
}
