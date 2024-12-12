import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/api/message.api.dart';
import '../../resources/models/user.model.dart';
import '../../services/storage/storage_manager.dart';
import '../../utils/debounce/debounce.dart';
import 'model/conversation.model.dart';

class MessageController extends GetxController {
  RxBool isLoading = false.obs;
  RxString myId = "".obs;
  RxList<Conversation> conversations = RxList<Conversation>([]);
  RxList<User> searchUsers = RxList<User>([]);
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxString searchText = ''.obs;
  final Debouncer _debouncer = Debouncer(milliseconds: 250);

  @override
  void onInit() {
    super.onInit();
    initialData();
    loadConversations();

    searchController.value.addListener(() {
      searchText.value = searchController.value.text.trim();

      if (searchText.value.isNotEmpty) {
        _debouncer.run(() => handleSearchUser());
      }

      if (searchController.value.text.trim().isEmpty) {
        searchUsers.clear();
      }
    });
  }

  Future<void> initialData() async {
    User? myUser = await StorageManager.getUser();
    myId.value = myUser?.sId ?? "";
  }

  Future<void> loadConversations() async {
    final response = await MessageApi().getConversation(page: 1, limit: 10);
    if (response.statusCode == 201) {
      conversations.value = response.data!.data!;
    }
  }

  Future<void> handleSearchUser() async {
    final response = await MessageApi().searchUser(
      page: 1,
      limit: 36,
      keyword: searchText.value,
    );
    if (response.statusCode == 201) {
      searchUsers.value = response.data!.data!;
    }
  }

  @override
  void onClose() {
    super.onClose();
    searchController.value.dispose();
    conversations.clear();
    searchUsers.clear();
    searchText.value = '';
  }
}
