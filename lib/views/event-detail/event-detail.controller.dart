import 'package:get/get.dart';
import 'package:getx_app/resources/api/event.api.dart';

import '../../resources/models/event.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class EventDetailController extends GetxController {
  Rx<Event> event = Event().obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['event'] != null) {
      event.value = Event.fromJson(Get.arguments["event"]);
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    try {
      if (Get.arguments != null && Get.arguments['eventId'] != null) {
        final response =
            await EventApi().getEventById(eventId: Get.arguments['eventId']);
        event.value = response.data!;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    }
  }
}
