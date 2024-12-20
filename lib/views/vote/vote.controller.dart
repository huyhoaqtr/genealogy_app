import 'package:get/get.dart';
import 'package:getx_app/resources/models/vote.model.dart';

import '../../resources/api/vote.api.dart';

class VoteController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<VoteSession> voteSessions = RxList<VoteSession>([]);

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
}
