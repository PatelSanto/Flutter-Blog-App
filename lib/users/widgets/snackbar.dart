import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

void snackbarToast({
  required BuildContext context,
  required String title,
  required IconData icon,
}) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 3),
    builder: (context) => ToastCard(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
  ).show(context);
}
