import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/views/calendar/calendar.screen.dart';
import '../notification/notification.screen.dart';
import 'dashboard.controller.dart';
import '../home/home.screen.dart';
import '../message/message.screen.dart';
import '../profile/profile.screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({super.key});

  final List<Widget> screens = [
    HomeScreen(),
    const CalendarScreen(),
    const MessageScreen(),
    const NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => controller.changeBottomBarIndex(index),
          children: screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.only(top: AppSize.kPadding / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCustomNavItem(
              context: context,
              iconPath: "assets/icons/home.svg",
              label: 'familyTree'.tr,
              index: 0,
              pageController: controller.pageController,
              controller: controller,
            ),
            _buildCustomNavItem(
              context: context,
              iconPath: "assets/icons/calendar-2.svg",
              label: 'calendar'.tr,
              index: 1,
              pageController: controller.pageController,
              controller: controller,
            ),
            _buildCustomNavItem(
              context: context,
              iconPath: "assets/icons/messages.svg",
              label: 'chat'.tr,
              index: 2,
              pageController: controller.pageController,
              controller: controller,
            ),
            _buildCustomNavItem(
              context: context,
              iconPath: "assets/icons/notification.svg",
              label: 'notification'.tr,
              index: 3,
              pageController: controller.pageController,
              controller: controller,
            ),
            _buildCustomNavItem(
              context: context,
              iconPath: "assets/icons/user.svg",
              label: 'account'.tr,
              index: 4,
              pageController: controller.pageController,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavItem({
    required BuildContext context,
    required String iconPath,
    required String label,
    required int index,
    required PageController pageController,
    required DashboardController controller,
  }) {
    return Expanded(
      child: ClipOval(
        child: SizedBox(
          child: InkWell(
            onTap: () {
              controller.changeBottomBarIndex(index);
              pageController.jumpToPage(index);
            },
            borderRadius: BorderRadius.circular(AppSize.kRadius),
            child: Container(
              padding:
                  const EdgeInsets.only(bottom: 24, top: 16, left: 8, right: 8),
              child: Obx(() {
                final bool isSelected =
                    controller.currentBottomBarIndex.value == index;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? AppColors.primaryColor
                            : AppColors.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.textColor,
                              fontSize: 10,
                            ),
                        softWrap: false,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
