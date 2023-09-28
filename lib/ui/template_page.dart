import 'package:ai_todo/domain/model/template_config.dart';
import 'package:ai_todo/ui/edit_template_page.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  var _config = TemplateConfig.createDefault();

  _loadData() async {
    _config = await SpUtils.getReportTemplate();
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Templates'),
        actions: [
          // add
          IconButton(
            onPressed: () {
              if (_config.templates.length >= 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('最多只能添加5个模板'),
                  ),
                );
                return;
              }
              _addTemplate();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _config.templates.length,
        itemBuilder: (context, index) {
          return ListTile(
            // get map key by index
            title: Text(_config.templates[index].name),
            onTap: () {
              _editTemplate(index);
            },
          );
        },
      ),
    );
  }

  void _editTemplate(int index) async {
    var ret = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTemplatePage(
          template: _config.templates[index],
        ),
      ),
    );
    if (ret != null) {
      _config.templates[index] = ret as Template;
      await SpUtils.setReportTemplate(_config);
      _loadData();
    }
  }

  void _addTemplate() async {
    var ret = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTemplatePage(
          template: Template('new', 'content'),
        ),
      ),
    );
    if (ret != null) {
      _config.templates.add(ret as Template);
      await SpUtils.setReportTemplate(_config);
      _loadData();
    }
  }
}
