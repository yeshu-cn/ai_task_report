class TemplateConfig {
  List<Template> templates = [];
  int selectedTemplate = 0;

  TemplateConfig.createDefault() {
    templates = [
      Template('default', 'default'),
    ];
    selectedTemplate = 0;
  }

  TemplateConfig.fromJson(Map<String, dynamic> json) {
    templates = (json['templates'] as List).map((e) => Template.fromJson(e)).toList();
    selectedTemplate = json['selectedTemplate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['templates'] = templates;
    data['selectedTemplate'] = selectedTemplate;
    return data;
  }
}

class Template {
  String name;
  String content;

  Template(this.name, this.content);

  Template.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    content = json['content'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['content'] = content;
    return data;
  }
}