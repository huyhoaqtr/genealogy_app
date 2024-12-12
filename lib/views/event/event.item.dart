import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/event/event.controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../resources/models/event.model.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key, required this.controller, required this.event});
  final Event event;
  final EventController controller;

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = DateTime.parse(event.startDate!);
    final lunarDates =
        convertSolar2Lunar(startDate.day, startDate.month, startDate.year, 7);
    return GestureDetector(
      onTap: () => Get.toNamed(
        "/event-detail",
        arguments: {"event": event.toJson()},
      ),
      child: Slidable(
        key: ValueKey(event.sId),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            confirmDismiss: () async {
              bool isConfirmed = false;

              DialogHelper.showConfirmDialog(
                "Bạn muốn xoá?",
                "Bạn có muốn xoá sự kiện này không?",
                onConfirm: () {
                  isConfirmed = true;
                  controller.deleteEvent(event.sId!);
                },
                onCancel: () {
                  isConfirmed = false;
                },
              );

              return isConfirmed;
            },
            onDismissed: () => DialogHelper.showConfirmDialog(
              "Bạn muốn xoá?",
              "Bạn có muốn xoá sự kiện này không?",
              onConfirm: () => controller.deleteEvent(event.sId!),
            ),
            closeOnCancel: true,
          ),
          children: [
            SlidableAction(
              onPressed: (context) => DialogHelper.showConfirmDialog(
                "Bạn muốn xoá?",
                "Bạn có muốn xoá sự kiện này không?",
                onConfirm: () => controller.deleteEvent(event.sId!),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xoá',
            ),
          ],
        ),
        child: Container(
            width: Get.width - AppSize.kPadding * 2,
            padding: const EdgeInsets.all(AppSize.kPadding / 2),
            decoration: BoxDecoration(
              color: AppColors.textColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSize.kRadius),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: AppSize.kPadding / 2),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppColors.primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      "${event.title}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: AppSize.kPadding / 1.5),
                    child: Text(
                      "${event.desc}",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: AppSize.kPadding / 1.5),
                    child: Text(
                      "${event.startTime} - DL: ${formatDate(event.startDate!)} - ÂL: ${lunarDates[0]}/${lunarDates[1]}/${lunarDates[2]}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: AppSize.kPadding / 1.5),
                    child: Text(
                      "Tạo bởi: ${event.user?.info?.fullName}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ])),
      ),
    );
  }
}
