import 'package:blog_app/users/screens/home/blog%20screens/create_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({super.key, required this.content});
  final dynamic content;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final QuillController _controller = QuillController.basic();
  // final _editorFocusNode = FocusNode();
  // final _editorScrollController = ScrollController();
  // var _isReadOnly = false;
  // var _isSpellcheckerActive = false;

  @override
  void initState() {
    // final json = jsonDecode('{"Content":${widget.content}}');
    // _controller.document = Document.fromJson(json);
    // _controller.document = widget.content.document;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Editor"),
        leading: CircleAvatar(
          // backgroundColor: Colors.grey[200],
          backgroundColor: Colors.white,
          child: IconButton(
              color: Colors.black,
              onPressed: () {
                // final json = jsonEncode(_controller.document.toDelta().toJson());
                // _controller.document = Document.fromJson(json);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CreateBlogScreen(
                        content: _controller.document.toPlainText()),
                  ),
                );
              },
              icon: const Icon(Icons.save)),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SizedBox(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: QuillSimpleToolbar(
              controller: _controller,
              configurations: const QuillSimpleToolbarConfigurations(
                  multiRowsDisplay: true),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: QuillEditor.basic(
                controller: _controller,
                configurations: const QuillEditorConfigurations(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
