import 'package:get/get.dart';

import 'fund-detail.controller.dart';

class FundDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FundDetailController>(() => FundDetailController());
  }
}
