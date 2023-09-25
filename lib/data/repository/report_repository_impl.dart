import 'package:ai_todo/data/repository/db_helper.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final DbHelper _dbHelper;

  ReportRepositoryImpl(this._dbHelper);

  @override
  Future<CollectionReport> addReport({
    required int collectionId,
    required String name,
    required String content,
    required int createTime,
  }) async {
    var id =
        await _dbHelper.insertReport(collectionId: collectionId, name: name, content: content, createTime: createTime);
    return CollectionReport(id: id, collectionId: collectionId, name: name, content: content, createTime: createTime);
  }

  @override
  Future<void> deleteReport(int id) async {
    await _dbHelper.deleteReport(id);
  }

  @override
  Future<List<CollectionReport>> getAllReports() async {
    var data = await _dbHelper.getAllReports();
    return data.map((e) => CollectionReport.fromJson(e)).toList();
  }

  @override
  Future<CollectionReport?> getReport(int id) async {
    var data = await _dbHelper.getReportById(id);
    if (data == null) {
      return null;
    }
    return CollectionReport.fromJson(data);
  }

  @override
  Future<void> updateReport(CollectionReport report) async {
    await _dbHelper.updateReport(id: report.id, name: report.name, content: report.content);
  }

  @override
  Future<CollectionReport?> getReportByCollectionId(int collectionId) async {
    var data = await _dbHelper.getReportByCollectionId(collectionId);
    if (data == null) {
      return null;
    }
    return CollectionReport.fromJson(data);
  }

  @override
  Future<bool> deleteReportByCollectionId(int collectionId) async {
    var count = await _dbHelper.deleteReportByCollectionId(collectionId);
    return count > 0;
  }
}
