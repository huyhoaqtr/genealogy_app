import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';

import 'notification.controller.dart';
import 'view/notification.item.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: Get.width,
        child: Wrap(
          spacing: AppSize.kPadding / 2,
          direction: Axis.vertical,
          children: List.generate(100, (index) => const NotificationItem()),
        ),
      ),
    );
  }
}
