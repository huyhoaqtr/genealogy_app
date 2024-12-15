import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/lunar/holiday.dart';
import 'package:intl/intl.dart';

import '../../constants/app_size.dart';
import '../../resources/models/weather.dart';
import '../../utils/lunar/date_utils.dart';
import '../../utils/lunar/lunar_day_tasks.dart';
import '../../utils/string/string.dart';

import '../../constants/app_colors.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'calendar.controller.dart';
import 'view/weather-icon.dart';

class CalendarScreen extends GetView<CalendarController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderDateView(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.selectedDate.value = DateTime.now();
              await controller.loadWeatherData();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: Get.width,
                color: Colors.grey.shade100,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSize.kPadding / 2),
                    _buildCanChiDay(context),
                    const SizedBox(height: AppSize.kPadding / 2),
                    _buildGioHoangDao(context),
                    const SizedBox(height: AppSize.kPadding / 2),
                    _buildWeather(context),
                    const SizedBox(height: AppSize.kPadding / 2),
                    _buildTietKhi(context),
                    const SizedBox(height: AppSize.kPadding / 2),
                    _buildTasksForDay(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildHeaderDateView(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        final DateTime selectedDate = controller.selectedDate.value;
        final lunarSelectedDate = convertSolar2Lunar(
            selectedDate.day, selectedDate.month, selectedDate.year, 7);
        final newJdn = jdn(
          selectedDate.day,
          selectedDate.month,
          selectedDate.year,
        );
        final dayChi = getChiDay(newJdn);
        final isHoangDao = checkHoangDao(lunarSelectedDate[1], dayChi);
        final isHacDao = checkHacDao(lunarSelectedDate[1], dayChi);
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.getDayOfWeek(selectedDate)}, ${DateFormat('dd MMMM, yyyy', 'vi').format(selectedDate)}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${lunarSelectedDate[0].abs()} Tháng ${lunarSelectedDate[1]} Âm lịch, Năm ${getCanChiYear(lunarSelectedDate[2])}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        margin:
                            const EdgeInsets.only(right: AppSize.kPadding / 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isHoangDao
                              ? Colors.green
                              : isHacDao
                                  ? Colors.grey
                                  : Colors.transparent,
                        ),
                      ),
                      if (isHoangDao || isHacDao)
                        Text(
                          isHoangDao ? "Ngày hoàng đạo" : "Ngày hắc đạo",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: isHoangDao ? Colors.green : Colors.grey,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSize.kPadding / 2),
            IconButtonComponent(
              iconPath: 'assets/icons/calendar-2.svg',
              iconSize: 38,
              iconPadding: 6,
              onPressed: () => DialogHelper.showDatePickerDialog(
                initialDate: controller.selectedDate.value,
                onSelectedDate: (value) => {
                  controller.selectedDate.value = value,
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Container _buildCanChiDay(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        final lunarDates = convertSolar2Lunar(
          controller.selectedDate.value.day,
          controller.selectedDate.value.month,
          controller.selectedDate.value.year,
          7,
        );

        final newJdn = jdn(
          controller.selectedDate.value.day,
          controller.selectedDate.value.month,
          controller.selectedDate.value.year,
        );

        final dayCanChi = getCanDay(newJdn);
        final hourCanChi = getCurrentCanChiHour(newJdn, DateTime.now());
        final monthCanChi = getCanChiMonth(lunarDates[1], lunarDates[2]);
        final String? holidayName =
            getHoliday("${lunarDates[0]}/${lunarDates[1]}");
        return Column(
          children: [
            if (holidayName != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(holidayName,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            Row(children: [
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giờ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    hourCanChi,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: "davida",
                          color: AppColors.primaryColor,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ngày",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    dayCanChi,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: "davida",
                          color: AppColors.primaryColor,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tháng",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    monthCanChi,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: "davida",
                          color: AppColors.primaryColor,
                        ),
                  ),
                ],
              ),
              const Spacer()
            ]),
          ],
        );
      }),
    );
  }

  Widget _buildWeather(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        WeatherModel weather = controller.weather.value;
        if (weather.weather == null) {
          return Container();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Thời tiết hôm nay",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                SvgPicture.asset(
                  "assets/icons/location.svg",
                  width: 12.w,
                ),
                const SizedBox(width: AppSize.kPadding / 4),
                Text(
                  controller.location.value.locality ?? "",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: WeatherIcon(weatherId: weather.weather![0].id ?? 800),
                ),
                const SizedBox(width: AppSize.kPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${kelvinToCelsius(weather.main!.temp!)}°C",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16.sp),
                    ),
                    Text(
                      capitalizeFirstLetter(weather.weather![0].description!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            Row(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "ĐỘ ẨM",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey, fontSize: 10.sp),
                    ),
                    Text("${weather.main!.humidity}%",
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "TỐC ĐỘ GIÓ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey, fontSize: 10.sp),
                    ),
                    Text(
                        "${(weather.wind!.speed! * 3.6).toStringAsFixed(2)} km/h",
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "ÁP SUẤT",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey, fontSize: 10.sp),
                    ),
                    Text("${weather.main!.seaLevel} hPa",
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "HƯỚNG GIÓ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey, fontSize: 10.sp),
                    ),
                    Text(getWindDirection(weather.wind!.deg),
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
                const Spacer(),
              ],
            )
          ],
        );
      }),
    );
  }

  Widget _buildTietKhi(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tiết khí",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: AppSize.kPadding / 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                getSolarTerm(
                  controller.selectedDate.value.year,
                  controller.selectedDate.value.month,
                  controller.selectedDate.value.day,
                ),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTasksForDay(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        final DateTime selectedDate = controller.selectedDate.value;
        final lunarSelectedDate = convertSolar2Lunar(
            selectedDate.day, selectedDate.month, selectedDate.year, 7);
        final newJdn = jdn(
          selectedDate.day,
          selectedDate.month,
          selectedDate.year,
        );
        final dayCanChi = getCanDay(newJdn);
        final dayChi = getChiDay(newJdn);
        final isHoangDao = checkHoangDao(lunarSelectedDate[1], dayChi);
        final isHacDao = checkHacDao(lunarSelectedDate[1], dayChi);
        final dayType = isHoangDao
            ? DayType.hoangDao
            : isHacDao
                ? DayType.hacDao
                : DayType.binhThuong;

        final int dayOfMonth = lunarSelectedDate[0];
        final Map<String, List<String>> tasks =
            getTasksForDay(dayCanChi, dayType, dayOfMonth: dayOfMonth);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thập nhị trực",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            RichText(
              text: TextSpan(
                text: "Trực: ",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                      text: getThapNhiTruc(
                          lunarSelectedDate[0], lunarSelectedDate[1])[0],
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSize.kPadding / 4),
            RichText(
              text: TextSpan(
                text: getThapNhiTruc(
                    lunarSelectedDate[0], lunarSelectedDate[1])[1],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            RichText(
              text: TextSpan(
                text: "Nên làm: ",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                    text: tasks['shouldDo']!.join(", "),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            RichText(
              text: TextSpan(
                text: "Không nên làm: ",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                    text: tasks['shouldNotDo']!.join(", "),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildGioHoangDao(BuildContext context) {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
        horizontal: AppSize.kPadding,
      ),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Giờ hoàng đạo",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSize.kPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getGioHoangDao(jdFromDate(
                      controller.selectedDate.value.day,
                      controller.selectedDate.value.month,
                      controller.selectedDate.value.year))
                  .map((e) => Column(
                        children: [
                          SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: Image.asset(
                              e["icon"].toString(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: AppSize.kPadding / 3),
                          Text(
                            e["key"].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 14.sp),
                          ),
                          const SizedBox(height: AppSize.kPadding / 3),
                          Text(
                            e["value"].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      ))
                  .toList(),
            )
          ],
        );
      }),
    );
  }
}
