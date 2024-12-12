import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../resources/models/tribe.model.dart';
import '../../constants/app_size.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'introduce.controller.dart';
import 'update_tribe.sheet.dart';

class IntroduceScreen extends GetView<IntroduceController> {
  const IntroduceScreen({super.key});

  void _showUpdateTribeBottomSheet() {
    Get.lazyPut(() => UpdateTribeSheetController());

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const UpdateTribeSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.delete<UpdateTribeSheetController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin gia tộc'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButtonComponent(
            iconSize: 32,
            iconPadding: 6,
            iconPath: 'assets/icons/pen.svg',
            onPressed: () => _showUpdateTribeBottomSheet(),
          ),
          const SizedBox(
            width: AppSize.kPadding,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.kPadding),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Obx(() {
            final TribeModel? tribe =
                controller.dashboardController.tribe.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tên gia tộc: ${tribe?.name}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Text(
                  'Địa chỉ: ${tribe?.address ?? ""}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Text(
                  'Tộc trưởng: ${tribe?.leader?.info?.fullName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mã gia tộc: ${tribe?.code}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    IconButtonComponent(
                      iconSize: 28,
                      iconPath: "./assets/icons/clipboard.svg",
                      onPressed: () =>
                          controller.copyTribeCode("${tribe?.code}"),
                      iconPadding: 4,
                    )
                  ],
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Center(
                  child: QrImageView(
                    padding: const EdgeInsets.all(0),
                    data: "GTV%${tribe?.code}%GTV",
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Text(
                  'Mô tả:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  tribe?.description ?? "",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
