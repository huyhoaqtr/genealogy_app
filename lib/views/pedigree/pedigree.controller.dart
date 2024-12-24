import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../resources/api/tribe.api.dart';
import '../../resources/models/tree_member.model.dart';

class PedigreeController extends GetxController {
  RxInt selectLevel = 1.obs;
  RxList<int> levels = <int>[].obs;
  RxList<TreeMember> blocks = <TreeMember>[].obs;

  RxBool isLoading = false.obs;
  final LoadingController loadingController = LoadingController();

  @override
  void onInit() async {
    super.onInit();
    fetchBlocks();
  }

  Future<void> fetchBlocks() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getTribeTree();

      if (response.statusCode == 200) {
        blocks.value = response.data ?? [];
        loadAllMembers();
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

  // Load data
  void loadAllMembers() {
    levels.value = blocks.map((member) => member.level!).toSet().toList();
  }

  List<TreeMember> filterMembers(int level) {
    List<TreeMember> filteredMembers =
        blocks.where((member) => member.level == level).toList();

    if (filteredMembers.isEmpty) return [];

    Map<String, List<TreeMember>> childrenMap = {
      for (var member in blocks)
        if (member.parent != null) member.parent!: []
    };

    for (var member in blocks) {
      if (member.parent != null) {
        childrenMap[member.parent!]!.add(member);
      }
    }

    for (var member in filteredMembers) {
      member.children = childrenMap[member.sId] ?? [];
    }

    return filteredMembers;
  }
}
