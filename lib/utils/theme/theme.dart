import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_size.dart';

import '../../constants/app_colors.dart';

ThemeData buildThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primaryColor,
    fontFamily: 'Mulish',
    appBarTheme: buildAppBarTheme(),
    textTheme: buildTextTheme(),
  );
}

// 2. Hàm cho AppBar Theme
AppBarTheme buildAppBarTheme() {
  return AppBarTheme(
    backgroundColor: AppColors.backgroundColor,
    elevation: 0,
    toolbarHeight: 40,
    titleSpacing: 0,
    iconTheme: IconThemeData(color: AppColors.textColor),
    titleTextStyle: TextStyle(
      color: AppColors.textColor,
      fontSize: AppSize.kMediumTextSize,
      fontWeight: FontWeight.w500,
    ),
    centerTitle: true,
    actionsIconTheme: IconThemeData(color: AppColors.textColor),
  );
}

TextTheme buildTextTheme() {
  return TextTheme(
    titleLarge: TextStyle(
        fontSize: AppSize.kHeadingTextSize,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor),
    bodyLarge: TextStyle(
        fontSize: AppSize.kLargeTextSize,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor),
    bodyMedium: TextStyle(
        fontSize: AppSize.kMediumTextSize,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor),
    bodySmall: TextStyle(
        fontSize: AppSize.kSmallTextSize,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor),
    labelSmall: TextStyle(
        fontSize: AppSize.kSuperSmallTextSize,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor),
  );
}
