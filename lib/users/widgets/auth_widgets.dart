import 'package:flutter/material.dart';

Widget authButton(
    {required String buttonName, required void Function()? ontap}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(),
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
          fontSize: 17,
        ),
      ),
    ),
  );
}

