import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/types/type.dart';
import '../../constants/app_routes.dart';
import '../../resources/api/auth.api.dart';
import '../../resources/models/user.model.dart';
import '../../services/storage/storage_manager.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/loading/loading.controller.dart';

class RegisterController extends GetxController {
  late final UserRole role;
  final PageController pageController = PageController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController tribeCodeController = TextEditingController();
  final TextEditingController tribeNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final LoadingController loadingController = Get.find<LoadingController>();

  RxString fullNameError = "".obs;
  RxString tribeCodeError = "".obs;
  RxString tribeNameError = "".obs;
  RxString phoneNumberError = "".obs;
  RxString passwordError = "".obs;
  RxString confirmPasswordError = "".obs;

  @override
  void onInit() {
    super.onInit();
    role = Get.arguments['role'];
  }

  Future<void> handleRegister() async {
    loadingController.show();
    if (validateFields()) {
      final response = await AuthApi().register(
        phoneNumber: phoneNumberController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        role: role == UserRole.MEMBER ? 'MEMBER' : 'LEADER',
        tribeCode: tribeCodeController.text,
        tribeName: tribeNameController.text,
      );

      if (response.statusCode == 201) {
        StorageManager.setToken(response.data?.accessToken ?? '');
        StorageManager.setUser(response.data?.user ?? User());
        DialogHelper.showToast("Đăng ký thành công", ToastType.success);
        Get.offAllNamed(AppRoutes.dashBoard);
      }
    }
    loadingController.hide();
  }

  bool validateFields() {
    bool isValid = true;

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Tên đầy đủ là bắt buộc';
      isValid = false;
    } else {
      fullNameError.value = "";
    }

    if (role == UserRole.MEMBER) {
      if (tribeCodeController.text.trim().isEmpty) {
        tribeCodeError.value = 'Mã gia tộc là bắt buộc';
        isValid = false;
      } else {
        tribeCodeError.value = "";
      }
    } else {
      if (tribeNameController.text.trim().isEmpty) {
        tribeNameError.value = 'Tên gia tộc là bắt buộc';
        isValid = false;
      } else {
        tribeNameError.value = "";
      }
    }

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
    } else if (passwordController.text.trim().length < 8) {
      passwordError.value = 'Mật khẩu phải có ít nhất 8 ký tự';
      isValid = false;
    } else {
      passwordError.value = "";
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = 'Xác nhận mật khẩu là bắt buộc';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Mật khẩu không trùng khớp';
      isValid = false;
    } else {
      confirmPasswordError.value = "";
    }

    return isValid;
  }
}
