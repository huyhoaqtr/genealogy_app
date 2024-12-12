import 'package:get/get.dart';
import 'package:getx_app/views/family_tree/family-tree.controller.dart';

import '../../resources/models/tree_member.model.dart';

class PedigreeController extends GetxController {
  RxInt selectLevel = 1.obs;
  RxList<int> levels = <int>[].obs;
  late FamilyTreeController familyTreeController;

  @override
  Future<void> onInit() async {
    super.onInit();
    familyTreeController = Get.put(FamilyTreeController());
    ever<bool>(familyTreeController.isLoading, (isLoading) {
      if (!isLoading) {
        loadAllMembers();
      }
    });
  }

  // Load data
  void loadAllMembers() {
    levels.value = familyTreeController.blocks
        .map((member) => member.level!)
        .toSet()
        .toList();
  }

  List<TreeMember> filterMembers(int level) {
    List<TreeMember> filteredMembers = familyTreeController.blocks
        .where((member) => member.level == level)
        .toList();

    if (filteredMembers.isEmpty) return [];

    Map<String, List<TreeMember>> childrenMap = {
      for (var member in familyTreeController.blocks)
        if (member.parent != null) member.parent!: []
    };

    for (var member in familyTreeController.blocks) {
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
