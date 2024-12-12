import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Node;
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:getx_app/views/family_tree/view/add_user.bottomsheet.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/text_button.common.dart';
import 'family-tree.controller.dart';
import 'view/add_user.controller.dart';
import 'view/node_view.dart';
import 'view/tree_painter.dart';

class FamilyTreeScreen extends GetView<FamilyTreeController> {
  FamilyTreeScreen({super.key});

  final DashboardController dashboardController = Get.find();

  void _showAddUserBottomSheet(AddUserMode mode) {
    Get.lazyPut(() => AddUserController(
          mode: mode,
          sheetMode: SheetMode.ADD,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => AddUserBottomSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.delete<AddUserController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 15,
                transformationController: controller.transformationController,
                child: SizedBox(
                  width: Get.width,
                  child: Center(
                    child: RepaintBoundary(
                      key: controller.boundaryKey,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSize.kPadding / 2),
                        child: Obx(() => Transform.rotate(
                              angle: controller.isRotate.value
                                  ? 90 * 3.1415927 / 180
                                  : 0,
                              child: SizedBox(
                                width: 360 - AppSize.kPadding,
                                height: (360 - AppSize.kPadding) * (2 / 3),
                                child: _buildMainContentView(context),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => (dashboardController.myInfo.value.role == "ADMIN" ||
                    dashboardController.myInfo.value.role == "LEADER")
                ? Positioned(
                    bottom: AppSize.kPadding * 2,
                    left: AppSize.kPadding,
                    right: AppSize.kPadding,
                    child: Row(
                      children: [
                        if (controller.isScreenMode.value == ScreenMode.EDIT)
                          Expanded(
                            child: CustomButton(
                              text: "Huỷ",
                              isOutlined: true,
                              onPressed: () => controller.cancelEditTribeTree(),
                            ),
                          ),
                        if (controller.isScreenMode.value == ScreenMode.EDIT)
                          const SizedBox(width: AppSize.kPadding / 2),
                        Expanded(
                          child: CustomButton(
                            text:
                                controller.isScreenMode.value == ScreenMode.VIEW
                                    ? 'Chỉnh sửa'
                                    : "Lưu chỉnh sửa",
                            onPressed: () => controller.saveTribeTree(),
                          ),
                        ),
                      ],
                    ))
                : Container())
          ],
        ),
      ),
    );
  }

  Stack _buildMainContentView(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            'assets/images/bg.svg',
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
            top: 360 * (0.2 / 4.5),
            left: 360 * (0.4 / 4.5),
            right: 360 * (0.4 / 4.5),
            child: Container(
              height: 360 * (0.5 / 4.5),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_12.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(
                width: 360 * (0.5 / 4.5),
                height: 360 * (0.5 / 4.5) / 2.5,
                margin: const EdgeInsets.only(top: AppSize.kPadding / 2),
                alignment: Alignment.center,
                child: AutoSizeText(
                  "${dashboardController.tribe.value?.name}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontFamily: "davida",
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                  minFontSize: 5,
                ),
              ),
            )),
        Positioned(
          top: 360 * (0.25 / 4.5),
          right: 360 * (0.4 / 5),
          child: Image.asset(
            'assets/images/img_10.png',
            fit: BoxFit.cover,
            width: 360 * (0.8 / 4.5),
          ),
        ),
        Positioned(
          top: 360 * (0.25 / 4.5),
          left: 360 * (0.4 / 5),
          child: Image.asset(
            'assets/images/img_11.png',
            fit: BoxFit.cover,
            width: 360 * (0.8 / 4.5),
          ),
        ),
        Positioned(
          left: AppSize.kPadding,
          right: AppSize.kPadding,
          top: 360 * (0.7 / 4.5),
          child: Container(
            width: 360 - AppSize.kPadding * 3,
            height: (360 - AppSize.kPadding) * (2 / 3) - 360 * (0.8 / 4.5),
            alignment: Alignment.center,
            // color: Colors.red,
            child: Obx(() => Stack(
                  children: [
                    CustomPaint(
                      size: MediaQuery.of(context).size,
                      painter: TreePainter(
                          controller.tree.value,
                          controller.lines.value,
                          controller.updatedLines.value),
                    ),
                    ...controller.blocks.map((block) {
                      return InteractiveNode(
                          block: block, controller: controller);
                    }),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Phả đồ'),
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg', onPressed: () => Get.back()),
      actions: [
        Obx(() => (dashboardController.myInfo.value.role == "ADMIN" ||
                dashboardController.myInfo.value.role == "LEADER")
            ? IconButtonComponent(
                iconPath: 'assets/icons/profile-add.svg',
                iconSize: 32.w,
                iconPadding: 6,
                onPressed: () => DialogHelper.showCustomDialog(
                    "Thêm thành viên",
                    "Bạn muốn thêm thành viên với vai trò nào?", [
                  if (controller.blocks.value.isEmpty)
                    CustomButton(
                      text: 'Tổ tiên',
                      onPressed: () {
                        Get.back();
                        _showAddUserBottomSheet(AddUserMode.ROOT);
                      },
                    ),
                  if (controller.blocks.value.isNotEmpty)
                    CustomButton(
                      text: 'Vợ/Chồng',
                      width: 50.w,
                      onPressed: () {
                        Get.back();
                        _showAddUserBottomSheet(AddUserMode.COUPLE);
                      },
                    ),
                  if (controller.blocks.value.isNotEmpty)
                    CustomButton(
                      text: 'Con cái',
                      width: 50.w,
                      onPressed: () {
                        Get.back();
                        _showAddUserBottomSheet(AddUserMode.CHILD);
                      },
                    ),
                ]),
              )
            : Container()),
        IconButtonComponent(
          iconPath: 'assets/icons/gallery-export.svg',
          iconSize: 32.w,
          iconPadding: 6,
          onPressed: () => controller.capturePng(),
        ),
        IconButtonComponent(
          iconPath: 'assets/icons/rotate.svg',
          iconSize: 32.w,
          iconPadding: 6,
          onPressed: () => controller.rotateFrame(),
        ),
        const SizedBox(width: AppSize.kPadding),
      ],
    );
  }
}
