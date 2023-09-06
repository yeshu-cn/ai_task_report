
class Collection {
  final int id;
  final String name;

  const Collection({
    required this.id,
    required this.name,
  });


  // from json
  Collection.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }



}