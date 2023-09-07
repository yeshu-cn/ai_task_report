import 'package:ai_todo/data/repository/dao/task_dao.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:flutter/cupertino.dart';
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
    debugPrint("create database: $version");
    // create table task
    await db.execute('''
          CREATE TABLE task (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            createTime INTEGER NOT NULL,
            tags TEXT NOT NULL,
            priority TEXT NOT NULL,
            collectionId INTEGER NOT NULL,
            isDone INTEGER NOT NULL,
            taskOrder INTEGER NOT NULL
          )
          ''');

    // create table collection
    await db.execute('''
          CREATE TABLE collection (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
          ''');

    // insert inbox collection
    await db.insert('collection', {'name': 'inbox'});
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
    // order by order
    var data = await db.query('task', where: 'collectionId = ?', whereArgs: [collectionId], orderBy: 'taskOrder ASC');
    return data.map((e) => TaskDao.fromJson(e)).toList();
  }

  // get max order in collection task list
  Future<int> getMaxTaskOrderInCollection(int collectionId) async {
    Database db = await createDatabase();
    var data = await db.rawQuery('SELECT MAX(`taskOrder`) FROM task WHERE collectionId = ?', [collectionId]);
    if (data.isEmpty) {
      return 0;
    }
    int? value = data.first.values.first as int?;
    return value ?? 0;
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

  // get collection by name
  Future<Collection?> getCollectionByName(String name) async {
    Database db = await createDatabase();
    var data = await db.query('collection', where: 'name = ?', whereArgs: [name]);
    if (data.isEmpty) {
      return null;
    } else {
      return Collection.fromJson(data.first);
    }
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
