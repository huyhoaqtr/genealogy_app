import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/archive/archive.controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../resources/models/web3-transaction.model.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/icon_button.common.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({super.key, required this.transaction});

  final Web3Transaction transaction;

  final ArchiveController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/archive-detail", arguments: {
        "transaction": transaction.toJson(),
      }),
      child: Container(
          width: Get.width - AppSize.kPadding * 2,
          padding: const EdgeInsets.all(AppSize.kPadding / 2),
          margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
          decoration: BoxDecoration(
            color: AppColors.textColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppSize.kRadius),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: AppSize.kPadding / 2),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.primaryColor,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          obfuscateHash("${transaction.txHash}", 10),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButtonComponent(
                        iconSize: 28,
                        iconPath: "./assets/icons/clipboard.svg",
                        onPressed: () => copyTribeCode("${transaction.txHash}"),
                        iconPadding: 4,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Padding(
                  padding: const EdgeInsets.only(left: AppSize.kPadding / 1.5),
                  child: FutureBuilder<dynamic>(
                    future: getFileInfo(transaction.blockId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Loading...',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
                            obfuscateHash(data, 10),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        }

                        return Text(
                          'Invalid data format',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        return Text(
                          'No data available',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSize.kPadding / 4),
                Padding(
                  padding: const EdgeInsets.only(left: AppSize.kPadding / 1.5),
                  child: Text(
                    "Tạo bởi: ${transaction.user?.info?.fullName} - ${formatDate(transaction.createdAt!, format: 'hh:mm dd/MM/yyyy')}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ])),
    );
  }
}
