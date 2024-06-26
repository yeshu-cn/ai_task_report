import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/model/result.dart';

abstract class ReportService {
  Future<Result<CollectionReport>> createCollectionReport(Collection collection);

  // get collection report by collection id
  Future<CollectionReport?> getCollectionReport(int collectionId);

  // get all collection reports
  Future<List<CollectionReport>> getAllReports();

  // get report by id
  Future<CollectionReport?> getReportById(int id);

  // delete report by id
  Future<void> deleteReportById(int id);
}