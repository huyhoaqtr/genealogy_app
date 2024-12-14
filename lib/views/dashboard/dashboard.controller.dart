import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/api/home.api.dart';
import '../../services/socket/SocketClientManager.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../views/message/message.controller.dart';
import '../../views/message/model/conversation.model.dart';
import '../../views/message_detail/message_detail.controller.dart';
import '../../resources/api/auth.api.dart';
import '../../resources/models/tribe.model.dart';
import '../../resources/models/user.model.dart';
import '../../services/storage/storage_manager.dart';
import '../message_detail/model/message.model.dart';

class DashboardController extends GetxController {
  RxInt currentBottomBarIndex = 0.obs;
  RxList<String> onlineUsers = <String>[].obs;
  final PageController pageController = PageController();
  Rx<User> myInfo = Rx<User>(User());
  late Rx<TribeModel?> tribe;

  @override
  void onInit() {
    super.onInit();
    tribe = Rx<TribeModel?>(null);

    onInitialState();
    updateFcmKey();
    getTribeData();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    final User? localUser = await StorageManager.getUser();
    if (localUser == null) return;
    myInfo.value = localUser;
  }

  Future<void> onInitialState() async {
    final myInfo = await StorageManager.getUser();
    if (myInfo == null) return;
    SocketClientManager().emit("online", myInfo.sId);
    SocketClientManager().on("receiveMessage", (data) {
      if (!Get.isRegistered<MessageDetailController>()) return;
      final MessageDetailController messageDetailController = Get.find();
      if (messageDetailController.conversation.value.sId !=
          data["conversation"]) return;
      final String tempId = data["tempId"];
      bool found = false;

      final Map<String, dynamic> messageData = Map.from(data);
      messageData.remove('tempId');

      final Message newMessage = Message.fromJson(messageData);

      for (int i = 0; i < messageDetailController.messages.length; i++) {
        if (messageDetailController.messages[i].tempId == tempId) {
          messageDetailController.messages[i] = newMessage;
          found = true;
          break;
        }
      }

      if (!found) {
        if (!messageDetailController.messages
            .any((message) => message.sId == newMessage.sId)) {
          messageDetailController.messages.insert(0, newMessage);
        }
      }
    });

    SocketClientManager().on("conversationUpdated", (data) {
      final MessageController messageController = Get.find();
      final Map<String, dynamic> conversationData = Map.from(data);
      final Conversation newConversation =
          Conversation.fromJson(conversationData);
      for (int i = 0; i < messageController.conversations.length; i++) {
        if (messageController.conversations[i].sId == newConversation.sId) {
          messageController.conversations.removeAt(i);
          break;
        }
      }

      messageController.conversations.insert(0, newConversation);
    });

    SocketClientManager().on("updateOnlineUsers", (data) {
      onlineUsers.value = List<String>.from(data);
      update();
    });
  }

  Future<void> updateFcmKey() async {
    final String? fcmKey = await StorageManager.getFcmToken();
    if (fcmKey != null) {
      await AuthApi().updateFcm(newFcmKey: fcmKey);
    }
  }

  Future<void> getTribeData() async {
    try {
      final response = await HomeApi().getMyTribe();
      if (response.statusCode == 200) {
        await StorageManager.setTribe(response.data!);
        tribe.value = response.data!;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
          "Có lỗi xây ra, vui lòng thử lại sau", ToastType.warning);
    }
  }

  void changeBottomBarIndex(int index) {
    currentBottomBarIndex.value = index;
  }
}
