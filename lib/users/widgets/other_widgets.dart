import 'package:blog_app/header.dart';
import 'package:share_plus/share_plus.dart';

Widget noBlogFoundWidget() {
  return SingleChildScrollView(
    child: Opacity(
      opacity: 0.6,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/3d-casual-life-question-mark-icon-1.png",
              width: 200,
              // color: ,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('No blogs found'),
          ],
        ),
      ),
    ),
  );
}

Future shareFile(File filename) async {
  try {
    final File file = filename;
    String path = file.path;
    print("sharing file:$path, file exists: ${file.existsSync()}");
    Share.shareXFiles([XFile(path)]);
    print("done sharing");
  } catch (error) {
    print("error while sharing: $error");
  }
}