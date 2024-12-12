import 'package:get/get.dart';

import 'notification.controller.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
