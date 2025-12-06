import 'dart:math' as Math;

import 'package:flutter/material.dart';

class WaterWaveBackground extends StatefulWidget {
  final double height;
  final Color color;

  const WaterWaveBackground({
    super.key,
    required this.height,
    required this.color,
  });

  @override
  State<WaterWaveBackground> createState() => _WaterWaveBackgroundState();
}

class _WaterWaveBackgroundState extends State<WaterWaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            animationValue: _controller.value,
            waveColor: widget.color,
          ),
          size: Size(double.infinity, widget.height),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color waveColor;

  WavePainter({required this.animationValue, required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.75; // Water level

    path.moveTo(0, y);

    // Draw the sine wave
    for (double x = 0; x <= size.width; x++) {
      // Formula: y = A * sin(kx + wt)
      // A = Amplitude (height of wave)
      // k = Frequency (how many waves)
      // wt = Phase shift (animation)

      double wave1 = 10 *
          Math.sin((x / size.width * 2 * Math.pi) + (animationValue * 2 * Math.pi));

      double wave2 = 5 *
          Math.sin((x / size.width * 4 * Math.pi) + (animationValue * 2 * Math.pi) + Math.pi);

      path.lineTo(x, y + wave1 + wave2);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw a second layer for depth
    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, y + 5);
    for (double x = 0; x <= size.width; x++) {
      double wave = 12 *
          Math.sin((x / size.width * 2 * Math.pi) + (animationValue * 2 * Math.pi) + 1.5);
      path2.lineTo(x, y + 5 + wave);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return true;
  }
}

