import 'package:ai_todo/domain/model/collection.dart';

abstract class CollectionRepository {
  Future<List<Collection>> getCollections();

  Future<Collection> getCollection(int id);

  Future<Collection> createCollection(Collection collection);

  Future<Collection> updateCollection(Collection collection);

  Future<void> deleteCollection(int id);
}
