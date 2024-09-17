import 'package:flutter/material.dart';

class Constants {
  static Color backgroundColor = const Color.fromARGB(255, 144, 202, 249);
  static Color primaryColor = const Color.fromARGB(255, 141, 107, 198);

  static RegExp emailValidationRegex =
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  static RegExp passwordValidationRegex =
      RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

  static RegExp nameValidationRegex = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");

  static Color drawerTilesColor = const Color(0xFF414755);
  static Color drawerBackground = const Color.fromARGB(226, 124, 192, 248);
}
