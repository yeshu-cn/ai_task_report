import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/collection_report.dart';

abstract class ReportService {
  Future<CollectionReport> createCollectionReport(Collection collection);

  // get collection report by collection id
  Future<CollectionReport?> getCollectionReport(int collectionId);

  // get all collection reports
  Future<List<CollectionReport>> getAllReports();
}