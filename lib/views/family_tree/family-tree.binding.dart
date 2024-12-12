import 'package:get/get.dart';

import 'family-tree.controller.dart';

class FamilyTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyTreeController>(() => FamilyTreeController());
  }
}
