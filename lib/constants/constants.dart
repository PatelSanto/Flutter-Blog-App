import 'package:flutter/material.dart';

class Constants {
  static Color backgroundColor = Colors.white;

  static RegExp emailValidationRegex =
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  static RegExp passwordValidationRegex =
      RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

  static RegExp nameValidationRegex = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");

  static String profilePicPlaceHolder =
      "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";
}

class AppColors {
  static Color drawerTilesColor = const Color(0xFF414755);
  static Color drawerBackground = const Color(0xFF207368);
}
