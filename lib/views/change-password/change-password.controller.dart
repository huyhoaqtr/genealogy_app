import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../resources/api/auth.api.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class ChangePasswordController extends GetxController {
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;

  final LoadingController loadingController = Get.find();

  RxString oldPasswordError = "".obs;
  RxString newPasswordError = "".obs;
  RxString confirmPasswordError = "".obs;

  bool validateFields() {
    bool isValid = true;

    if (oldPasswordController.value.text.trim().isEmpty) {
      oldPasswordError.value = 'Không được bỏ trống';
      isValid = false;
    } else {
      oldPasswordError.value = "";
    }

    if (newPasswordController.value.text.trim().isEmpty) {
      newPasswordError.value = 'Không được bỏ trống';
      isValid = false;
    } else {
      newPasswordError.value = "";
    }

    if (confirmPasswordController.value.text.trim().isEmpty) {
      confirmPasswordError.value = 'Không được bỏ trống';
      isValid = false;
    } else if (confirmPasswordController.value.text !=
        newPasswordController.value.text) {
      confirmPasswordError.value = 'Mật khẩu không trùng khớp';
      isValid = false;
    } else {
      confirmPasswordError.value = "";
    }

    return isValid;
  }

  Future<void> changePassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingController.show();
    try {
      if (validateFields()) {
        final response = await AuthApi().updatePassword(
          oldPassword: oldPasswordController.value.text,
          newPassword: newPasswordController.value.text,
        );

        if (response.statusCode == 200) {
          DialogHelper.showToast(
            "Thay đổi mật khẩu thành công",
            ToastType.success,
          );
          oldPasswordController.value.clear();
          newPasswordController.value.clear();
          confirmPasswordController.value.clear();
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}
