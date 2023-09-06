import 'package:ai_todo/data/repository/dao/task_dao.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database? _db;

  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db!;
    }
    String path = join(await getDatabasesPath(), 'todo.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE task (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            createTime INTEGER NOT NULL,
            tags TEXT NOT NULL,
            priority INTEGER NOT NULL,
            collectionId INTEGER NOT NULL,
            isDone INTEGER NOT NULL
          )
          ''');

    // create table collection
    await db.execute('''
          CREATE TABLE collection (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertTask(TaskDao task) async {
    Database db = await createDatabase();
    return await db.insert('task', task.toJson());
  }

  // get task by id
  Future<TaskDao?> getTask(int id) async {
    Database db = await createDatabase();
    List<Map<String, dynamic>> data = await db.query('task', where: 'id = ?', whereArgs: [id]);
    if (data.isEmpty) {
      return null;
    } else {
      return TaskDao.fromJson(data.first);
    }
  }

  Future<int> updateTask(TaskDao task) async {
    Database db = await createDatabase();
    return await db.update('task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await createDatabase();
    return await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TaskDao>> getTaskByCollectionId(int collectionId) async {
    Database db = await createDatabase();
    var data = await db.query('task', where: 'collectionId = ?', whereArgs: [collectionId]);
    return data.map((e) => TaskDao.fromJson(e)).toList();
  }


  Future<int> insertCollection(String name) async {
    Database db = await createDatabase();
    return await db.insert('collection', {'name': name});
  }

  Future<List<Collection>> getCollection() async {
    Database db = await createDatabase();
    var data = await db.query('collection');
    return data.map((e) => Collection.fromJson(e)).toList();
  }

  Future<int> deleteCollection(int id) async {
    Database db = await createDatabase();
    return await db.delete('collection', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCollection(int id, String name) async {
    Database db = await createDatabase();
    return await db.update('collection', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }
}
