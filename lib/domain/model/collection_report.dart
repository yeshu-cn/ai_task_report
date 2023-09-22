class CollectionReport {
  final int id;
  final String name;
  final int createTime;
  final String content;
  final int collectionId;

  const CollectionReport({
    required this.id,
    required this.name,
    required this.createTime,
    required this.content,
    required this.collectionId,
  });

  // from json
  CollectionReport.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createTime = json['createTime'],
        content = json['content'],
        collectionId = json['collectionId'];

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createTime': createTime,
      'content': content,
      'collectionId': collectionId,
    };
  }
}