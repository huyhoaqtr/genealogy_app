import 'package:get/get.dart';

import 'vote-detail.controller.dart';

class VoteDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoteDetailController>(() => VoteDetailController());
  }
}
