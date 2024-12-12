import 'package:get/get.dart';

import '../../resources/models/event.model.dart';

class EventDetailController extends GetxController {
  Rx<Event> event = Event().obs;

  @override
  void onInit() {
    super.onInit();

    final payload = Get.arguments["event"];
    if (payload != null) {
      event.value = Event.fromJson(payload);
    }
  }
}
