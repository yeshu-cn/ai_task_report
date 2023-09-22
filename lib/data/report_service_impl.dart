import 'package:ai_todo/data/api/openai_api.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/model/collection_report.dart';
import 'package:ai_todo/domain/repository/report_repository.dart';
import 'package:ai_todo/domain/repository/task_repository.dart';
import 'package:ai_todo/domain/service/report_service.dart';

class ReportServiceImpl implements ReportService {
  final ReportRepository _repository;
  final OpenAiApi _api;
  final TaskRepository _taskRepository;

  ReportServiceImpl(this._repository, this._api, this._taskRepository);

  @override
  Future<CollectionReport> createCollectionReport(Collection collection) async {
    var report = await _repository.getReportByCollectionId(collection.id);
    if (report != null) {
      return report;
    }

    var prompt = await _getReportPrompts(collection);
    var content = await _api.createCollectionReport(prompt);

    return await _repository.addReport(
      collectionId: collection.id,
      name: '${collection.name} 报告',
      content: content,
      createTime: DateTime.now().millisecondsSinceEpoch,
    );
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
      Your task is to help a company's team compile a 
      monthly report based on the task list provided.
      
      Compile a comprehensive monthly report based on the 
      information provided in the task list delimited by 
      triple backticks.
      
      The report should categorize the tasks based on 
      importance and relevance. Summarize the achievements 
      and highlight any pending or incomplete tasks.
      
      After the summary, include a table that lists down 
      all the tasks, categorized by 'Completed' and 'Pending'.
      The table should have three columns. In the first column, 
      include the task's category (either 'Completed' or 'Pending'). 
      In the second column, include the task's title or brief description. 
      In the third column, specify the date or deadline for the task.
      
      Give the table the title 'Task Overview'.
      
      Format everything as HTML that can be used in a company's 
      intranet portal. Place the report in a <div> element.
      
      Task list: ```$taskListContent```

    ''';
  }
}
