import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final double value;
  final double max;

  LevelIndicator(this.value, this.max);

  @override
  Widget build(BuildContext context) {
    const double indicatorRadius = 150;
    final canvasSize = indicatorRadius * 2;

    return CustomPaint(
      size: Size(canvasSize, canvasSize),
      painter: _LevelIndicatorPainter(indicatorRadius, value, max)
    );
  }
}

class _LevelIndicatorPainter extends CustomPainter {
  final double value;
  final double max;
  final double radius;

  _LevelIndicatorPainter(this.radius, this.value, this.max);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    final Offset circleCenter = Offset(radius, radius);

    paint.color = Color.fromARGB(20, 0, 0, 0);
    canvas.drawCircle(circleCenter, radius, paint);
    paint.color = Color.fromARGB(180, 180, 0, 0);
    canvas.drawCircle(circleCenter, radius * value / max, paint);
  }

  @override
  bool shouldRepaint(_LevelIndicatorPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}