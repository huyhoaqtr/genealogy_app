import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';

class TreePainter extends CustomPainter {
  final List<TreeMember> tree;
  final List<Map<String, dynamic>> lines;
  final List<Map<String, dynamic>> updatedLines;

  TreePainter(this.tree, this.lines, this.updatedLines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    for (var line in lines) {
      final start = line['start'] as Offset;
      final end = line['end'] as Offset;

      final path = Path();
      path.moveTo(start.dx, start.dy);

      final intermediate1 = Offset(start.dx, (start.dy + end.dy) / 2);
      final intermediate2 = Offset(end.dx, (start.dy + end.dy) / 2);

      path.lineTo(intermediate1.dx, intermediate1.dy);

      path.lineTo(intermediate2.dx, intermediate2.dy);

      path.lineTo(end.dx, end.dy);

      canvas.drawPath(path, paint);
    }

    for (var line in updatedLines) {
      final start = line['start'] as Offset;
      final end = line['end'] as Offset;

      final path = Path();
      path.moveTo(start.dx, start.dy);

      final intermediate1 = Offset(start.dx, (start.dy + end.dy) / 2);
      final intermediate2 = Offset(end.dx, (start.dy + end.dy) / 2);

      path.lineTo(intermediate1.dx, intermediate1.dy);

      path.lineTo(intermediate2.dx, intermediate2.dy);

      path.lineTo(end.dx, end.dy);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
