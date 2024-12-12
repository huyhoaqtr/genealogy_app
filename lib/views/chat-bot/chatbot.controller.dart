import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/gemini.dart';
import 'package:getx_app/resources/models/user.model.dart';
import 'package:getx_app/utils/string/string.dart';

import '../../resources/api/gemini.dart';
import '../../services/storage/storage_manager.dart';
import '../message_detail/model/message.model.dart';

class ChatBotController extends GetxController {
  RxString myId = "".obs;
  RxBool isChatBotTyping = false.obs;
  RxList<String> listPrompts = RxList<String>([]);
  RxList<GeminiModel> listResponses = RxList<GeminiModel>([]);
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
    String oldPrompt = listPrompts.isEmpty
        ? ""
        : "Dữ liệu trò chuyện trước đó: ${listPrompts.join('\n')}\n}";

    String payload = "$oldPrompt, Câu hỏi mới:$prompt";

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
    final response = await GeminiApi().getGeminiData(
      prompt: payload,
    );
    isChatBotTyping.value = false;
    messages.insert(
      0,
      Message(
        sId: generateDateId(),
        content: response.candidates?.first.content?.parts?.first.text
            ?.trim()
            .replaceAll("**", ""),
        sender: User(
            sId: "chatbot",
            info: Info(
              avatar: "https://freesvg.org/img/1538298822.png",
            )),
        updatedAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      ),
    );
    listResponses.add(response);
    listPrompts.add(
        "Thời gian:${DateTime.now()} - Câu hỏi:$prompt - Bạn trả lời:${response.candidates?.first.content?.parts?.first.text}");
    listPrompts.refresh();
    listResponses.refresh();
  }

  void resetChatbot() {
    listPrompts.clear();
    listResponses.clear();
    messages.clear();
  }
}
