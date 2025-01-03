import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_size.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/common/avatar_image.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../views/dashboard/dashboard.controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../resources/models/user.model.dart';
import 'profile.controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              Obx(() {
                User? user = dashboardController.myInfo.value;
                return Container(
                  padding: const EdgeInsets.all(AppSize.kPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: AvatarImage(
                            imageUrl: "${user.info?.avatar}",
                            size: 50,
                          ),
                        ),
                        const SizedBox(width: AppSize.kPadding),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.info?.fullName}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                getRole("${user.role}"),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ])
                      ]),
                );
              }),
              _buildButtonComponent(
                context,
                "Thông tin cá nhân",
                "assets/icons/user.svg",
                () => Get.toNamed(AppRoutes.userInfo),
              ),
              _buildButtonComponent(
                context,
                "Thay đổi mật khẩu",
                "assets/icons/key-square.svg",
                () => Get.toNamed(AppRoutes.changePassword),
              ),
              _buildButtonComponent(
                context,
                "Kho lưu trữ",
                "assets/icons/box.svg",
                () => Get.toNamed(AppRoutes.archive),
              ),
              _buildButtonComponent(
                context,
                "Bài viết đã đăng",
                "assets/icons/document.svg",
                () => Get.toNamed(AppRoutes.myPost),
              ),
              _buildButtonComponent(
                context,
                "Chính sách bảo mật",
                "assets/icons/security.svg",
                () => openUrl("https://giatocviet.id.vn/privacy-policy.html"),
              ),
              _buildButtonComponent(
                context,
                "Điều khoản sử dụng",
                "assets/icons/security-user.svg",
                () => openUrl(
                    "https://giatocviet.id.vn/terms-and-conditions.html"),
              ),
              _buildButtonComponent(
                context,
                "Đăng xuất",
                "assets/icons/logout.svg",
                () => DialogHelper.showConfirmDialog(
                  "Xác nhận",
                  "Bạn có muốn đăng xuất?",
                  onConfirm: () => controller.logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonComponent(
    BuildContext context,
    String title,
    String iconPath,
    Function() onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.kPadding,
            vertical: AppSize.kPadding,
          ),
          child: Row(
            children: [
              IconButtonComponent(iconPath: iconPath),
              const SizedBox(width: AppSize.kPadding),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: AppSize.kPadding),
              const IconButtonComponent(
                  iconPath: "assets/icons/arrow-right.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
