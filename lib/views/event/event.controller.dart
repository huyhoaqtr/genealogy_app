import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:getx_app/resources/api/event.api.dart';

import '../../resources/models/event.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class EventController extends GetxController {
  RxList<Event> events = RxList<Event>([]);
  RxBool isLoading = true.obs;
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    try {
      isLoading.value = true;
      final response = await EventApi().getAllEvent(
        page: page.value,
        limit: limit.value,
      );

      if (response.statusCode == 201) {
        events.value += response.data?.data ?? [];
        totalPage.value = response.data?.meta?.totalPages ?? 0;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final response = await EventApi().deleteEvent(eventId: id);

      if (response.statusCode == 200) {
        events.removeWhere((event) => event.sId == id);
        events.refresh();
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
