import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import '../../resources/models/vote.model.dart';
import '../../utils/widgets/loading/loading.controller.dart';
import '../../resources/api/vote.api.dart';

class VoteController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<VoteSession> voteSessions = RxList<VoteSession>([]);

  final LoadingController loadingController = Get.find();
  @override
  void onInit() {
    super.onInit();
    getAllVoteSession();
  }

  Future<void> getAllVoteSession() async {
    isLoading.value = true;
    var response = await VoteApi().getAllVoteSession();
    if (response.statusCode == 201) {
      voteSessions.value = response.data!;
    }
    isLoading.value = false;
  }

  List<Options> filterOptions(List<Options> options) {
    //sort by votes
    options.sort((a, b) => b.votes!.length.compareTo(a.votes!.length));
    return options;
  }

  //delete vote session
  Future<void> deleteVoteSession(String id) async {
    loadingController.show();

    try {
      final response = await VoteApi().deleteVoteSession(id: id);
      if (response.statusCode == 200) {
        voteSessions.removeWhere((session) => session.sId == id);
        DialogHelper.showToast(
          "Xóa biểu quyết thành công",
          ToastType.success,
        );
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}
