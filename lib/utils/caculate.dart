import 'package:flutter/material.dart';

double calculateHeight(String text, TextStyle style, double maxWidth) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textDirection: TextDirection.ltr,
    maxLines: null, // Không giới hạn số dòng
  )..layout(maxWidth: maxWidth); // Thiết lập chiều rộng tối đa cho text

  return textPainter.size.height;
}
