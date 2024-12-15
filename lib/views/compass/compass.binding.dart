import 'package:get/get.dart';

import 'compass.controller.dart';

class CompassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompassController>(() => CompassController());
  }
}
