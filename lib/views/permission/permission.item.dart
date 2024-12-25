import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../resources/api/tribe.api.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/loading/loading.controller.dart';
import '../../views/dashboard/dashboard.controller.dart';
import '../../views/permission/change_permission.sheet.dart';
import '../../views/permission/permission.sheet.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../resources/models/user.model.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/common/network_image.dart';

class PermissionItemController extends GetxController {
  RxString permission = ''.obs;
  RxBool isDone = false.obs;
  Rx<User> cUser = User().obs;

  final User user;
  PermissionItemController({required this.user});

  final LoadingController loadingController = Get.find();

  @override
  void onInit() {
    super.onInit();
    permission.value = user.role!;
    cUser.value = user;
  }

  void onCancel() {
    permission.value = user.role!;
  }

  Future<void> changePermission(String value) async {
    permission.value = value;
  }

  Future<void> onChangePermission() async {
    loadingController.show();
    try {
      final response = await TribeAPi().updatePermission(
        userId: user.sId!,
        role: permission.value,
      );

      if (response.statusCode == 200) {
        cUser.value = response.data!;
        DialogHelper.showToast(
          "Thay đổi quyền thành công",
          ToastType.success,
        );
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}

class PermissionItemComponent extends StatelessWidget {
  PermissionItemComponent({super.key, required this.user});

  final User user;

  final DashboardController dashboardController = Get.find();

  void showBottomSheet(
      BuildContext context, PermissionItemController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => PermissionSheetComponent(
        onChangePermission: () =>
            showChangePermissionBottomSheet(context, controller),
      ),
    );
  }

  void showChangePermissionBottomSheet(
    BuildContext context,
    PermissionItemController controller,
  ) {
    controller.isDone.value = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => ChangePermissionSheet(
        controller: controller,
      ),
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!controller.isDone.value) {
          controller.onCancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PermissionItemController controller =
        Get.put(PermissionItemController(user: user), tag: user.sId);

    bool isLeader = dashboardController.myInfo.value.role == 'LEADER';
    bool isSameUser = dashboardController.myInfo.value.sId == user.sId;
    return Container(
      width: Get.width - AppSize.kPadding * 2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.kPadding / 2,
        vertical: AppSize.kPadding / 2,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          color: AppColors.textColor.withOpacity(0.05)),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: "${user.info!.avatar}",
            width: 48,
            height: 48,
          ),
          const SizedBox(
            width: AppSize.kPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width - AppSize.kPadding * 3.5 - 48,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${user.info!.fullName}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    if (isLeader && !isSameUser)
                      const SizedBox(width: AppSize.kPadding / 2),
                    if (isLeader && !isSameUser)
                      IconButtonComponent(
                        iconSize: 28,
                        iconPadding: 4,
                        iconPath: "assets/icons/more.svg",
                        onPressed: () => showBottomSheet(context, controller),
                      )
                  ],
                ),
              ),
              Obx(() => Text(
                    "Vai trò: ${getRole("${controller.cUser.value.role}")}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.textColor.withOpacity(0.75),
                        ),
                  )),
              Text(
                "Ngày tham gia: ${formatDateTimeFromString(user.createdAt!)}",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: AppColors.textColor.withOpacity(0.75),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
