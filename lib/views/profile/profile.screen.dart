import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';

import 'profile.controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Obx(() => Text(controller.user.value.info?.fullName ?? "")),
            Obx(() => Text(controller.user.value.role ?? "")),
            const SizedBox(height: 16),
            CustomButton(
              text: "Logout",
              onPressed: () => controller.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
