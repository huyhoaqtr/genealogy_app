import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/user.model.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';

class VoteProgressItem extends StatelessWidget {
  const VoteProgressItem({
    super.key,
    required List<User> votePerson,
    required this.percent,
    this.onTap,
    this.isSelect,
    this.onShowUser,
    required this.text,
  }) : _votePerson = votePerson;

  final VoidCallback? onTap;
  final VoidCallback? onShowUser;
  final bool? isSelect;
  final List<User> _votePerson;
  final double percent;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding * 2,
      height: 28,
      margin: const EdgeInsets.only(top: AppSize.kPadding / 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.kRadius),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.kRadius),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: (Get.width - AppSize.kPadding * 2) * (1 - percent),
              bottom: 0,
              child: Container(
                width: Get.width - AppSize.kPadding * 2,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppSize.kRadius),
                    bottomLeft: const Radius.circular(AppSize.kRadius),
                    topRight:
                        Radius.circular(percent < 1 ? 0 : AppSize.kRadius),
                    bottomRight:
                        Radius.circular(percent < 1 ? 0 : AppSize.kRadius),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                height: 8,
                width: Get.width - AppSize.kPadding * 2,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            if (onTap != null && isSelect != null)
                              isSelect == false
                                  ? Container(
                                      width: 16,
                                      height: 16,
                                      margin: const EdgeInsets.only(
                                          right: AppSize.kPadding / 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: AppColors.textColor
                                                .withOpacity(0.5),
                                            width: 1,
                                          )),
                                    )
                                  : Container(
                                      width: 16,
                                      height: 16,
                                      margin: const EdgeInsets.only(
                                          right: AppSize.kPadding / 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                            Text(text,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onShowUser,
                      child: SizedBox(
                        width: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: _votePerson.asMap().entries.map((entry) {
                            int index = entry.key;
                            var item = entry.value;
                            if (_votePerson.length > 3) {
                              if (index < 2) {
                                return Positioned(
                                  right: (index + 1.5) * AppSize.kPadding / 1.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CustomNetworkImage(
                                        width: 16,
                                        height: 16,
                                        imageUrl: "${item.info?.avatar}",
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Positioned(
                                right: 0,
                                child: Text(
                                  "+${_votePerson.length - 2}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              );
                            }

                            return Positioned(
                              right: index * AppSize.kPadding / 1.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CustomNetworkImage(
                                    width: 16,
                                    height: 16,
                                    imageUrl: "${item.info?.avatar}",
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
