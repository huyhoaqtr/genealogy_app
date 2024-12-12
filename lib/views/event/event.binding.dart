import 'package:get/get.dart';

import 'event.controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}
