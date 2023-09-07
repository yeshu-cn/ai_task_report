class Task {
  final int id;
  String title;
  String description;
  final int createTime;
  List<String> tags;
  TaskPriority priority;
  final int collectionId;
  bool isDone;
  int taskOrder;

  Task({
    required this.collectionId,
    required this.id,
    required this.title,
    required this.description,
    required this.createTime,
    required this.tags,
    required this.isDone,
    required this.priority,
    required this.taskOrder,
  });

  // from json
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        createTime = json['createTime'],
        tags = json['tags'],
        isDone = json['isDone'],
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
      'collectionId': collectionId,
      'taskOrder': taskOrder,
    };
  }
}

enum TaskPriority {
  low,
  medium,
  high,
  none,
}
