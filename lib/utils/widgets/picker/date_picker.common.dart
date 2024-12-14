import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../lunar/lunar_solar_utils.dart';
import '../text_button.common.dart';
import 'picker.dart';

class DatePickerController extends GetxController {
  List<String> daysOfWeek = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  Rx<DateTime> displayedDate = DateTime.now().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  dynamic lunarSelectedDate;

  final DateTime? initialDate;

  DatePickerController({this.initialDate});

  @override
  void onInit() {
    if (initialDate != null) {
      selectedDate.value = initialDate!;
      displayedDate.value = initialDate!;
    }

    lunarSelectedDate = convertSolar2Lunar(
      selectedDate.value.day,
      selectedDate.value.month,
      selectedDate.value.year,
      7,
    );
    super.onInit();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    lunarSelectedDate = convertSolar2Lunar(date.day, date.month, date.year, 7);
  }

  void nextMonth() {
    displayedDate.value =
        DateTime(displayedDate.value.year, displayedDate.value.month + 1, 1);
  }

  void previousMonth() {
    displayedDate.value =
        DateTime(displayedDate.value.year, displayedDate.value.month - 1, 1);
  }

  @override
  void onClose() {
    super.onClose();
    displayedDate.value = DateTime.now();
    selectedDate.value = DateTime.now();
  }
}

class DatePickerComponent extends GetView<DatePickerController> {
  const DatePickerComponent({super.key, this.onSelectedDate});
  final void Function(DateTime)? onSelectedDate;

