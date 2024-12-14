import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/socket/SocketClientManager.dart';
import '../../utils/widgets/loading/loading.controller.dart';
import '../../resources/api/auth.api.dart';
import '../../services/storage/storage_manager.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../constants/app_routes.dart';
import '../../resources/models/user.model.dart';

class LoginController extends GetxController {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoadingController loadingController = Get.find<LoadingController>();
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
    loadingController.show();
    try {
      if (validateFields()) {
        final response = await AuthApi().login(
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
        );

        if (response.statusCode == 200) {
          StorageManager.setToken(response.data?.accessToken ?? '');
          StorageManager.setUser(response.data?.user ?? User());
          DialogHelper.showToast("Đăng nhập thành công", ToastType.success);
          SocketClientManager().emit("online", response.data?.user?.sId);
          Get.offAllNamed(AppRoutes.dashBoard);
        }
      }
    } finally {
      loadingController.hide();
    }
  }
}
