import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../resources/api/notification.api.dart';
import '../../resources/models/notification.model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPages = 0.obs;
  RxBool isLoadMore = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getAllNotification();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        loadMoreNotification();
      }
    });
  }

  Future<void> getAllNotification() async {
    final response = await NotificationApi().getAllNotification(
      page: page.value,
      limit: limit.value,
    );
    notifications.value = response.data?.data ?? [];
    totalPages.value = response.data?.meta?.totalPages ?? 0;
  }

  Future<void> loadMoreNotification() async {
    if (isLoadMore.value || page.value >= totalPages.value) return;
    page.value++;
    isLoadMore.value = true;
    await getAllNotification();
    isLoadMore.value = false;
  }

  Future<void> isReadNotification(NotificationModel notification) async {
    try {
      if (notification.isRead == true) return;

      final index = notifications
          .indexWhere((element) => element.sId == notification.sId);
      if (index != -1) {
        final updatedNotification = notifications[index].copyWith(isRead: true);
        notifications[index] = updatedNotification;

        await NotificationApi().isRead(id: notification.sId!);
      } else {
        throw Exception('Notification not found');
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }
}
