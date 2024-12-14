import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/auth.api.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../services/storage/storage_manager.dart';
import '../../views/dashboard/dashboard.controller.dart';
import '../../resources/models/user.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class UserInfoController extends GetxController {
  RxBool isEdit = false.obs;
  Rx<User> user = User().obs;
  RxString gender = "".obs;
  Rx<DateTime?> birthday = Rx<DateTime?>(null);
  Rx<CroppedFile?> croppedData = Rx<CroppedFile?>(null);
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  RxString fullNameError = "".obs;
  final DashboardController dashboardController = Get.find();
  final LoadingController loadingController = Get.find();

  @override
  void onInit() {
    super.onInit();
    user.value = dashboardController.myInfo.value;
    gender.value = user.value.info?.gender ?? "";
    fullNameController.value.text = user.value.info?.fullName ?? "";
    phoneNumberController.value.text = user.value.phoneNumber ?? "";
    emailController.value.text = user.value.info?.email ?? "";
  }

  void cropImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      croppedData.value = croppedFile;
    }
  }

  void showBirthdayPickerDialog() {
    DialogHelper.showDatePickerDialog(
        initialDate: birthday.value,
        onSelectedDate: (value) {
          birthday.value = value;
        });
  }

  Future<void> updateUserInfo() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingController.show();
    try {
      final response = await AuthApi().updateUserInfo(
        id: user.value.sId!,
        fullName: fullNameController.value.text,
        gender: gender.value,
        email: emailController.value.text,
        dateOfBirth: birthday.value?.toIso8601String(),
        address: addressController.value.text,
        avatar:
            croppedData.value != null ? File(croppedData.value!.path) : null,
      );
      if (response.statusCode == 200) {
        DialogHelper.showToast(
          "Cập nhật thông tin thành công",
          ToastType.success,
        );
        dashboardController.myInfo.value = response.data!;
        dashboardController.myInfo.refresh();
        user.value = response.data!;
        StorageManager.setUser(response.data ?? User());
        isEdit.value = false;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}
