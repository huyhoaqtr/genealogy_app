import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';
import 'package:getx_app/views/family_tree/family-tree.controller.dart';
import 'package:getx_app/views/family_tree/view/add_user.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../utils/debounce/debounce.dart';
import '../../../utils/diacritic/diacritic.dart';
import '../../../utils/widgets/text_button.common.dart';
import '../../../utils/widgets/textfield.common.dart';

class UserPickerController extends GetxController {
  final AddUserMode mode;
  final RxList<TreeMember> users = <TreeMember>[].obs;
  UserPickerController({required this.mode});
  Rx<TreeMember> selectedUser = Rx<TreeMember>(TreeMember());
  final _debouncer = Debouncer(milliseconds: 200);
  final Rx<TextEditingController> searchController =
      TextEditingController().obs;
  final RxList<TreeMember> filteredUsers = <TreeMember>[].obs;

  final FamilyTreeController treeController = Get.find();
  final AddUserController addUserController = Get.find();

  @override
  void onInit() {
    super.onInit();
    users.value = treeController.blocks;
    filteredUsers.value = treeController.blocks;
    searchController.value.addListener(() {
      _debouncer
          .run(() => _filterData(searchController.value.text, _filterUsers));
    });
  }

  // Generalized method to handle filtering
  void _filterData(String query, Function filterMethod) {
    if (query.isEmpty) {
      filterMethod('');
    } else {
      final normalizedQuery = removeDiacritics(query.toLowerCase());
      filterMethod(normalizedQuery);
    }
  }

  void _filterUsers(String query) {
    filteredUsers.value = users
        .where((block) =>
            block.fullName != null &&
            removeDiacritics(
                    "${block.fullName} ${block.title != null ? "(${block.title})" : ""}"
                        .toLowerCase())
                .contains(query))
        .toList();
  }

  void handleChooseUser(TreeMember user) {
    selectedUser.value = user;
    addUserController.selectedUser.value = user;
    Get.back();
  }

  @override
  void onClose() {
    searchController.close();
    super.onClose();
  }
}

class UserPickerSheetUI extends GetView<UserPickerController> {
  const UserPickerSheetUI({super.key});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchField(),
          _buildFilteredList(context),
          _buildDoneButton(),
        ],
      ),
    );
  }

  // Header with a small indicator
  Widget _buildHeader() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Search bar component
  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
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
  Widget _buildFilteredList(BuildContext context) {
    return Obx(() => Expanded(
          child: _buildList(
              context,
              controller.filteredUsers,
              (item) =>
                  _buildSearchItem(context, item, controller.handleChooseUser)),
        ));
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

  // Single item builder (generic for User, district, ward)
  Widget _buildSearchItem<T>(BuildContext context, T item, Function(T) onTap) {
    return InkWell(
      onTap: () => onTap(item),
      child: Container(
        width: Get.width - AppSize.kPadding * 2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.kPadding,
          vertical: (AppSize.kPadding / 3),
        ),
        child: Obx(() {
          bool isSelected = false;
          String name = '';
          SvgPicture? icon;
          if (item is TreeMember) {
            isSelected = controller.selectedUser == item;
            name =
                "${item.fullName} ${item.title != null ? "(${item.title})" : ""}";
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomButton(
        text: "Xong",
        onPressed: () => Get.back(),
      ),
    );
  }
}
