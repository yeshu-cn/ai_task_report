import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/repository/collection_repository.dart';
import 'package:ai_todo/domain/service/collection_service.dart';

class CollectionServiceImpl implements CollectionService {
  final CollectionRepository _repository;

  CollectionServiceImpl(this._repository);

  @override
  Future<Collection> createCollection(String name) async {
    return await _repository.createCollection(name);
  }

  @override
  Future<void> deleteCollection(int id) async {
    return await _repository.deleteCollection(id);
  }

  @override
  Future<void> updateCollection(Collection collection) async {
    return await _repository.updateCollection(collection);
  }

}