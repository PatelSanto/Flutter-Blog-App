import 'dart:convert';

import 'package:blog_app/header.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class TextEditor extends StatefulWidget {
  const TextEditor({super.key, required this.content});
  final dynamic content;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _controller.document = Document.fromJson(jsonDecode(widget.content));
    _controller.readOnly = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Editor"),
        leadingWidth: 80,
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: IconButton(
              color: Colors.black,
              onPressed: () {
                final String data =
                    jsonEncode(_controller.document.toDelta().toJson());
                print("Data: $data");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CreateBlogScreen(content: data),
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
                multiRowsDisplay: true,
                showAlignmentButtons: true,
                showBackgroundColorButton: true,
              ),
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
