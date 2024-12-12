import 'package:get/get.dart';

import 'tree-member.controller.dart';

class TreeMemberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TreeMemberController>(() => TreeMemberController());
  }
}
