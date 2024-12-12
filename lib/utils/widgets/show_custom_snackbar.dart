import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, warning, error, info }

void showCustomSnackbar({
  required String title,
  required String message,
  required SnackbarType type,
}) {
  IconData iconData;
  Color snackBarColor;

  switch (type) {
    case SnackbarType.success:
      iconData = Icons.check_circle;
      snackBarColor = Colors.green;
      break;
    case SnackbarType.warning:
      iconData = Icons.warning_amber_outlined;
      snackBarColor = Colors.orange;
      break;
    case SnackbarType.error:
      iconData = Icons.error_outline;
      snackBarColor = Colors.red;
      break;
    case SnackbarType.info:
      iconData = Icons.info_outline;
      snackBarColor = Colors.blue;
      break;
  }

  Get.snackbar(
    title,
    message,
    backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.5),
    colorText: snackBarColor,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(16),
    icon: Icon(
      iconData,
      color: snackBarColor,
      size: 30,
    ),
    titleText: Text(
      title,
      style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
            color: snackBarColor,
            fontWeight: FontWeight.w500,
          ),
    ),
    duration: const Duration(seconds: 3),
    isDismissible: true,
    messageText: Text(
      message,
      style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(),
    ),
  );
}
