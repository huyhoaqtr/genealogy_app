import 'package:get/get.dart';
import 'package:getx_app/services/storage/storage_manager.dart';

import '../../constants/app_routes.dart';
import '../splash/splash.controller.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  void logout() {
    Get.delete<SplashController>();
    StorageManager.clearData();
    Get.offAllNamed(AppRoutes.splash, arguments: {'isLogout': true});
  }
}
