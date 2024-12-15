import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/resources/models/genealogy.model.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';

import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../dashboard/dashboard.controller.dart';
import '../event/create_event.sheet.dart';
import 'add-page.sheet.dart';
import 'genealogy-setting.controller.dart';

class GenealogySettingScreen extends GetView<GenealogySettingController> {
  GenealogySettingScreen({super.key});

  final dashboardController = Get.find<DashboardController>();

  void _showCreateNewPdfPageBottomSheet(
      SheetMode sheetMode, PageData? pageData) {
    Get.lazyPut(() => AddPdfPageController(
          sheetMode: sheetMode,
          pageData: pageData,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const AddPdfPageSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.delete<AddPdfPageController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isUpload = dashboardController.myInfo.value.role == 'ADMIN' ||
        dashboardController.myInfo.value.role == 'LEADER';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết lập nội dung'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
        actions: [
          if (isUpload)
            IconButtonComponent(
              iconPath: 'assets/icons/pen-add.svg',
              iconSize: 32,
              iconPadding: 4,
              onPressed: () =>
                  _showCreateNewPdfPageBottomSheet(SheetMode.ADD, null),
            ),
          const SizedBox(width: AppSize.kPadding),
        ],
      ),
      body: Obx(() {
        GenealogyModel genealogy =
            controller.genealogyController.genealogyData.value;

        if (genealogy.data == null || genealogy.data!.isEmpty) {
          return Center(
            child: Text(
              "Không có dữ liệu",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
          itemCount: genealogy.data!.length,
          itemBuilder: (context, index) {
            final item = genealogy.data![index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSize.kPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${item.title}",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isUpload)
                    Row(
                      children: [
                        const SizedBox(width: AppSize.kPadding / 2),
                        if (index != 2)
                          IconButtonComponent(
                            iconColor: AppColors.infoColor,
                            iconPath: 'assets/icons/pen.svg',
                            iconSize: 28,
                            iconPadding: 4,
                            onPressed: () => _showCreateNewPdfPageBottomSheet(
                              SheetMode.EDIT,
                              item,
                            ),
                          ),
                        if (item.isDelete == true)
                          const SizedBox(width: AppSize.kPadding / 2),
                        if (item.isDelete == true)
                          IconButtonComponent(
                            iconColor: AppColors.errorColor,
                            iconPath: 'assets/icons/trash.svg',
                            iconSize: 28,
                            iconPadding: 4,
                            onPressed: () => DialogHelper.showConfirmDialog(
                              "Xác nhận",
                              "Bạn có muốn xoá dữ liệu này không?",
                              onConfirm: () =>
                                  controller.deletePdfPage(item.sId ?? ""),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
