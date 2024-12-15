import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/models/web3-transaction.model.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'archive-detail.controller.dart';

class ArchiveDetailScreen extends GetView<ArchiveDetailController> {
  const ArchiveDetailScreen({super.key});

  // The method to fetch the file URL
  Future<String> getFileUrl(Web3Transaction transaction) async {
    final url = await getFileInfo(transaction.blockId);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSize.kPadding),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    "Địa chỉ hash: ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                IconButtonComponent(
                  iconSize: 32,
                  iconPath: "./assets/icons/clipboard.svg",
                  onPressed: () =>
                      copyTribeCode("${controller.transaction.value.txHash}"),
                  iconPadding: 6,
                ),
                TextButton(
                  onPressed: () => openUrl(
                      "https://holesky.etherscan.io/tx/${controller.transaction.value.txHash}"),
                  child: Text(
                    "Xem",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              Text(
                controller.transaction.value.txHash!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              // FutureBuilder to display file URL
              Row(children: [
                Expanded(
                  child: Text(
                    "File url: ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                IconButtonComponent(
                  iconSize: 32,
                  iconPath: "./assets/icons/clipboard.svg",
                  onPressed: () async {
                    DialogHelper.showToast("Đang tải lên...", ToastType.info);
                    final url = await getFileUrl(controller.transaction.value);
                    copyTribeCode(url);
                  },
                  iconPadding: 6,
                ),
                TextButton(
                  onPressed: () async {
                    DialogHelper.showToast("Đang tải lên...", ToastType.info);
                    final url = await getFileUrl(controller.transaction.value);
                    openUrl(url);
                  },
                  child: Text(
                    "Xem",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              FutureBuilder<dynamic>(
                future: getFileUrl(controller.transaction.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.red),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;

                    if (data is Map<String, dynamic>) {
                      return Text(
                        obfuscateHash("${data['data']}", 10),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }

                    if (data is String) {
                      return Text(
                        data,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }

                    return Text(
                      'Invalid data format',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  } else {
                    return Text(
                      'No data available',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                },
              ),
              const SizedBox(height: AppSize.kPadding / 2),
              Text(
                "Tạo bởi: ${controller.transaction.value.user?.info?.fullName} - ${formatDate(controller.transaction.value.createdAt!, format: 'hh:mm dd/MM/yyyy')}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
