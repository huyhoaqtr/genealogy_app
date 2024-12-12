import 'package:get/get.dart';

import 'chatbot.controller.dart';

class ChatBotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatBotController>(() => ChatBotController());
  }
}
