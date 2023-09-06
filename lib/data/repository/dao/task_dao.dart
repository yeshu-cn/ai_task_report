import 'package:ai_todo/domain/model/task.dart';

class TaskDao {
  int? id;
  String title;
  String description;
  int createTime;
  List<String> tags;
  TaskPriority priority = TaskPriority.none;
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
  });

  // from json
  TaskDao.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        createTime = json['createTime'],
        tags = json['tags'],
        isDone = json['isDone'],
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
      'collectionId': collectionId,
    };
  }

}
