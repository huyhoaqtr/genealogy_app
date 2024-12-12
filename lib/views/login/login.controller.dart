import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/auth.api.dart';
import 'package:getx_app/services/storage/storage_manager.dart';

import '../../constants/app_routes.dart';
import '../../resources/models/user.model.dart';
import '../../utils/widgets/show_custom_snackbar.dart';

class LoginController extends GetxController {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxString phoneNumberError = "".obs;
  RxString passwordError = "".obs;

  bool validateFields() {
    bool isValid = true;

    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberError.value = 'Số điện thoại là bắt buộc';
      isValid = false;
    } else if (!RegExp(r'^\d{10,11}$').hasMatch(phoneNumberController.text)) {
      phoneNumberError.value = 'Số điện thoại phải từ 10 đến 11 chữ số';
      isValid = false;
    } else {
      phoneNumberError.value = "";
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Mật khẩu là bắt buộc';
      isValid = false;
    } else {
      passwordError.value = "";
    }

    return isValid;
  }

  void handleLogin() async {
    try {
      if (validateFields()) {
        final response = await AuthApi().login(
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
        );

        if (response.statusCode == 200) {
          StorageManager.setToken(response.data?.accessToken ?? '');
          StorageManager.setUser(response.data?.user ?? User());
          showCustomSnackbar(
            title: "Thành công",
            message: response.message ?? "Đăng nhập thành công",
            type: SnackbarType.success,
          );
          Get.offAllNamed(AppRoutes.dashBoard);
        } else {
          showCustomSnackbar(
            title: "Có lỗi xảy ra",
            message: response.message ?? "Đăng nhập thất bại",
            type: SnackbarType.error,
          );
        }
      }
    } catch (e) {
      print("Có lỗi không xác định xảy ra");
      rethrow;
    }
  }
}
