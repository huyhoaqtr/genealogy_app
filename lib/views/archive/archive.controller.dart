import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';

import '../../resources/models/web3-transaction.model.dart';
import '../../services/contract/file-storage.dart';

class ArchiveController extends GetxController {
  RxList<Web3Transaction> transactions = <Web3Transaction>[].obs;
  final ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPage = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTransactions();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await getMoreTransactions();
      }
    });
  }

  Future<void> getTransactions() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getAllTransactionByTribe(
        page: page.value,
        limit: limit.value,
      );
      if (response.statusCode == 200) {
        transactions.value = response.data!.data!;
        totalPage.value = response.data!.meta!.totalPages!;

        final url = await getFileInfo(transactions.last.blockId);
        print("url: $url");
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMoreTransactions() async {
    if (isLoadMore.value || page.value >= totalPage.value) return;
    page.value++;
    isLoadMore.value = true;

    await getTransactions();

    isLoadMore.value = false;
  }

  Future<String> getFileInfo(String? blockId) async {
    if (blockId == null) return "";
    final fileStorage = FileStorageContract(
      rpcUrl: dotenv.env['CHAIN_NET'] ?? '',
      contractAddress: dotenv.env['CONTRACT_ADDRESS'] ?? '',
      privateKey: dotenv.env['PRIVATE_KEY'] ?? '',
    );
    await fileStorage.initializeContract();
    final file = await fileStorage.getFile(int.parse(blockId));
    return file["ipfsAddress"] ?? "";
  }
}
