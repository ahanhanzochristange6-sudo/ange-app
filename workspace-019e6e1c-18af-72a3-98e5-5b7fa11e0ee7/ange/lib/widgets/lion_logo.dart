import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class LionLogo extends StatelessWidget {
  final double size;
  const LionLogo({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LionPainter(),
    );
  }
}

class _LionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint();

    // Flames halo
    paint.shader = RadialGradient(
      colors: [AppTheme.fireRed.withOpacity(0.8), AppTheme.fireOrange.withOpacity(0.0)],
    ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.5));
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), size.width * 0.48, paint);

    // Mane rays
    final manePaint = Paint()
      ..color = AppTheme.fireOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (int i = 0; i < 16; i++) {
      final angle = i * 22.5 * pi / 180;
      final inner = size.width * 0.28;
      final outer = size.width * 0.42;
      canvas.drawLine(
        Offset(cx + inner * cos(angle), cy + inner * sin(angle)),
        Offset(cx + outer * cos(angle), cy + outer * sin(angle)),
        manePaint,
      );
    }

    // Head shape
    final headPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppTheme.fireRed, AppTheme.gold],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.3));
    headPaint.style = PaintingStyle.fill;

    final headPath = Path()
      ..moveTo(cx, cy - size.width * 0.32)
      ..lineTo(cx + size.width * 0.22, cy - size.width * 0.18)
      ..lineTo(cx + size.width * 0.28, cy + size.width * 0.08)
      ..lineTo(cx + size.width * 0.18, cy + size.width * 0.22)
      ..lineTo(cx, cy + size.width * 0.28)
      ..lineTo(cx - size.width * 0.18, cy + size.width * 0.22)
      ..lineTo(cx - size.width * 0.28, cy + size.width * 0.08)
      ..lineTo(cx - size.width * 0.22, cy - size.width * 0.18)
      ..close();
    canvas.drawPath(headPath, headPaint);

    // Ears
    final earPaint = Paint()..color = AppTheme.gold;
    canvas.drawCircle(Offset(cx - size.width * 0.22, cy - size.width * 0.22), size.width * 0.08, earPaint);
    canvas.drawCircle(Offset(cx + size.width * 0.22, cy - size.width * 0.22), size.width * 0.08, earPaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(cx - size.width * 0.12, cy - size.width * 0.06), size.width * 0.035, eyePaint);
    canvas.drawCircle(Offset(cx + size.width * 0.12, cy - size.width * 0.06), size.width * 0.035, eyePaint);

    // Nose
    final nosePaint = Paint()..color = Colors.black;
    final nosePath = Path()
      ..moveTo(cx, cy + size.width * 0.02)
      ..lineTo(cx - size.width * 0.06, cy + size.width * 0.10)
      ..lineTo(cx + size.width * 0.06, cy + size.width * 0.10)
      ..close();
    canvas.drawPath(nosePath, nosePaint);

    // Mouth (black oval)
    final mouthPaint = Paint()..color = Colors.black;
    final mouthRect = Rect.fromCenter(
      center: Offset(cx, cy + size.width * 0.18),
      width: size.width * 0.32,
      height: size.width * 0.14,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mouthRect, Radius.circular(size.width * 0.06)),
      mouthPaint,
    );

    // ANGE hint text line
    final textPaint = Paint()
      ..color = AppTheme.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(cx - size.width * 0.1, cy + size.width * 0.18),
      Offset(cx + size.width * 0.1, cy + size.width * 0.18),
      textPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
