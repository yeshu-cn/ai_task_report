import 'package:ai_todo/domain/model/collection.dart';

abstract class CollectionService {

  Future<Collection> createCollection(String name);

  Future<void> updateCollection(Collection collection);

  Future<void> deleteCollection(int id);
}