import 'package:ai_todo/data/collection_service_impl.dart';
import 'package:ai_todo/data/repository/collection_repository_impl.dart';
import 'package:ai_todo/data/repository/db_helper.dart';
import 'package:ai_todo/data/repository/task_repository_impl.dart';
import 'package:ai_todo/data/task_service_impl.dart';
import 'package:ai_todo/domain/repository/collection_repository.dart';
import 'package:ai_todo/domain/repository/task_repository.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/domain/service/task_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerFactory<DbHelper>(() => DbHelper());

  getIt.registerFactory<TaskRepository>(() => TaskRepositoryImpl(getIt()));
  getIt.registerFactory<CollectionRepository>(() => CollectionRepositoryImpl(getIt()));

  getIt.registerFactory<TaskService>(() => TaskServiceImpl(getIt()));
  getIt.registerFactory<CollectionService>(() => CollectionServiceImpl(getIt()));
}
