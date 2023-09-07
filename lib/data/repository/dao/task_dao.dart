import 'dart:convert';
import 'dart:ffi';

import 'package:ai_todo/domain/model/task.dart';

class TaskDao {
  int? id;
  String title;
  String description;
  int createTime;
  List<String> tags;
  TaskPriority priority;
  int collectionId;
  bool isDone;

  TaskDao({
    required this.collectionId,
    required this.title,
    required this.description,
    required this.createTime,
    required this.tags,
    required this.isDone,
    this.id,
    this.priority = TaskPriority.none,
  });

  // from json
  factory TaskDao.fromJson(Map<String, dynamic> json) {
    return TaskDao(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createTime: json['createTime'],
      tags: jsonDecode(json['tags']) as List<String>,
      isDone: json['isDone'],
      priority: TaskPriority.values.byName(json['priority']),
      collectionId: json['collectionId'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createTime': createTime,
      'tags': jsonEncode(tags),
      'isDone': isDone,
      'priority': priority.toString(),
      'collectionId': collectionId,
    };
  }

}
