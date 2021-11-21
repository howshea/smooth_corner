import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SmoothBorderDebug extends SmoothRectangleBorder {
  SmoothBorderDebug({
    double smoothness = 0.0,
    double radius = 0.0,
    CornerSetting setting = const CornerSetting.only(),
  }) : super(
          setting: setting,
          smoothness: smoothness,
          radius: radius,
        );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (!setting.topRightEnable) return;

    var paint = Paint()..color = Colors.redAccent;
    var width = rect.width;
    var height = rect.height;
    var top = rect.top;
    var left = rect.left;
    var right = rect.right;
    var shortestSide = min(width, height);
    var radius = this.radius;

    if (this.radius > shortestSide / 2) {
      radius = shortestSide / 2;
    }

    var p = min(shortestSide / 2, (1 + smoothness) * radius);

    double angleBezier, angleCircle;
    if (radius > shortestSide / 4) {
      var changePercentage = (radius - shortestSide / 4) / (shortestSide / 4);
      angleCircle = 90 * (1 - smoothness * (1 - changePercentage));
      angleBezier = 45 * smoothness * (1 - changePercentage);
    } else {
      angleCircle = 90 * (1 - smoothness);
      angleBezier = 45 * smoothness;
    }

    var dToC = tan(angleBezier.toRadian());
    var longest = radius * tan(angleBezier.toRadian() / 2);
    var l = sin(angleCircle.toRadian() / 2) * radius * pow(2, 0.5);
    var c = longest * cos(angleBezier.toRadian());
    var d = c * dToC;
    var b = ((p - l) - (1 + dToC) * c) / 3;
    var a = 2 * b;

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
    return SmoothBorderDebug(radius: radius * t);
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}
