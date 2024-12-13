import 'package:get/get.dart';
import 'package:getx_app/resources/models/vote.model.dart';
import 'package:getx_app/services/storage/storage_manager.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/vote/vote.controller.dart';

import '../../resources/api/vote.api.dart';
import '../../resources/models/user.model.dart';

class VoteDetailController extends GetxController {
  Rx<User?> myUser = Rx<User?>(null);
  RxString selectedVote = RxString('');
  RxString oldSelectedVote = RxString('');
  Rx<VoteSession> voteSession = Rx<VoteSession>(VoteSession());

  final LoadingController loadingController = Get.find<LoadingController>();
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['voteSession'] != null) {
      voteSession.value = Get.arguments['voteSession'];
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    if (Get.arguments != null && Get.arguments['voteId'] != null) {
      final response =
          await VoteApi().getVoteSessionById(id: Get.arguments['voteId']);
      voteSession.value = response.data!;
    }
    myUser.value = await StorageManager.getUser();
    checkSelectedVote();
  }

  void checkSelectedVote() {
    final userId = myUser.value?.sId;
    if (userId == null) return;
    for (var option in voteSession.value.options!) {
      if (option.votes?.any((vote) => vote.sId == userId) ?? false) {
        selectedVote.value = option.sId!;
        oldSelectedVote.value = option.sId!;
        break;
      }
    }
  }

  void chooseVote(Options option) {
    selectedVote.value = option.sId!;
  }

  Future<void> castVote() async {
    if (selectedVote == oldSelectedVote) return;

    loadingController.show();

    final response = await VoteApi().castVote(
      voteSessionId: voteSession.value.sId!,
      oldOptionId: oldSelectedVote.value,
      newOptionId: selectedVote.value,
    );

    if (response.statusCode == 200 && response.data != null) {
      voteSession.value = response.data!;
      oldSelectedVote.value = selectedVote.value;

      if (Get.isRegistered<VoteController>()) {
        VoteController voteController = Get.find<VoteController>();
        final index = voteController.voteSessions
            .indexWhere((item) => item.sId == voteSession.value.sId);
        if (index != -1) {
          voteController.voteSessions[index] = response.data!;
          voteController.voteSessions.refresh();
        }
      }
    }
    loadingController.hide();
  }
}
