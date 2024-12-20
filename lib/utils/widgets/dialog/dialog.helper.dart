import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';

import '../../string/string.dart';
import '../picker/date_picker.common.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class DialogHelper {
//get toast color by toast type

  static void showToast(String message, ToastType type) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: getToastColor(type),
      fontSize: 14,
    );
  }

  static void showToastDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: Theme.of(Get.context!).textTheme.bodyLarge,
        ),
        content:
            Text(content, style: Theme.of(Get.context!).textTheme.bodyMedium),
        actions: [CustomButton(text: "Đóng", onPressed: () => Get.back())],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static void showCustomToastDialog(String title, Widget content) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: Theme.of(Get.context!).textTheme.bodyLarge,
        ),
        content: content,
        actions: [CustomButton(text: "Đóng", onPressed: () => Get.back())],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static void showConfirmDialog(
    String title,
    String content, {
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: AppColors.backgroundColor,
        actions: [
          CustomButton(
            text: 'Huỷ',
            width: 100,
            isOutlined: true,
            onPressed: () {
              Get.back();
              if (onCancel != null) onCancel();
            },
          ),
          CustomButton(
            text: 'Xác nhận',
            width: 100,
            onPressed: () {
              Get.back();
              onConfirm();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static void showCustomDialog(
      String title, String content, List<Widget>? child) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.center,
        actions: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Future<void> showDatePickerDialog({
    required Function(DateTime) onSelectedDate,
    DateTime? initialDate,
  }) async {
    if (Get.isDialogOpen ?? false) return;
    if (Get.isRegistered<DatePickerController>()) {
      Get.delete<DatePickerController>();
    }
    Get.put(DatePickerController(initialDate: initialDate));

    if (Get.isRegistered<DatePickerController>()) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: min(Get.width - 32, 400),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
            ),
            padding: const EdgeInsets.only(
              bottom: AppSize.kPadding,
              top: AppSize.kPadding / 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: DatePickerComponent(
                    onSelectedDate: onSelectedDate,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
                  child: CustomButton(
                    text: 'Xong',
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      ).then((value) async {
        await Future.delayed(const Duration(milliseconds: 100));
        final DatePickerController controller = Get.find();
        controller.onClose();
      });
    }
  }
}
