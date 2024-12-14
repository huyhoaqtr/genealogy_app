import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/event.api.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/event-detail/event-detail.controller.dart';
import 'package:getx_app/views/event/event.controller.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../resources/models/event.model.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/picker/picker.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';

enum SheetMode { EDIT, ADD }

class CreateEventController extends GetxController {
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descController = TextEditingController().obs;
  late Rx<DateTime?> selectedDate;
  RxString selectedTime = "".obs;
  Rx<String> titleError = "".obs;
  Rx<String> descError = "".obs;
  Rx<String> timeError = "".obs;

  final SheetMode sheetMode;
  final Event? event;

  CreateEventController({required this.sheetMode, this.event});

  final EventController eventController = Get.find();
  final LoadingController loadingController = Get.find();

  @override
  void onInit() {
    super.onInit();
    selectedDate = Rx<DateTime?>(null);

    if (event != null && sheetMode == SheetMode.EDIT) {
      titleController.value.text = event!.title ?? "";
      descController.value.text = event!.desc ?? "";
      selectedTime.value = event!.startTime ?? "";
      selectedDate.value = DateTime.parse(event!.startDate!);
    }
  }

  bool validateFields() {
    bool isValid = true;

    if (titleController.value.text.trim().isEmpty) {
      titleError.value = 'Tiêu đề là bắt buộc';
      isValid = false;
    } else {
      titleError.value = "";
    }

    if (descController.value.text.trim().isEmpty) {
      descError.value = 'Mô tả là bắt buộc';
      isValid = false;
    } else {
      descError.value = "";
    }

    if (selectedDate.value == null || selectedTime.value == "") {
      timeError.value = "Vui chọn thời gian sự kiện";
      isValid = false;
    } else {
      timeError.value = "";
    }

    return isValid;
  }

  Future<void> createEvent() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (validateFields()) {
        loadingController.show();
        final response = await EventApi().createEvent(
          title: titleController.value.text,
          desc: descController.value.text,
          startTime: selectedTime.value,
          startDate: selectedDate.value!.toIso8601String(),
        );

        if (response.statusCode == 200) {
          eventController.events.insert(0, response.data!);
          eventController.events.refresh();
          Get.back();
        }
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
          "Có lỗi xây ra, vui lòng thử lại sau", ToastType.warning);
    } finally {
      loadingController.hide();
    }
  }

  Future<void> updateEvent() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (validateFields()) {
        loadingController.show();

        final response = await EventApi().updateEvent(
          eventId: event!.sId!,
          title: titleController.value.text,
          desc: descController.value.text,
          startTime: selectedTime.value,
          startDate: selectedDate.value!.toIso8601String(),
        );

        if (response.statusCode == 201) {
          final EventDetailController eventDetailController = Get.find();
          final int index =
              eventController.events.indexWhere((e) => e.sId == event!.sId);

          if (index != -1) {
            eventController.events[index] = response.data!;
            eventDetailController.event.value = response.data!;
          }

          eventController.events.refresh();
          Get.back();
        }
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
          "Có lỗi xây ra, vui lòng thử lại sau", ToastType.warning);
    } finally {
      loadingController.hide();
    }
  }
}

class CreateEventSheetUI extends GetView<CreateEventController> {
  const CreateEventSheetUI({super.key});

