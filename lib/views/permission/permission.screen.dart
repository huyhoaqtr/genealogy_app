import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/progress_indicator.dart';
import 'permission.controller.dart';
import 'permission.item.dart';

class PermissionScreen extends GetView<PermissionController> {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quyền thành viên'),
          leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const ProgressIndicatorComponent();
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.loadAllMember();
            },
            child: Obx(() {
              final users = controller.users.value;

              if (users.isEmpty) {
                return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: Get.height * 0.5,
                        child: Center(
                          child: Text(
                            'Không có thành viên nào',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ]);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: users.length + 1, // +1 for spacing at the bottom
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    return const SizedBox(height: 40); // Spacing at the bottom
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSize.kPadding / 2,
                    ),
                    child: PermissionItemComponent(user: users[index]),
                  );
                },
              );
            }),
          );
        }));
  }
}
