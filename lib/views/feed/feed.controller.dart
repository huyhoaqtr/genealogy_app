import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/api/feed.api.dart';
import '../../resources/models/feed.model.dart';
import '../../resources/models/user.model.dart';
import '../../services/storage/storage_manager.dart';

class FeedController extends GetxController {
  RxList<Feed> feeds = <Feed>[].obs;
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPages = 0.obs;
  RxBool isLoadMore = false.obs;
  Rx<User?> myInfo = Rx<User?>(null);

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadMyInfo();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await getMoreFeeds();
      }
    });
  }

  Future<void> loadMyInfo() async {
    myInfo.value = await StorageManager.getUser();
  }

  @override
  void onReady() {
    super.onReady();
    getAllFeeds();
  }

  Future<void> getAllFeeds() async {
    final response = await FeedApi().getAllFeed(
      page: page.value,
      limit: limit.value,
    );
    if (response.statusCode == 201) {
      feeds.value += response.data?.data ?? [];
      totalPages.value = response.data?.meta?.totalPages ?? 0;
    }
  }

  Future<void> getMoreFeeds() async {
    if (isLoadMore.value || page.value >= totalPages.value) return;
    try {
      page.value++;
      isLoadMore.value = true;
      getAllFeeds();
    } finally {
      isLoadMore.value = false;
    }
  }
}
