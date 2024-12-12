import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool isOutlined;
  final bool disabled;
  final double? height;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.disabled = false,
    this.height = AppSize.kButtonHeight,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
      child: Container(
        color: AppColors.backgroundColor,
        height: height,
        child: isOutlined
            ? OutlinedButton(
                onPressed: disabled ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  minimumSize: Size(width!, height!),
                ),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              )
            : ElevatedButton(
                onPressed: disabled ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: disabled
                      ? AppColors.primaryColor.withOpacity(0.75)
                      : AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  minimumSize: Size(width!, height!),
                ),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
      ),
    );
  }
}
