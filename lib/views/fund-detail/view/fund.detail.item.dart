import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/models/transaction.model.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/string/string.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    bool isDeposit = transaction.type == "DEPOSIT";
    return Container(
      width: Get.width - AppSize.kPadding * 3,
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.kPadding / 2,
          vertical: AppSize.kPadding / 2,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                isDeposit
                    ? "assets/icons/coin-receive.svg"
                    : "assets/icons/coin-send.svg",
                colorFilter: ColorFilter.mode(
                  isDeposit ? Colors.green : Colors.red,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppSize.kPadding),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDeposit ? "Thu" : "Chi",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDeposit ? Colors.green : Colors.red,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            "${isDeposit ? "+" : "-"} ${formatCurrency(transaction.price)}",
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDeposit ? Colors.green : Colors.red,
                                ),
                          ),
                        ),
                      ]),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "${transaction.desc}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Ngày tạo: ${formatDateTimeFromString(transaction.createdAt!)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSize.kPadding / 4),
                  Text(
                    "Người tạo: ${transaction.creator?.info?.fullName}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
