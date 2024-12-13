import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ProgressIndicatorComponent extends StatelessWidget {
  const ProgressIndicatorComponent({
    super.key,
    this.size = 40,
    this.strokeWidth = 2,
  });
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
