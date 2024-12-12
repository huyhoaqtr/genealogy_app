import 'package:get/get.dart';

import 'event-detail.controller.dart';

class EventDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EventDetailController());
  }
}
