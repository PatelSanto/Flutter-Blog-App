import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget blogTile({
  required void Function() ontap,
  required leadingImage,
  required title,
  required author,
  required timeStamp,
  required views,
  required comments,
}) {
  DateTime dateTime = timeStamp.toDate();
  String date = DateFormat("MMMM d, yyyy").format(dateTime);
  // ImageProvider imageProvider = NetworkImage(leadingImage);
  // final String imageOrientation = determineImageOrientation(imageProvider);

  return Card(color: Colors.grey[200],
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: leadingImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                leadingImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.image,
              size: 50,
              color: Colors.grey,
            ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text('By $author'),
          Text(
            'At $date',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.remove_red_eye_rounded,
                color: Color.fromARGB(255, 46, 75, 150),
              ),
              Text(
                " $views",
                style: const TextStyle(
                  color: Color.fromARGB(255, 46, 75, 150),
                ),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.insert_comment_rounded,
                color: Color.fromARGB(255, 46, 75, 150),
              ),
              Text(
                " $comments",
                style: const TextStyle(
                  color: Color.fromARGB(255, 46, 75, 150),
                ),
              ),
            ],
          )
        ],
      ),
      onTap: ontap,
    ),
  );
  //__________________________________________________________________//
  // return Container(
  //   margin: const EdgeInsets.all(10),
  //   padding: const EdgeInsets.all(10),
  //   decoration: BoxDecoration(
  //     border: Border.all(),
  //     borderRadius: BorderRadius.circular(10),
  //     color: Colors.grey[200],
  //   ),
  //   child: Column(
  //     children: [
  //       //image
  //       leadingImage.isNotEmpty
  //           ? Align(
  //             alignment:
  //             (imageOrientation == "")?
  //              Alignment.centerLeft,
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(5),
  //                 child: Image.network(
  //                   leadingImage,
  //                   // width: 100,
  //                   height: 100,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //           )
  //           : const Icon(
  //               Icons.image,
  //               size: 50,
  //               color: Colors.grey,
  //             ),
  //       // details
  //       Container(),
  //       //views comments likes
  //       Container(),
  //     ],
  //   ),
  // );
}

String determineImageOrientation(ImageProvider imageProvider) {
  final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
  String result = "";
  stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
    final int width = info.image.width;
    final int height = info.image.height;

    if (width > height) {
      result = 'horizontal';
    } else if (height > width) {
      result = 'vertical';
    } else {
      result = 'square';
    }
  }));
  return result;
}
