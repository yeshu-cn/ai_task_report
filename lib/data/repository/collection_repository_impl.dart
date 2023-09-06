import 'package:ai_todo/data/repository/db_helper.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/repository/collection_repository.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final DbHelper _dbHelper;

  CollectionRepositoryImpl(this._dbHelper);

  @override
  Future<Collection> createCollection(String name) async {
    var id =  await _dbHelper.insertCollection(name);
    return Collection(id: id, name: name);
  }

  @override
  Future<void> deleteCollection(int id) async {
    await _dbHelper.deleteCollection(id);
  }

  @override
  Future<List<Collection>> getCollections() async {
    return await _dbHelper.getCollection();
  }

  @override
  Future<void> updateCollection(Collection collection) async {
    await _dbHelper.updateCollection(collection.id, collection.name);
  }

  @override
  Future<Collection?> getCollectionByName(String name) async {
    return await _dbHelper.getCollectionByName(name);
  }

  

}