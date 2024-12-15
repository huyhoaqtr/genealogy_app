import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'archive.controller.dart';
import 'transaction_item.dart';

class ArchiveScreen extends GetView<ArchiveController> {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kho lưu trữ"),
        leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back()),
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const ProgressIndicatorComponent();
          }
          if (controller.transactions.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: Get.height * 0.5,
                  child: Center(
                    child: Text(
                      'Không có lưu trữ nào',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Hiển thị danh sách thông báo khi có item
            return ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.transactions.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = controller.transactions[index];
                return TransactionItem(transaction: item);
              },
            );
          }
        }),
      ),
    );
  }
}
