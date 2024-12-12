import 'package:get/get.dart';

import 'message_detail.controller.dart';

class MessageDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageDetailController>(() => MessageDetailController());
  }
}
