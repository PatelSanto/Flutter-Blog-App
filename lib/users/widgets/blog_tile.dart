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
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      
      leading: leadingImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5),
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
}
