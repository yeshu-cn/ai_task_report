import 'package:ai_todo/data/api/openai_api.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/model/result.dart';
import 'package:ai_todo/domain/repository/report_repository.dart';
import 'package:ai_todo/domain/repository/task_repository.dart';
import 'package:ai_todo/domain/service/report_service.dart';
import 'package:flutter/foundation.dart';

class ReportServiceImpl implements ReportService {
  final ReportRepository _repository;
  final OpenAiApi _api;
  final TaskRepository _taskRepository;

  ReportServiceImpl(this._repository, this._api, this._taskRepository);

  @override
  Future<Result<CollectionReport>> createCollectionReport(Collection collection) async {
    try {
      var prompt = await _getReportPrompts(collection);
      debugPrint("prompt is ------>:\n$prompt");
      var content = await _api.createCollectionReport(prompt);
      debugPrint("content is ------>:\n$content");

      // delete old report
      await _repository.deleteReportByCollectionId(collection.id);

      var report =  await _repository.addReport(
        collectionId: collection.id,
        name: '${collection.name} 报告',
        content: content,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      return Result.success(report);
    } catch (e) {
      debugPrint("createCollectionReport error: $e");
      return Result.failure(e as Exception);
    }
  }

  @override
  Future<List<CollectionReport>> getAllReports() async {
    return await _repository.getAllReports();
  }

  @override
  Future<CollectionReport?> getCollectionReport(int collectionId) async {
    return await _repository.getReportByCollectionId(collectionId);
  }

  Future<String> _getReportPrompts(Collection collection) async {
    var tasks = await _taskRepository.getTasksByCollectionId(collection.id);
    var taskListContent = tasks.map((e) => e.toString()).join('\n');

    return '''
      Based on the provided task list, please help the company's team compile a 
      monthly report. Ensure the report is solely derived from the tasks given.
      
      The report should be comprehensive and strictly adhere to the 
      information provided in the task list below.
      
      Please structure the report according to the following sections, and fill in 
      relevant content based on the task list:
      
      ### 1. 本月主要工作:
      (Primary tasks and accomplishments of the month from the task list)
      
      ### 2. 本月次要工作:
      (Secondary or less critical tasks from the task list)
      
      ### 3. 本月突发工作:
      (Any unexpected or unplanned tasks from the task list)
      
      ### 4. 本月工作总结:
      (Summary of overall progress, challenges, and results based on the task list)
      
      ### 5. 下月工作计划:
      (Plans, goals, and tasks set for the upcoming month derived from the task list)
      
      ### 6. 需帮助与支持:
      (Any requirements for help, resources, or support based on the task list)
      
      ### 7. 备注:
      (Any additional notes, comments, or observations from the task list)
      
      Format everything as Markdown.
      
      Task list: ```$taskListContent```
    ''';
  }

  @override
  Future<CollectionReport?> getReportById(int id) async {
    return await _repository.getReport(id);
  }

  @override
  Future<void> deleteReportById(int id) async {
    return await _repository.deleteReport(id);
  }

}
