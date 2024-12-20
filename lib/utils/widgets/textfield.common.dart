import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_colors.dart';

import '../../constants/app_size.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.radius = AppSize.kRadius * 2,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final bool enabled;
  final String? errorText;
  final double radius;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final int? maxLength;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: AppColors.primaryColor,
      cursorHeight: 12,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.errorColor,
            ),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.textColor.withOpacity(0.5),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: enabled ? AppColors.primaryColor : AppColors.borderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
            width: 1.0,
          ),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSize.kPadding,
          vertical: AppSize.kPadding / 4,
        ),
      ),
    );
  }
}
