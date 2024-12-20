import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/models/fund.model.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/string/string.dart';

class FundItem extends StatelessWidget {
  const FundItem({super.key, required this.fund});
  final Fund fund;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding * 2,
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.kRadius),
        onTap: () => Get.toNamed("/fund-detail", arguments: {
          "fundId": fund.sId,
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.kPadding / 2,
            vertical: AppSize.kPadding / 2,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset("assets/icons/wallet.svg"),
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
                          Expanded(
                            child: Text(
                              "${fund.title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: SvgPicture.asset(
                              "assets/icons/award.svg",
                              colorFilter: const ColorFilter.mode(
                                Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                          )
                        ]),
                    const SizedBox(height: AppSize.kPadding / 4),
                    Text(
                      "Tiến độ: ${formatCurrency(fund.totalDeposit)} / ${formatCurrency(fund.amount)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSize.kPadding / 4),
                    Text(
                      "Ngày tạo: ${formatDateTimeFromString(fund.createdAt!)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSize.kPadding / 4),
                    Text(
                      "Người tạo: ${fund.creator?.info?.fullName}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
