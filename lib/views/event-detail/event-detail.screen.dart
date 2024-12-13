import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/progress_indicator.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../event/create_event.sheet.dart';
import 'event-detail.controller.dart';

class EventDetailScreen extends GetView<EventDetailController> {
  const EventDetailScreen({super.key});

  void _showUpdateEventBottomSheet() {
    Get.lazyPut(() => CreateEventController(
          sheetMode: SheetMode.EDIT,
          event: controller.event.value,
        ));
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
        title: const Text('Chi tết sự kiện'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButtonComponent(
            iconSize: 32.w,
            iconPadding: 6,
            iconPath: 'assets/icons/pen.svg',
            onPressed: () => _showUpdateEventBottomSheet(),
          ),
          const SizedBox(
            width: AppSize.kPadding,
          )
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Obx(() {
          if (controller.event.value.sId == null) {
            return const ProgressIndicatorComponent();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
            child: Obx(() {
              final DateTime startDate =
                  DateTime.parse(controller.event.value.startDate!);
              final lunarDates = convertSolar2Lunar(
                  startDate.day, startDate.month, startDate.year, 7);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.event.value.title}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Thời gian: ${controller.event.value.startTime}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Ngày: ${formatDate(controller.event.value.startDate!)} (DL) - ${lunarDates[0]}/${lunarDates[1]}/${lunarDates[2]} (ÂL)",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Tạo bởi: ${controller.event.value.user?.info?.fullName}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "${controller.event.value.desc}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Đã tạo vào ${formatRelativeOrAbsolute(controller.event.value.createdAt!)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.textColor.withOpacity(0.5)),
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
