import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/api/feed.api.dart';
import '../../resources/models/feed.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class MyPostController extends GetxController {
  RxList<Feed> feeds = <Feed>[].obs;
  RxInt page = 1.obs;
  RxInt limit = 10.obs;
  RxInt totalPages = 0.obs;
  RxBool isLoadMore = false.obs;
  RxBool isLoading = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await getMoreFeeds();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    getAllFeeds();
  }

  Future<void> getAllFeeds() async {
    isLoading.value = true;
    try {
      final response = await FeedApi().getAllFeedByUserId(
        page: page.value,
        limit: limit.value,
      );
      if (response.statusCode == 201) {
        feeds.value += response.data?.data ?? [];
        page.value = response.data?.meta?.page ?? 0;
        totalPages.value = response.data?.meta?.totalPages ?? 0;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMoreFeeds() async {
    await Future.delayed(const Duration(seconds: 3));
    if (isLoadMore.value || page.value >= totalPages.value) return;
    isLoadMore.value = true;
    try {
      page.value++;
      getAllFeeds();
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoadMore.value = false;
    }
  }
}