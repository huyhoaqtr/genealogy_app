import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/web3-transaction.model.dart';
import 'package:getx_app/utils/string/string.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import 'package:getx_app/views/archive/archive.controller.dart';

import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';

class ArchiveDetailScreen extends StatelessWidget {
  ArchiveDetailScreen({super.key, required this.transaction});

  final Web3Transaction transaction;
  final ArchiveController controller = Get.find();

  // The method to fetch the file URL
  Future<String> getFileUrl() async {
    final url = await controller.getFileInfo(transaction.blockId);
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                IconButtonComponent(
                  iconSize: 32,
                  iconPath: "./assets/icons/clipboard.svg",
                  onPressed: () => copyTribeCode("${transaction.txHash}"),
                  iconPadding: 6,
                ),
                TextButton(
                  onPressed: () => openUrl(
                      "https://holesky.etherscan.io/tx/${transaction.txHash}"),
                  child: Text(
                    "Xem",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              Text(
                transaction.txHash!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              // FutureBuilder to display file URL
              Row(children: [
                Expanded(
                  child: Text(
                    "File url: ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                IconButtonComponent(
                  iconSize: 32,
                  iconPath: "./assets/icons/clipboard.svg",
                  onPressed: () async {
                    DialogHelper.showToast("Đang tải lên...", ToastType.info);
                    final url = await getFileUrl();
                    copyTribeCode(url);
                  },
                  iconPadding: 6,
                ),
                TextButton(
                  onPressed: () async {
                    DialogHelper.showToast("Đang tải lên...", ToastType.info);
                    final url = await getFileUrl();
                    openUrl(url);
                  },
                  child: Text(
                    "Xem",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              FutureBuilder<dynamic>(
                future: getFileUrl(),
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
                "Tạo bởi: ${transaction.user?.info?.fullName} - ${formatDate(transaction.createdAt!, format: 'hh:mm dd/MM/yyyy')}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
