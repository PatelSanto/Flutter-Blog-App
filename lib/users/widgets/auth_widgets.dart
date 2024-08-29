import 'package:flutter/material.dart';

Widget authButton(
    {required String buttonName, required void Function()? ontap}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.blue,width: 2),
      color: Colors.blue[100],
    ),
    child: ElevatedButton(
      onPressed: ontap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 46, 75, 150),
          fontSize: 17,
        ),
      ),
    ),
  );
}