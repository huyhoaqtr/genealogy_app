import 'package:get/get.dart';

import 'fund.controller.dart';

class FundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FundController>(() => FundController());
  }
}
