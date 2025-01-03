import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';

import '../../resources/api/message.api.dart';
import '../../resources/models/user.model.dart';
import '../../services/storage/storage_manager.dart';
import '../../utils/string/string.dart';
import '../message/model/conversation.model.dart';
import 'model/message.model.dart';

enum MessageType {
  TEXT,
  IMAGE,
}

class MessageDetailController extends GetxController {
  RxString myId = "".obs;
  RxDouble inputHeight = 32.0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxList<GlobalKey> itemKeys = RxList<GlobalKey>([]);
  RxList<Message> messages = RxList<Message>([]);
  Rx<Message> replyMessage = Rx<Message>(Message());
  Rx<File?> tempImage = Rx<File?>(null);
  Rx<Conversation> conversation = Rx<Conversation>(Conversation());
  Rx<Members> receiver = Rx<Members>(Members());
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPages = 0.obs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initialData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        loadMoreMessages();
      }
    });
  }

  Future<void> initialData() async {
    User? myUser = await StorageManager.getUser();
    myId.value = myUser?.sId ?? "";
    final conversationJson = Get.arguments["conversation"];
    if (conversationJson != null) {
      final newConversation = Conversation.fromJson(conversationJson);
      conversation.value = newConversation;
    }
    final receiverJson = Get.arguments["receiver"];
    if (receiverJson != null) {
      final newReceiver = Members.fromJson(receiverJson);
      receiver.value = newReceiver;
    }
    loadMessages();
  }

  Future<void> loadMessages() async {
    final response = await MessageApi().getMessage(
      page: page.value,
      limit: 36,
      conversationId: conversation.value.sId,
      receiverId: receiver.value.sId,
    );
    if (response.statusCode == 201 && response.data?.data != null) {
      messages.value += response.data?.data ?? [];
      totalPages.value = response.data?.meta?.totalPages ?? 0;
      page.value = response.data?.meta?.page ?? 0;
      for (int i = 0; i < response.data!.data!.length; i++) {
        GlobalKey key = GlobalKey();
        itemKeys.add(key);
      }
    }
  }

  Future<void> loadMoreMessages() async {
    if (isLoadMore.value || page.value >= totalPages.value) return;
    try {
      page.value++;
      isLoadMore.value = true;
      loadMessages();
    } catch (e) {
      if (e is Exception) {
        print("Error: $e");
      }
      rethrow;
    } finally {
      isLoadMore.value = false;
    }
  }

  void replyMessageTo(Message message) {
    replyMessage.value = message;
  }

  void closeReplyMessage() {
    replyMessage.value = Message();
  }

  Future<void> sendMessage(MessageType type) async {
    try {
      final String tempId = generateDateId();
      Message? message = _createLocalMessage(type, tempId);
      if (message == null) return;
      messages.insert(0, message);

      itemKeys.add(GlobalKey());
      _resetMessageState();

      await MessageApi().sendMessage(
        messageType: conversation.value.type ?? "SINGLE",
        conversationId: conversation.value.sId,
        content: type == MessageType.TEXT ? message.content : null,
        tempId: tempId,
        replyMessageId: message.replyMessage?.sId,
        file: type == MessageType.IMAGE ? message.tempImage : null,
        receiverId: receiver.value.sId,
      );
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Thông báo"
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    }
  }

  Future<void> unSendMessage(String id) async {
    try {
      final response = await MessageApi().unSendMessage(id: id);
      if (response.statusCode == 200) {
        final index = messages.indexWhere((msg) => msg.sId == id);
        if (index != -1) {
          messages.removeAt(index);
          itemKeys.removeAt(index);
        }
        DialogHelper.showToast(
          "Tin nhắn đã được gỡ thành công",
          ToastType.success,
        );
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Thông báo"
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    }
  }

// Hàm tạo tin nhắn cục bộ
  Message? _createLocalMessage(MessageType type, String tempId) {
    if (type == MessageType.TEXT && messageController.text.isEmpty) {
      return null;
    }

    return Message(
      sId: generateDateId(),
      content: type == MessageType.TEXT ? messageController.text : null,
      sender: User(sId: myId.value),
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      tempImage: type == MessageType.IMAGE ? tempImage.value : null,
      tempId: tempId,
      replyMessage: replyMessage.value,
    );
  }

  void _resetMessageState() {
    replyMessage.value = Message();
    tempImage.value = null;
    messageController.clear();
  }

  void scrollToMessage(Message message) {
    if (scrollController.hasClients) {
      int index = messages.indexWhere((msg) => msg.sId == message.sId);
      if (index != -1 && index < itemKeys.length) {
        final key = itemKeys[index];
        final context = key.currentContext;

        if (context != null) {
          final renderObject = context.findRenderObject() as RenderBox?;
          if (renderObject != null) {
            final position = renderObject.localToGlobal(Offset.zero).dy;
            scrollController.animateTo(
              position,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    messages.clear();
    super.onClose();
  }
}
