import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getx_app/constants/app_colors.dart';

class IconButtonComponent extends StatelessWidget {
  const IconButtonComponent({
    super.key,
    required this.iconPath,
    this.iconSize = 24.0,
    this.iconColor,
    this.onPressed,
    this.iconPadding = 0.0,
  });

  final String iconPath;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(iconPadding),
        icon: SvgPicture.asset(
          iconPath,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.textColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
