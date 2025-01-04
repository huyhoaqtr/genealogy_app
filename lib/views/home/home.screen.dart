import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_routes.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import '../../constants/app_size.dart';
// import '../../services/ads/banner_ads.dart';
import 'home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: (Get.width - AppSize.kPadding * 2),
              height: (Get.width - AppSize.kPadding * 2) * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_12.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: ((Get.width - AppSize.kPadding * 2) * 0.3) / 4,
                  ),
                  width: (Get.width - AppSize.kPadding * 2) / 3.5,
                  height: ((Get.width - AppSize.kPadding * 2) * 0.3) / 3,
                  alignment: Alignment.center,
                  child: Obx(() => AutoSizeText(
                        "${controller.dashboardController.tribe.value?.name}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w800,
                              fontFamily: "davida",
                            ),
                        textAlign: TextAlign.center,
                      )),
                ),
              ),
            ),
            _buildHomeItem(
              context,
              'TỘC PHỔ',
              'Thông tin gia tộc',
              'assets/icons/tribe.svg',
              true,
              AppRoutes.introduce,
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHomeItem(
                  context,
                  'Phả hệ',
                  'Danh sách thành viên',
                  'assets/icons/menu-board.svg',
                  false,
                  AppRoutes.pedigree,
                ),
                const SizedBox(
                  width: AppSize.kPadding / 2,
                ),
                _buildHomeItem(
                  context,
                  'Danh bạ',
                  'Số điện thoại, địa chỉ',
                  'assets/icons/user-square.svg',
                  false,
                  AppRoutes.contact,
                ),
              ],
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            _buildHomeItem(
              context,
              'PHẢ ĐỒ',
              'Xem phả đồ gia tộc',
              'assets/icons/bezier.svg',
              true,
              AppRoutes.familyTree,
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            _buildHomeItem(
              context,
              'PHẢ KÝ',
              'Xem lịch sử, thành tựu gia tộc',
              'assets/icons/printer.svg',
              true,
              AppRoutes.genealogy,
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHomeItem(
                  context,
                  'Sự kiện',
                  'Ngày quan trọng',
                  'assets/icons/calendar-2.svg',
                  false,
                  AppRoutes.event,
                ),
                const SizedBox(
                  width: AppSize.kPadding / 2,
                ),
                _buildHomeItem(
                  context,
                  'Bảng tin',
                  'Dòng thời gian',
                  'assets/icons/calendar-2.svg',
                  false,
                  AppRoutes.feed,
                ),
              ],
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            _buildHomeItem(
              context,
              'Từ đường',
              'Ghi chép, thờ cúng tổ tiên, thắp hương ...',
              'assets/icons/house-2.svg',
              true,
              AppRoutes.church,
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHomeItem(
                  context,
                  'Quỹ gia tộc',
                  'Đóng góp, chi tiêu',
                  'assets/icons/empty-wallet.svg',
                  false,
                  AppRoutes.fund,
                ),
                const SizedBox(
                  width: AppSize.kPadding / 2,
                ),
                _buildHomeItem(
                  context,
                  'Biểu quyết',
                  'Xem biểu quyết',
                  'assets/icons/people.svg',
                  false,
                  AppRoutes.vote,
                ),
              ],
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            _buildHomeItem(
              context,
              'Quyền thành viên',
              'Quyền của các thành viên',
              'assets/icons/permission.svg',
              true,
              AppRoutes.permission,
            ),
            const SizedBox(
              height: AppSize.kPadding / 2,
            ),
            Row(
              children: [
                _buildHomeItem(
                  context,
                  'La bàn',
                  'La bàn phong thuỷ',
                  'assets/icons/compass.svg',
                  false,
                  AppRoutes.compass,
                ),
                const SizedBox(
                  width: AppSize.kPadding / 2,
                ),
                _buildHomeItem(
                  context,
                  'Trợ lí AI',
                  'Giải đáp thắc mắc của bạn',
                  'assets/icons/magic-pen.svg',
                  false,
                  AppRoutes.chatbot,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildHomeItem(BuildContext context, String title,
      String label, String iconPath, bool isBig, String navigatePath) {
    return GestureDetector(
      onTap: () => Get.toNamed(navigatePath),
      child: Container(
        width: !isBig
            ? (Get.width - AppSize.kPadding * 2.5) / 2
            : (Get.width - AppSize.kPadding * 2),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.kPadding, vertical: AppSize.kPadding / 1.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 10.0)),
            const SizedBox(
              height: AppSize.kPadding / 3,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(iconPath, height: 16, width: 16),
              const SizedBox(
                width: AppSize.kPadding / 2,
              ),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppColors.textColor)),
            ])
          ],
        ),
      ),
    );
  }
}
