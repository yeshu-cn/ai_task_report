import 'package:ai_todo/domain/model/collection.dart';

abstract class CollectionRepository {
  Future<List<Collection>> getCollections();

  Future<Collection> createCollection(String name);

  Future<void> updateCollection(Collection collection);

  Future<void> deleteCollection(int id);

  Future<Collection?> getCollectionByName(String name);
}
