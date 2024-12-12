import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_size.dart';
import 'notification.controller.dart';
import 'view/notification.item.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        controller.page.value = 1;
        return controller.getAllNotification();
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.only(
          top: AppSize.kPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: Get.height * 0.5,
                  child: Center(
                    child: Text(
                      'Không có thông báo',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Hiển thị danh sách thông báo khi có item
            return ListView.builder(
              itemCount: controller.notifications.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = controller.notifications[index];
                return NotificationItem(notification: item);
              },
            );
          }
        }),
      ),
    );
  }
}
