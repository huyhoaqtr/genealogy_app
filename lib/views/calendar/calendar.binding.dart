import 'package:get/get.dart';

import 'calendar.controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
