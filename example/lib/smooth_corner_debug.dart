import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SmoothBorderDebug extends SmoothRectangleBorder {
  SmoothBorderDebug({
    double smoothness = 0.0,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) : super(
          smoothness: smoothness,
          borderRadius: borderRadius,
        );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderRadius == BorderRadius.zero) return;

    var paint = Paint()..color = Colors.redAccent;
    var width = rect.width;
    var height = rect.height;
    var top = rect.top;
    var left = rect.left;
    var right = rect.right;

    var debugCorner = Corner(borderRadius.resolve(textDirection).toRRect(rect),
        CornerLocation.tr, smoothness);

    var radius = debugCorner.radius;

    var p = debugCorner.p;

    double angleBezier = debugCorner.angleBezier;
    double angleCircle = debugCorner.angleCircle;

    var l = sin(angleCircle.toRadian() / 2) * radius * pow(2, 0.5);
    var c = debugCorner.c;
    var d = debugCorner.d;
    var b = debugCorner.b;
    var a = debugCorner.a;

    canvas.drawCircle(Offset(right - radius, top + radius), radius,
        Paint()..color = Colors.black12);

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(right - radius, top + radius),
        radius: radius,
      ),
      (270 + angleBezier).toRadian(),
      (90 - 2 * angleBezier).toRadian(),
      true,
      paint,
    );
    var pointPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
        Offset(left + max(width / 2, width - p), top), 5, pointPaint);

    canvas.drawCircle(Offset(right - (p - a - b - c), top + d), 5, pointPaint);

    canvas.drawCircle(Offset(right - d, top + d + l), 5, pointPaint);

    canvas.drawCircle(Offset(right, top + min(height / 2, p)), 5, pointPaint);
  }

  @override
  SmoothBorderDebug scale(double t) {
    return SmoothBorderDebug(borderRadius: borderRadius * t);
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}
