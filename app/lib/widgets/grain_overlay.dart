import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Optimized grain/noise overlay that pre-renders to an image
/// instead of drawing thousands of rects every frame.
class GrainOverlay extends StatefulWidget {
  final double opacity;

  const GrainOverlay({super.key, this.opacity = 0.04});

  @override
  State<GrainOverlay> createState() => _GrainOverlayState();
}

class _GrainOverlayState extends State<GrainOverlay> {
  ui.Image? _cachedImage;
  static const int _tileSize = 128; // Small tile that gets repeated

  @override
  void initState() {
    super.initState();
    _generateGrainTile();
  }

  Future<void> _generateGrainTile() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final random = Random(42);
    final paint = Paint();
    const step = 4.0;

    for (double x = 0; x < _tileSize; x += step) {
      for (double y = 0; y < _tileSize; y += step) {
        final gray = random.nextInt(256);
        paint.color = Color.fromRGBO(gray, gray, gray, widget.opacity);
        canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(_tileSize, _tileSize);
    if (mounted) {
      setState(() => _cachedImage = image);
    }
  }

  @override
  void dispose() {
    _cachedImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedImage == null) return const SizedBox.shrink();

    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TiledGrainPainter(image: _cachedImage!),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _TiledGrainPainter extends CustomPainter {
  final ui.Image image;

  _TiledGrainPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.none;
    final tileW = image.width.toDouble();
    final tileH = image.height.toDouble();

    for (double x = 0; x < size.width; x += tileW) {
      for (double y = 0; y < size.height; y += tileH) {
        canvas.drawImage(image, Offset(x, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TiledGrainPainter oldDelegate) =>
      oldDelegate.image != image;
}
