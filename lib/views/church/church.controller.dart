import 'package:get/get.dart';

import '../../resources/models/tree_member.model.dart';
import '../family_tree/family-tree.controller.dart';

class ChurchController extends GetxController {
  late FamilyTreeController familyTreeController;

  @override
  Future<void> onInit() async {
    super.onInit();
    familyTreeController = Get.put(FamilyTreeController());
  }

  List<TreeMember> filterMembers() {
    List<TreeMember> filteredMembers = [];

    filteredMembers.addAll(
        familyTreeController.blocks.where((member) => member.isDead == true));

    for (var member in familyTreeController.blocks) {
      if (member.couple != null && member.couple!.isNotEmpty) {
        filteredMembers.addAll(
          member.couple!.where((coupleMember) => coupleMember.isDead == true),
        );
      }
    }

    return filteredMembers.isEmpty ? [] : filteredMembers;
  }
}
