import 'package:get/get.dart';

import 'vote.controller.dart';

class VoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoteController>(() => VoteController());
  }
}
