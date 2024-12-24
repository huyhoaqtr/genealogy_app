import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../resources/api/tribe.api.dart';
import '../../resources/models/tree_member.model.dart';
import '../../utils/debounce/debounce.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/loading/loading.controller.dart';

class ContactController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<TreeMember> blocks = <TreeMember>[].obs;
  RxList<TreeMember> filteredBlocks = <TreeMember>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  final LoadingController loadingController = LoadingController();
  RxString searchText = ''.obs;
  final Debouncer _debouncer = Debouncer(milliseconds: 250);

  @override
  void onInit() async {
    super.onInit();
    fetchBlocks();
    searchController.value.addListener(() {
      searchText.value = searchController.value.text.trim();
      if (searchText.value.isNotEmpty) {
        _debouncer.run(() => handleSearchBlocks(searchText.value));
      } else {
        filteredBlocks.value = blocks;
      }
    });
  }

  Future<void> fetchBlocks() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getTribeTree();
      if (response.statusCode == 200) {
        List<TreeMember> treeMembers = response.data ?? [];

        List<TreeMember> allBlocks = [];

        for (var member in treeMembers) {
          allBlocks.add(member);
          if (member.couple != null && member.couple!.isNotEmpty) {
            allBlocks.addAll(member.couple!);
          }
        }
        blocks.value = allBlocks;
        filteredBlocks.value = allBlocks;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleSearchBlocks(String query) {
    filteredBlocks.value = blocks
        .where((member) =>
            (member.fullName != null &&
                member.fullName!.toLowerCase().contains(query.toLowerCase())) ||
            (member.phoneNumber != null &&
                member.phoneNumber!
                    .toLowerCase()
                    .contains(query.toLowerCase())))
        .toList();
  }
}
