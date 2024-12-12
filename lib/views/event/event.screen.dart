import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/text_button.common.dart';
import 'create_event.sheet.dart';
import 'event.controller.dart';
import 'event.item.dart';

class EventScreen extends GetView<EventController> {
  const EventScreen({super.key});

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
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: SlidableAutoCloseBehavior(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getAllEvents();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: Get.width,
                      child: Obx(() => Wrap(
                            spacing: AppSize.kPadding,
                            direction: Axis.vertical,
                            children: [
                              ...controller.events.map(
                                (item) => EventItem(
                                  event: item,
                                  controller: controller,
                                ),
                              ),
                              SizedBox(height: 40.h),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
