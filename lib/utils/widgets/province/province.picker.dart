import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../resources/models/province.dart';
import '../../types/type.dart';
import '../text_button.common.dart';
import '../textfield.common.dart';
import 'province.controller.dart';

class ProvincePickerSheetUI extends GetView<ProvincePickerController> {
  const ProvincePickerSheetUI({super.key});

  @override
  Widget build(BuildContext context) {
    final ProvinceLevel level = controller.level;
    return Container(
      width: Get.width,
      height: Get.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchField(),
          _buildFilteredList(level, context),
          _buildDoneButton(),
        ],
      ),
    );
  }

  // Header with a small indicator
  Widget _buildHeader() {
    return Container(
      width: 50.w,
      height: 5.w,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Search bar component
  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      child: TextFieldComponent(
        controller: controller.searchController.value,
        hintText: "Nhập tìm kiếm",
        radius: AppSize.kRadius,
        textInputAction: TextInputAction.search,
        suffixIcon: SvgPicture.asset(
          "assets/icons/search-normal.svg",
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
            AppColors.textColor.withOpacity(0.6),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  // Filtered list view based on the current level
  Widget _buildFilteredList(ProvinceLevel level, BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (level == ProvinceLevel.PROVINCE) {
          return _buildList(
              context,
              controller.filteredProvinces,
              (item) => _buildSearchItem(
                  context, item, controller.handleChooseProvince));
        } else if (level == ProvinceLevel.DISTRICT) {
          return _buildList(
              context,
              controller.filteredDistricts,
              (item) => _buildSearchItem(
                  context, item, controller.handleChooseDistrict));
        } else if (level == ProvinceLevel.WARD) {
          return _buildList(
              context,
              controller.filteredWards,
              (item) =>
                  _buildSearchItem(context, item, controller.handleChooseWard));
        } else {
          return _buildNoResult(context);
        }
      }),
    );
  }

  Widget _buildList<T>(
      BuildContext context, List<T> items, Function(T) itemBuilder) {
    return items.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(items[index]),
          )
        : _buildNoResult(context);
  }

  // Single item builder (generic for province, district, ward)
  Widget _buildSearchItem<T>(BuildContext context, T item, Function(T) onTap) {
    return InkWell(
      onTap: () => onTap(item),
      child: Container(
        width: Get.width - 32.w,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.kPadding.w,
          vertical: (AppSize.kPadding / 3).w,
        ),
        child: Obx(() {
          bool isSelected = false;
          String name = '';
          SvgPicture? icon;
          if (item is Province) {
            isSelected =
                controller.addUserController.selectedProvince.value == item;
            name = item.name!;
            icon = isSelected
                ? SvgPicture.asset(
                    "assets/icons/location-tick.svg",
                    height: 14,
                    width: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.successColor,
                      BlendMode.srcIn,
                    ),
                  )
                : null;
          } else if (item is Districts) {
            isSelected =
                controller.addUserController.selectedDistrict.value == item;
            name = item.name!;
            icon = isSelected
                ? SvgPicture.asset(
                    "assets/icons/location-tick.svg",
                    height: 14,
                    width: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.successColor,
                      BlendMode.srcIn,
                    ),
                  )
                : null;
          } else if (item is Wards) {
            isSelected =
                controller.addUserController.selectedWards.value == item;
            name = item.name!;
            icon = isSelected
                ? SvgPicture.asset(
                    "assets/icons/location-tick.svg",
                    height: 14,
                    width: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.successColor,
                      BlendMode.srcIn,
                    ),
                  )
                : null;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
              ),
              if (icon != null) icon,
            ],
          );
        }),
      ),
    );
  }

  // Display a message when no result is found
  Widget _buildNoResult(BuildContext context) {
    return Center(
      child: Text(
        "Không có kết quả phù hợp",
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.grey),
      ),
    );
  }

  // Done button
  Widget _buildDoneButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomButton(
        text: "Xong",
        onPressed: () => Get.back(),
      ),
    );
  }
}
