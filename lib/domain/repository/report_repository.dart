import 'package:ai_todo/domain/model/collection_report.dart';

abstract class ReportRepository {
  // add report
  Future<CollectionReport> addReport({
    required int collectionId,
    required String name,
    required String content,
    required int createTime,
  });

  // get report
  Future<CollectionReport?> getReport(int id);

  // get report by collectionId
  Future<CollectionReport?> getReportByCollectionId(int collectionId);

  // update report
  Future<void> updateReport(CollectionReport report);

  // delete report
  Future<void> deleteReport(int id);

  // delete report by collectionId
  Future<bool> deleteReportByCollectionId(int collectionId);

  // get all reports
  Future<List<CollectionReport>> getAllReports();
}