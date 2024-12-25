import 'package:get/get.dart';
import '../../resources/api/tribe.api.dart';
import '../../resources/models/user.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class PermissionController extends GetxController {
  RxList<User> users = RxList<User>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllMember();
  }

  Future<void> loadAllMember() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getAllMember();
      if (response.statusCode == 200) {
        users.value = response.data ?? [];
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
