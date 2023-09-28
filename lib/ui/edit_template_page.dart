import 'package:ai_todo/domain/model/template_config.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTemplatePage extends StatefulWidget {
  final Template template;

  const EditTemplatePage({super.key, required this.template});

  @override
  State<EditTemplatePage> createState() => _EditTemplatePageState();
}

class _EditTemplatePageState extends State<EditTemplatePage> {
  var _editorState = EditorState.blank(withInitialText: true);
  late final EditorScrollController _editorScrollController;
  late EditorStyle _editorStyle;
  late Map<String, BlockComponentBuilder> _blockComponentBuilders;
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.template.name;
    _editorState = EditorState(
      document: markdownToDocument(widget.template.content),
    );
    _editorScrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: false,
    );
    _editorStyle = _buildMobileEditorStyle();
    _blockComponentBuilders = _buildBlockComponentBuilders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Edit'),
          actions: [
            IconButton(
              onPressed: () async {
                // save template
                var template = Template(
                  _controller.text.trim(),
                  documentToMarkdown(_editorState.document),
                );
                Navigator.of(context).pop(template);
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Template name',
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(),
                ),
                controller: _controller,
                onChanged: (value) {
                  widget.template.name = value;
                },
              ),
            ),
            Expanded(
                child: AppFlowyEditor(
              editorStyle: _editorStyle,
              editorState: _editorState,
              editorScrollController: _editorScrollController,
              blockComponentBuilders: _blockComponentBuilders,
            )),
            MobileToolbar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              editorState: _editorState,
              toolbarItems: [
                todoListMobileToolbarItem,
                listMobileToolbarItem,
              ],
            ),
          ],
        ));
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildMobileEditorStyle() {
    return EditorStyle.mobile(
      cursorColor: Colors.blue,
      selectionColor: Colors.blue.shade200,
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        code: GoogleFonts.badScript(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // customize the heading block component
    final levelToFontSize = [
      24.0,
      22.0,
      20.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => GoogleFonts.poppins(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
    map[ParagraphBlockKeys.type] = TextBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
      ),
    );
    return map;
  }
}
