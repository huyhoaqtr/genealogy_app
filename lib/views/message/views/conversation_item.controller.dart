import 'package:get/get.dart';

import '../../../resources/models/user.model.dart';
import '../../../services/storage/storage_manager.dart';

class ConversationItemController extends GetxController {
  Rx<User> user = Rx<User>(User());

  @override
  void onInit() {
    super.onInit();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final User? localUser = await StorageManager.getUser();
    if (localUser == null) return;
    user.value = localUser;
    update();
  }
}
