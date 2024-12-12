import 'package:get/get.dart';
import 'package:getx_app/constants/app_routes.dart';
import 'dart:async';

import 'package:getx_app/utils/types/type.dart';

import '../../../services/storage/storage_manager.dart';

class SplashController extends GetxController {
  RxBool logoOpacityAnimated = false.obs;
  RxBool splashLoadingAnimated = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['isLogout'] != null) {
      final isLogout = Get.arguments['isLogout'];
      if (isLogout == true) {
        logoOpacityAnimated.value = false;
        splashLoadingAnimated.value = false;
      }
    }

    handleInitFunc();
  }

  void handleInitFunc() async {
    await Future.delayed(const Duration(milliseconds: 10));
    logoOpacityAnimated.value = true;
    await Future.delayed(const Duration(seconds: 2));

    StorageManager.getToken().then((value) async {
      if (value != null) {
        Get.offAllNamed(AppRoutes.dashBoard);
      } else {
        splashLoadingAnimated.value = true;
      }
    });
  }

  void navigateToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void navigateToRegisterAsMember() {
    Get.toNamed(AppRoutes.register, arguments: {'role': UserRole.MEMBER});
  }

  void navigateToRegisterAsLeader() {
    Get.toNamed(AppRoutes.register, arguments: {'role': UserRole.LEADER});
  }
}
