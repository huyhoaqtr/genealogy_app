import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

import '../../services/ads/ad_manager.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/text_button.common.dart';
import '../family_tree/view/add_user.bottomsheet.dart';
import '../family_tree/view/add_user.controller.dart';
import 'pedigree.controller.dart';

class PedigreeScreen extends GetView<PedigreeController> {
  PedigreeScreen({super.key});

  final DashboardController dashboardController = Get.find();

  void _showAddUserBottomSheet(AddUserMode mode, TreeMember selectedMember) {
    final AddUserController addUserController = Get.put(AddUserController(
      mode: mode,
      sheetMode: SheetMode.ADD,
    ));

    addUserController.selectedUser.value = selectedMember;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
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

  void _showAddMemberDialog(BuildContext context, TreeMember member) {
    DialogHelper.showCustomDialog("Thêm thành viên",
        "Bạn muốn thêm thành viên với vai trò nào?", [
      CustomButton(
        text: 'Vợ/Chồng',
        width: 50,
        onPressed: () {
          Get.back();
          _showAddUserBottomSheet(AddUserMode.COUPLE, member);
        },
      ),
      CustomButton(
        text: 'Con cái',
        width: 50,
        onPressed: () {
          Get.back();
          _showAddUserBottomSheet(AddUserMode.CHILD, member);
        },
      ),
    ]);
  }

  void _showEditUserBottomSheet(AddUserMode mode, TreeMember selectedBlock) {
    Get.lazyPut(() => AddUserController(
          mode: mode,
          sheetMode: SheetMode.EDIT,
          selectedTreeMember: selectedBlock,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
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
      appBar: AppBar(
        title: const Text('Thành viên'),
        centerTitle: false,
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              margin: const EdgeInsets.only(
                  top: AppSize.kPadding / 2, left: AppSize.kPadding / 2),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(() => Column(
                      children: controller.levels.value
                          .map((item) => _buildTabItem(context, item))
                          .toList(),
                    )),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() => Column(
                        children: controller
                            .filterMembers(controller.selectLevel.value)
                            .map((item) => _buildItemGroup(context, item))
                            .toList(),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemGroup(BuildContext context, TreeMember member) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSize.kPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _buildContentItem(context, "PARENT", member),
          if (member.couple != null)
            ...member.couple!
                .map((item) => _buildContentItem(context, "COUPLE", item)),
          if (member.couple!.isNotEmpty && member.children!.isNotEmpty)
            Divider(color: AppColors.borderColor),
          if (member.children != null)
            ...member.children!
                .map((item) => _buildContentItem(context, "CHILD", item)),
        ],
      ),
    );
  }

  Widget _buildContentItem(BuildContext context, String role, TreeMember data) {
    return GestureDetector(
      onTap: () => _showEditUserBottomSheet(AddUserMode.CHILD, data),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: role == "PARENT" ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(AppSize.kRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.kRadius),
                child: CustomNetworkImage(imageUrl: "${data.avatar}"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data.fullName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: role == "PARENT"
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                            if (data.title != null)
                              Text(
                                "${data.title}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: role == "PARENT"
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                          ],
                        ),
                      ),
                      if (role == "PARENT" &&
                          (dashboardController.myInfo.value.role == "ADMIN" ||
                              role == "PARENT" &&
                                  dashboardController.myInfo.value.role ==
                                      "LEADER"))
                        IconButtonComponent(
                          onPressed: () {
                            AdManager.showInterstitialAd(
                              onAdClosed: () =>
                                  _showAddMemberDialog(context, data),
                            );
                          },
                          iconPadding: 5,
                          iconPath: "assets/icons/user-add.svg",
                          iconSize: 24,
                        )
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GT: ${genderOptions.where(
                              (item) => item['value'] == data.gender,
                            ).first['name']}",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Đời: ${data.level}",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      if (role == "PARENT")
                        Text(
                          "Vợ: ${data.couple?.length ?? 0}",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      Text(
                        "Tuổi: ${data.dateOfBirth != null ? calculateAge(
                            data.dateOfBirth!,
                            deathDateString: data.dateOfDeath,
                          ) : "?"}",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Con: ${data.children?.length ?? 0}",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int level) {
    return InkWell(
      onTap: () => controller.selectLevel.value = level,
      borderRadius: BorderRadius.circular(AppSize.kRadius),
      child: Obx(() => Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: level == controller.selectLevel.value
                ? AppColors.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.kRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Đời thứ",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: controller.selectLevel.value == level
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              Text(
                level.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: controller.selectLevel.value == level
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              )
            ],
          ))),
    );
  }
}
