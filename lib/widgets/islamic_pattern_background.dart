import 'dart:math' as math;

import 'package:flutter/material.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  IslamicPatternPainter({required this.color, this.strokeWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const double step = 60.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _drawEightPointStar(canvas, paint, Offset(x, y), step * 0.35);
      }
    }
  }

  void _drawEightPointStar(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
  ) {
    final path = Path();
    for (int i = 0; i < 16; i++) {
      final double r = (i % 2 == 0) ? radius : radius * 0.55;
      final double angle = i * (math.pi / 8);
      final double px = center.dx + r * math.cos(angle);
      final double py = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
