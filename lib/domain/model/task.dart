class Task {
  final int id;
  String title;
  String description;
  final int createTime;
  List<String> tags;
  TaskPriority priority = TaskPriority.none;
  final int collectionId;
  bool isDone;

  Task({
    required this.collectionId,
    required this.id,
    required this.title,
    required this.description,
    required this.createTime,
    required this.tags,
    required this.isDone,
  });

  // from json
  Task.fromJson(Map<String, dynamic> json)
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

enum TaskPriority {
  low,
  medium,
  high,
  none,
}
