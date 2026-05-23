import 'dart:math';
import 'package:flutter/material.dart';

/// Programmatic grain/noise overlay painter
/// Replaces the need for a noise.png asset
class GrainPainter extends CustomPainter {
  final double opacity;
  final int seed;

  GrainPainter({this.opacity = 0.03, this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    final paint = Paint();
    const step = 4.0; // pixel density of noise dots

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        final gray = random.nextInt(256);
        paint.color = Color.fromRGBO(gray, gray, gray, opacity);
        canvas.drawRect(
          Rect.fromLTWH(x, y, step, step),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GrainPainter oldDelegate) => false;
}

/// Widget wrapper for the grain overlay
class GrainOverlay extends StatelessWidget {
  final double opacity;

  const GrainOverlay({super.key, this.opacity = 0.04});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: GrainPainter(opacity: opacity),
        size: Size.infinite,
      ),
    );
  }
}