  void showPicker(BuildContext context) {
    int startYear = 1900;
    int selectedYearIndex = controller.displayedDate.value.year - startYear;
    int selectedMonthIndex = controller.displayedDate.value.month - 1;
    var yearPicker = Picker(
      adapter: PickerDataAdapter<String>(data: [
        ...List.generate(
          300,
          (index) => PickerItem(
              text: Text(
            '${index + startYear}',
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        ),
      ]),
      selecteds: [selectedYearIndex],
    );

    var monthPicker = Picker(
      adapter: PickerDataAdapter<String>(data: [
        ...List.generate(
          12,
          (index) => PickerItem(text: Text('${index + 1}')),
        ),
      ]),
      selecteds: [selectedMonthIndex],
    );

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Tháng',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSize.kPadding / 2),
                            SizedBox(
                              height: 150,
                              child: monthPicker.makePicker(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Năm',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSize.kPadding / 2),
                            SizedBox(
                              height: 150,
                              child: yearPicker.makePicker(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.kPadding,
                  ),
                  CustomButton(
                    text: "Xác nhận",
                    height: 40,
                    onPressed: () => {
                      controller.displayedDate.value = DateTime(
                          startYear + yearPicker.selecteds[0],
                          monthPicker.selecteds[0] + 1,
                          controller.selectedDate.value.day),
                      Navigator.of(context).pop()
                    },
                  )
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
    return Obx(() {
      final daysInMonth = DateUtils.getDaysInMonth(
        controller.displayedDate.value.year,
        controller.displayedDate.value.month,
      );
      final firstDayOfWeek = DateTime(controller.displayedDate.value.year,
              controller.displayedDate.value.month, 1)
          .weekday;
      final lastDayOfWeek = DateTime(controller.displayedDate.value.year,
              controller.displayedDate.value.month, daysInMonth)
          .weekday;

      final previousMonthDaysCount = firstDayOfWeek - 1;
      final nextMonthDaysCount = (7 - lastDayOfWeek) % 7;

      List<Widget> dayWidgets = [];

      // Add days from the previous month
      final previousMonthDaysInMonth = DateUtils.getDaysInMonth(
        controller.displayedDate.value.year,
        controller.displayedDate.value.month - 1 == 0
            ? 12
            : controller.displayedDate.value.month - 1,
      );

      for (int i = previousMonthDaysInMonth - previousMonthDaysCount + 1;
          i <= previousMonthDaysInMonth;
          i++) {
        final day = DateTime(
          controller.displayedDate.value.year,
          controller.displayedDate.value.month - 1 == 0
              ? 12
              : controller.displayedDate.value.month - 1,
          i,
        );

        final lunarDates = convertSolar2Lunar(day.day, day.month, day.year, 7);
        final newJdn = jdn(day.day, day.month, day.year);
        final dayCanChi = getChiDay(newJdn);
        final isHoangDao = checkHoangDao(lunarDates[1], dayCanChi);
        final isHacDao = checkHacDao(lunarDates[1], dayCanChi);
        dayWidgets.add(
          InkWell(
            onTap: () {
              controller.selectDate(day);
              controller.previousMonth();
              if (onSelectedDate != null) {
                onSelectedDate!(day);
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                      bottom: 8,
                      left: 5,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isHoangDao
                              ? Colors.green
                              : isHacDao
                                  ? Colors.grey
                                  : Colors.transparent,
                        ),
                      )),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: AppColors.textColor.withOpacity(0.35),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          lunarDates[0].toString() != "1"
                              ? lunarDates[0].abs().toString()
                              : '${lunarDates[0]}/${lunarDates[1]}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: AppColors.textColor.withOpacity(0.35),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Add days from the current month
      for (int i = 1; i <= daysInMonth; i++) {
        final day = DateTime(
          controller.displayedDate.value.year,
          controller.displayedDate.value.month,
          i,
        );

        bool isSelected = day.day == controller.selectedDate.value.day &&
            day.month == controller.selectedDate.value.month &&
            day.year == controller.selectedDate.value.year;

        bool isToday = day.day == DateTime.now().day &&
            day.month == DateTime.now().month &&
            day.year == DateTime.now().year;

        final lunarDates = convertSolar2Lunar(day.day, day.month, day.year, 7);
        final newJdn = jdn(day.day, day.month, day.year);
        final dayCanChi = getChiDay(newJdn);
        final isHoangDao = checkHoangDao(lunarDates[1], dayCanChi);
        final isHacDao = checkHacDao(lunarDates[1], dayCanChi);

        dayWidgets.add(
          InkWell(
            onTap: () {
              controller.selectDate(day);
              if (onSelectedDate != null) {
                onSelectedDate!(day);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : isToday
                        ? AppColors.primaryColor.withOpacity(0.35)
                        : null,
                borderRadius: BorderRadius.circular(AppSize.kRadius),
              ),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              child: Stack(
                children: [
                  Positioned(
                      bottom: 8,
                      left: 5,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isHoangDao
                              ? Colors.green
                              : isHacDao
                                  ? Colors.grey
                                  : Colors.transparent,
                        ),
                      )),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i.toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          lunarDates[0].toString() != "1"
                              ? lunarDates[0].abs().toString()
                              : '${lunarDates[0]}/${lunarDates[1]}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: AppColors.textColor.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Add days from the next month
      for (int i = 1; i <= nextMonthDaysCount; i++) {
        final day = DateTime(
          controller.displayedDate.value.year,
          controller.displayedDate.value.month + 1 == 0
              ? 12
              : controller.displayedDate.value.month + 1,
          i,
        );

        final lunarDates = convertSolar2Lunar(day.day, day.month, day.year, 7);
        final newJdn = jdn(day.day, day.month, day.year);
        final dayCanChi = getChiDay(newJdn);
        final isHoangDao = checkHoangDao(lunarDates[1], dayCanChi);
        final isHacDao = checkHacDao(lunarDates[1], dayCanChi);
        dayWidgets.add(
          InkWell(
            onTap: () {
              controller.selectDate(day);
              controller.nextMonth();
              if (onSelectedDate != null) {
                onSelectedDate!(day);
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                      bottom: 8,
                      left: 5,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isHoangDao
                              ? Colors.green
                              : isHacDao
                                  ? Colors.grey
                                  : Colors.transparent,
                        ),
                      )),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: AppColors.textColor.withOpacity(0.35),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          lunarDates[0].toString() != "1"
                              ? lunarDates[0].abs().toString()
                              : '${lunarDates[0]}/${lunarDates[1]}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: AppColors.textColor.withOpacity(0.35),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonComponent(
                      iconSize: 35,
                      iconPath: "assets/icons/arrow-left.svg",
                      onPressed: () => controller.previousMonth()),
                  GestureDetector(
                    onTap: () => showPicker(context),
                    child: Column(
                      children: [
                        Text(
                          '${DateFormat('MMMM, yyyy', 'vi').format(controller.displayedDate.value).substring(0, 1).toUpperCase()}'
                          '${DateFormat('MMMM, yyyy', 'vi').format(controller.displayedDate.value).substring(1)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${controller.lunarSelectedDate[0].abs()} Tháng ${controller.lunarSelectedDate[1]} Âm lịch, Năm ${getCanChiYear(controller.lunarSelectedDate[2])}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(),
                        ),
                      ],
                    ),
                  ),
                  IconButtonComponent(
                      iconSize: 35,
                      iconPath: "assets/icons/arrow-right.svg",
                      onPressed: () => controller.nextMonth()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: controller.daysOfWeek
                    .map(
                      (item) => Text(item,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                    )
                    .toList(),
              ),
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // Số cột
                childAspectRatio: 4 / 3.65, // Tỉ lệ chiều rộng / chiều cao
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: dayWidgets.length,
              itemBuilder: (context, index) => dayWidgets[index],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.kPadding, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Ngày hoàng đạo",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Ngày hắc đạo",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
