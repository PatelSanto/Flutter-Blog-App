import 'package:flutter/material.dart';

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
