import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:minimal_timer/configs/colors.dart';

class CircularProgressPainter extends CustomPainter {
  const CircularProgressPainter({
    required this.progress,
    this.hideHandler = false,
  });

  final double progress;
  final bool hideHandler;

  final double _trackWidth = 2.0;
  final double _hadlerWidth = 3.0;
  final double _progressBarWidth = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);

    const startAngle = 0.0;
    final sweepAngle = 2 * math.pi * progress;

    // Track
    final trackPaint = Paint()
      ..color = CustomColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _trackWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress bar
    final progressBarPaint = Paint()
      ..color = CustomColors.primary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _progressBarWidth;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressBarPaint,
    );

    if (!hideHandler) {
      // Dot (handler)
      final dotPaint = Paint()..color = CustomColors.surface;
      final dx = center.dx + radius * math.cos(sweepAngle);
      final dy = center.dy + radius * math.sin(sweepAngle);
      canvas.drawCircle(Offset(dx, dy), _hadlerWidth, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress.hashCode != progress.hashCode;
  }
}
