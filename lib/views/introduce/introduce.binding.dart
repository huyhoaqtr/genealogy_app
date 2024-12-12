import 'package:get/get.dart';

import 'introduce.controller.dart';

class IntroduceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroduceController>(() => IntroduceController());
  }
}
