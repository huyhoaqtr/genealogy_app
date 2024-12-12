import 'package:get/get.dart';
import 'package:getx_app/resources/api/event.api.dart';

import '../../resources/models/event.model.dart';

class EventController extends GetxController {
  RxList<Event> events = RxList<Event>([]);
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    final response = await EventApi().getAllEvent(
      page: page.value,
      limit: limit.value,
    );

    if (response.statusCode == 201) {
      events.value += response.data?.data ?? [];
      totalPage.value = response.data?.meta?.totalPages ?? 0;
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await EventApi().deleteEvent(eventId: id);

    if (response.statusCode == 200) {
      events.removeWhere((event) => event.sId == id);
      events.refresh();
    }
  }
}
