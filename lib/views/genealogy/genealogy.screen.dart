import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/loading/loading.common.dart';
import 'genealogy.controller.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class GenealogyScreen extends GetView<GenealogyController> {
  GenealogyScreen({super.key});
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isUpload = dashboardController.myInfo.value.role == 'ADMIN' ||
        dashboardController.myInfo.value.role == 'LEADER';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phả ký gia tộc'),
        centerTitle: false,
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
        actions: [
          if (isUpload)
            Obx(() => controller.isUploading.value
                ? const SizedBox(
                    child: LoadingIcon(size: 32),
                  )
                : IconButtonComponent(
                    iconPath: 'assets/icons/eth.svg',
                    iconSize: 32,
                    iconPadding: 5,
                    onPressed: () => DialogHelper.showConfirmDialog(
                      "Xác nhận",
                      "Bạn có muốn lưu nó lên blockchain?",
                      onConfirm: () => controller.uploadToWeb3(),
                    ),
                  )),
          IconButtonComponent(
            iconPath: 'assets/icons/printer.svg',
            iconSize: 32,
            iconPadding: 6,
            onPressed: () => DialogHelper.showConfirmDialog(
              "Xác nhận",
              "Bạn có muốn tải file này xuống không?",
              onConfirm: () => controller.savePdfToDevice(),
            ),
          ),
          if (isUpload)
            IconButtonComponent(
              iconPath: 'assets/icons/settings.svg',
              iconSize: 32,
              iconPadding: 6,
              onPressed: () => Get.toNamed('/genealogy-setting'),
            ),
          const SizedBox(width: AppSize.kPadding),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
        child: Obx(() {
          if (controller.isPdfGenerating.value) {
            return const ProgressIndicatorComponent();
          }

          if (controller.pdfData.value.isNotEmpty) {
            return PDFView(
              key: ValueKey(controller.pdfData.value),
              pdfData: controller.pdfData.value,
              enableSwipe: true,
              pageSnap: true,
              pageFling: false,
              swipeHorizontal: false,
              fitPolicy: FitPolicy.WIDTH,
              fitEachPage: false,
              backgroundColor: AppColors.backgroundColor,
              defaultPage: controller.currentPage.value,
              onPageChanged: (page, total) => {
                if (page != null) controller.currentPage.value = page,
              },
            );
          } else {
            return const SizedBox.shrink(); // Nếu không có dữ liệu PDF
          }
        }),
      ),
    );
  }
}
