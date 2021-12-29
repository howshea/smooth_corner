import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SmoothBorderDebug extends SmoothRectangleBorder {
  SmoothBorderDebug({
    double smoothness = 0.0,
    BorderSide side = BorderSide.none,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) : super(
          smoothness: smoothness,
          side: side,
          borderRadius: borderRadius,
        );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    super.paint(canvas, rect);
    if (borderRadius == BorderRadius.zero) return;

    var paint = Paint()..color = Colors.redAccent;
    var width = rect.width;
    var height = rect.height;
    var top = rect.top;
    var left = rect.left;
    var right = rect.right;

    var debugCorner = Corner(
        borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width),
        CornerLocation.tr,
        smoothness);

    var radius = debugCorner.radius;

    var p = debugCorner.p;

    double angleBezier = debugCorner.angleBezier;
    double angleCircle = debugCorner.angleCircle;

    var l = sin(angleCircle.toRadian() / 2) * radius * pow(2, 0.5);
    var c = debugCorner.c;
    var d = debugCorner.d;
    var b = debugCorner.b;
    var a = debugCorner.a;

    canvas.drawCircle(
        Offset(right - radius - side.width, top + radius + side.width),
        radius,
        Paint()..color = Colors.black12);

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(right - radius - side.width, top + radius + side.width),
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
        Offset(left + max(width / 2, width - p) - side.width, top + side.width),
        5,
        pointPaint);

    canvas.drawCircle(
        Offset(right - (p - a - b - c) - side.width, top + d + side.width),
        5,
        pointPaint);

    canvas.drawCircle(Offset(right - d - side.width, top + d + l + side.width),
        5, pointPaint);

    canvas.drawCircle(
        Offset(right - side.width, top + min(height / 2, p) + side.width),
        5,
        pointPaint);
  }

  @override
  SmoothBorderDebug scale(double t) {
    return SmoothBorderDebug(borderRadius: borderRadius * t);
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}
