import 'package:flutter/material.dart';

Widget blogTile({
  required void Function() ontap,
  required leadingImage,
  required title,
  required author,
  required readingTime,
  required views,
  required comments,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: leadingImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
          Text('By $author'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.remove_red_eye_rounded,
                color: Colors.blueGrey,
              ),
              Text(" $views"),
              const SizedBox(width: 20),
              const Icon(
                Icons.insert_comment_rounded,
                color: Colors.blueGrey,
              ),
              Text(" $comments"),
            ],
          )
        ],
      ),
      onTap: ontap,
    ),
  );
}