  void showTimePicker(BuildContext context) {
    int selectedHour = 0;
    int selectedMinute = 0;

    var minutePicker = Picker(
      adapter: PickerDataAdapter<String>(data: [
        ...List.generate(
          60,
          (index) => PickerItem(
              text: Text(
            index.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        ),
      ]),
      selecteds: [selectedMinute],
    );

    var hourPicker = Picker(
      adapter: PickerDataAdapter<String>(data: [
        ...List.generate(
          24,
          (index) => PickerItem(
              text: Text(
            index.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        ),
      ]),
      selecteds: [selectedHour],
    );

    // Hiển thị Dialog với Picker
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chọn thời gian',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: hourPicker.makePicker(),
                        ),
                      ),
                      Text(":", style: Theme.of(context).textTheme.bodyLarge),
                      Expanded(
                        child: SizedBox(
                          child: minutePicker.makePicker(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    text: "Xác nhận",
                    height: 40,
                    onPressed: () {
                      controller.selectedTime.value =
                          "${hourPicker.selecteds[0].toString().padLeft(2, '0')}:${minutePicker.selecteds[0].toString().padLeft(2, '0')}";
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.75,
      padding: const EdgeInsets.only(top: AppSize.kPadding / 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
              child: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                    direction: Axis.vertical,
                    spacing: AppSize.kPadding / 2,
                    children: [
                      _buildSheetItem(
                        context,
                        "Tiêu đề",
                        Obx(() => TextFieldComponent(
                              controller: controller.titleController.value,
                              hintText: "Nhập tiêu đề sự kiện",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText: controller.titleError.value.isNotEmpty
                                  ? controller.titleError.value
                                  : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Thời gian",
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => showTimePicker(context),
                                  child: Obx(() => Container(
                                        height: AppSize.kButtonHeight,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.kPadding),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppSize.kRadius),
                                          border: Border.all(
                                            color: controller
                                                    .timeError.value.isNotEmpty
                                                ? AppColors.errorColor
                                                : AppColors.textColor
                                                    .withOpacity(0.6),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(() {
                                              return Text(
                                                controller.selectedTime.value ==
                                                        ""
                                                    ? "00:00"
                                                    : controller
                                                        .selectedTime.value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: AppColors.textColor
                                                          .withOpacity(controller
                                                                      .selectedTime
                                                                      .value ==
                                                                  ""
                                                              ? 0.5
                                                              : 1),
                                                    ),
                                              );
                                            }),
                                            const SizedBox(
                                                width: AppSize.kPadding),
                                            SvgPicture.asset(
                                              "assets/icons/clock.svg",
                                              width: 24,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.textColor
                                                    .withOpacity(0.5),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                const SizedBox(width: AppSize.kPadding / 2),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      DialogHelper.showDatePickerDialog(
                                        initialDate:
                                            controller.selectedDate.value,
                                        onSelectedDate: (value) {
                                          controller.selectedDate.value = value;
                                        },
                                      );
                                    },
                                    child: Obx(() => Container(
                                          height: AppSize.kButtonHeight,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppSize.kPadding),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                AppSize.kRadius),
                                            border: Border.all(
                                              color: controller.timeError.value
                                                      .isNotEmpty
                                                  ? AppColors.errorColor
                                                  : AppColors.textColor
                                                      .withOpacity(0.6),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(() {
                                                final DateTime? selectedDate =
                                                    controller
                                                        .selectedDate.value;

                                                final lunarDates =
                                                    selectedDate != null
                                                        ? convertSolar2Lunar(
                                                            selectedDate.day,
                                                            selectedDate.month,
                                                            selectedDate.year,
                                                            7)
                                                        : null;
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (selectedDate == null)
                                                      Text(
                                                        "Chọn ngày sự kiện",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                              color: AppColors
                                                                  .textColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                      ),
                                                    if (selectedDate != null)
                                                      Text(
                                                        "DL: ${DateFormat('dd-MM-yyyy').format(selectedDate)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                    if (selectedDate != null)
                                                      Text(
                                                        "ÂL: ${lunarDates![0]}-${lunarDates[1]}-${lunarDates[2]}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                  ],
                                                );
                                              }),
                                              SvgPicture.asset(
                                                "assets/icons/calendar-2.svg",
                                                width: 24,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.textColor
                                                      .withOpacity(
                                                    controller.selectedDate
                                                                .value !=
                                                            null
                                                        ? 1
                                                        : 0.5,
                                                  ),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                            Obx(() => controller.timeError.value != ""
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.kPadding,
                                      vertical: AppSize.kPadding / 2,
                                    ),
                                    child: Text(
                                      controller.timeError.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color: AppColors.errorColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  )
                                : Container())
                          ],
                        ),
                      ),
                      _buildSheetItem(
                        context,
                        "Mô tả",
                        Obx(() => TextFieldComponent(
                              controller: controller.descController.value,
                              hintText: "Nhập mô tả",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 2,
                              maxLength: 500,
                              errorText: controller.descError.value.isNotEmpty
                                  ? controller.descError.value
                                  : null,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 45.h,
                      )
                    ])),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 50.w,
                height: 5.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSize.kPadding * 1.5,
            left: 16,
            right: 16,
            child: CustomButton(
              text: controller.sheetMode == SheetMode.ADD ? "Xong" : "Cập nhật",
              onPressed: () => controller.sheetMode == SheetMode.ADD
                  ? controller.createEvent()
                  : controller.updateEvent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetItem(BuildContext context, String label, Widget child) {
    return Container(
      width: Get.width - 32.w,
      margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            child,
          ]),
    );
  }
}
