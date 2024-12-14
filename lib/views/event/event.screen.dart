import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/progress_indicator.dart';
import '../../utils/widgets/text_button.common.dart';
import '../dashboard/dashboard.controller.dart';
import 'create_event.sheet.dart';
import 'event.controller.dart';
import 'event.item.dart';

class EventScreen extends GetView<EventController> {
  EventScreen({super.key});

  final DashboardController dashboardController = Get.find();

  void _showCreateNewEventBottomSheet() {
    Get.lazyPut(() => CreateEventController(sheetMode: SheetMode.ADD));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const CreateEventSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.delete<CreateEventController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ProgressIndicatorComponent();
              }
              return SlidableAutoCloseBehavior(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getAllEvents();
                  },
                  child: Obx(() {
                    final events = controller.events;

                    if (events.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: Get.height * 0.5,
                            child: Center(
                              child: Text(
                                'Không có sự kiện nào',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: events.length + 1, // +1 for spacing at bottom
                      itemBuilder: (context, index) {
                        if (index == events.length) {
                          return SizedBox(height: 40.h); // Spacing at bottom
                        }

                        final event = events[index];
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSize.kPadding),
                          child: EventItem(
                            event: event,
                            controller: controller,
                          ),
                        );
                      },
                    );
                  }),
                ),
              );
            }),
          ),
          if (dashboardController.myInfo.value.role == 'ADMIN' ||
              dashboardController.myInfo.value.role == 'LEADER')
            Positioned(
              bottom: AppSize.kPadding * 1.5,
              left: 16,
              right: 16,
              child: CustomButton(
                text: "Tạo sự kiện mới",
                onPressed: () => _showCreateNewEventBottomSheet(),
              ),
            ),
        ],
      ),
    );
  }
}
