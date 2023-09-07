import 'dart:convert';

import 'package:ai_todo/domain/model/task.dart';

class TaskDao {
  int? id;
  String title;
  String description;
  int createTime;
  String tags;
  String priority;
  int collectionId;
  bool isDone;
  int taskOrder;

  TaskDao({
    required this.collectionId,
    required this.title,
    required this.description,
    required this.createTime,
    required this.tags,
    required this.isDone,
    required this.priority,
    required this.taskOrder,
    this.id,
  });

  // from json
  TaskDao.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        createTime = json['createTime'],
        tags = json['tags'],
        isDone = json['isDone'] == 1,
        priority = json['priority'],
        taskOrder = json['taskOrder'],
        collectionId = json['collectionId'];

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createTime': createTime,
      'tags': tags,
      'isDone': isDone,
      'priority': priority,
      'taskOrder': taskOrder,
      'collectionId': collectionId,
    };
  }


}
