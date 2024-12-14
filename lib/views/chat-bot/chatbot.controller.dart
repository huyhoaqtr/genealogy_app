import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/user.model.dart';
import 'package:getx_app/utils/string/string.dart';

import '../../resources/api/gemini.dart';
import '../../services/storage/storage_manager.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../message_detail/model/message.model.dart';

class ChatBotController extends GetxController {
  RxString myId = "".obs;
  RxBool isChatBotTyping = false.obs;
  final TextEditingController promptController = TextEditingController();
  RxList<Message> messages = RxList<Message>([]);

  @override
  void onInit() {
    super.onInit();
    initialData();
    loadInitMessages();
  }

  Future<void> initialData() async {
    User? myUser = await StorageManager.getUser();
    myId.value = myUser?.sId ?? "";
  }

  void loadInitMessages() {
    messages.value = [
      Message(
        sId: generateDateId(),
        content:
            "Xin chào! Tôi là trợ lý cá nhân của bạn. Tôi có thể giúp gì cho bạn hôm nay?",
        sender: User(
            sId: "chatbot",
            info: Info(
              avatar: "https://freesvg.org/img/1538298822.png",
            )),
        updatedAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      ),
    ];
  }

  Future<void> sendPromptToChatBot(String prompt) async {
    try {
      messages.insert(
        0,
        Message(
          sId: generateDateId(),
          content: prompt,
          sender: User(sId: myId.value),
          updatedAt: DateTime.now().toString(),
          createdAt: DateTime.now().toString(),
        ),
      );
      promptController.clear();
      isChatBotTyping.value = true;
      final response = await GeminiApi().getGeminiData(prompt: prompt);
      messages.insert(
        0,
        Message(
          sId: generateDateId(),
          content: response.data?.trim().replaceAll("**", ""),
          sender: User(
              sId: "chatbot",
              info: Info(
                avatar: "https://freesvg.org/img/1538298822.png",
              )),
          updatedAt: DateTime.now().toString(),
          createdAt: DateTime.now().toString(),
        ),
      );
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
          "Có lỗi xây ra, vui lòng thử lại sau", ToastType.warning);
    } finally {
      isChatBotTyping.value = false;
    }
  }

  void resetChatbot() {
    messages.clear();
  }
}
