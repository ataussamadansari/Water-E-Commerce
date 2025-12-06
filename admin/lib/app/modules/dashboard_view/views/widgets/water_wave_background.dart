import 'dart:math' as math;
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
      duration: const Duration(seconds: 4),
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
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.5;

    path.moveTo(0, size.height);
    path.lineTo(0, y);

    for (double x = 0; x <= size.width; x++) {
      double wave = 8 *
          math.sin(
              (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) +
          4 *
              math.sin((x / size.width * 3 * math.pi) +
                  (animationValue * 2 * math.pi));

      path.lineTo(x, y + wave);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
