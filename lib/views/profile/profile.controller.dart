import 'package:get/get.dart';
import 'package:getx_app/resources/models/user.model.dart';
import 'package:getx_app/services/storage/storage_manager.dart';

import '../../constants/app_routes.dart';

class ProfileController extends GetxController {
  final Rx<User> user = Rx<User>(User());

  @override
  void onInit() {
    super.onInit();
    loadInitData();
  }

  void loadInitData() {
    StorageManager.getUser().then((value) {
      if (value != null) {
        user.value = value;
      }
    });
    // fullname.value = Get.arguments['fullname'];
  }

  void logout() {
    StorageManager.clearData();
    Get.offAllNamed(AppRoutes.splash);
  }
}
