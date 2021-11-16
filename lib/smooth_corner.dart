library smooth_corner;

import 'dart:math';

import 'package:flutter/material.dart';

class SmoothRectangleBorder extends OutlinedBorder {
  final double smoothness;
  final double radius;

  SmoothRectangleBorder({
    this.smoothness = 0.0,
    this.radius = 0.0,
    BorderSide side = BorderSide.none,
  }) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();
    if (smoothness == 0) {
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    } else {
      var width = rect.width;
      var height = rect.height;
      var top = rect.top;
      var left = rect.left;
      var bottom = rect.bottom;
      var right = rect.right;

      var centerX = width / 2 + left;

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

      path.moveTo(centerX, top);

      // top right
      path.lineTo(left + max(width / 2, width - p), top);
      path.cubicTo(
        right - (p - a),
        top,
        right - (p - a - b),
        top,
        right - (p - a - b - c),
        top + d,
      );
      path.arcTo(
        Rect.fromCircle(
          center: Offset(right - radius, top + radius),
          radius: radius,
        ),
        (270 + angleBezier).toRadian(),
        (90 - 2 * angleBezier).toRadian(),
        false,
      );
      path.cubicTo(
        right,
        top + (p - a - b),
        right,
        top + (p - a),
        right,
        top + min(height / 2, p),
      );

      //bottom right
      path.lineTo(
        right,
        top + max(height / 2, height - p),
      );
      path.cubicTo(
        right,
        bottom - (p - a),
        right,
        bottom - (p - a - b),
        right - d,
        bottom - (p - a - b - c),
      );
      path.arcTo(
        Rect.fromCircle(
          center: Offset(right - radius, bottom - radius),
          radius: radius,
        ),
        angleBezier.toRadian(),
        (90 - angleBezier * 2).toRadian(),
        false,
      );
      path.cubicTo(
        right - (p - a - b),
        bottom,
        right - (p - a),
        bottom,
        left + max(width / 2, width - p),
        bottom,
      );

      //bottom left
      path.lineTo(left + min(width / 2, p), bottom);
      path.cubicTo(
        left + (p - a),
        bottom,
        left + (p - a - b),
        bottom,
        left + (p - a - b - c),
        bottom - d,
      );

      path.arcTo(
        Rect.fromCircle(
            center: Offset(left + radius, bottom - radius), radius: radius),
        (90 + angleBezier).toRadian(),
        (90 - angleBezier * 2).toRadian(),
        false,
      );

      path.cubicTo(
        left,
        bottom - (p - a - b),
        left,
        bottom - (p - a),
        left,
        top + max(height / 2, height - p),
      );

      //top left
      path.lineTo(left, top + min(height / 2, p));
      path.cubicTo(
        left,
        top + (p - a),
        left,
        top + (p - a - b),
        left + d,
        top + (p - a - b - c),
      );
      path.arcTo(
        Rect.fromCircle(
            center: Offset(left + radius, top + radius), radius: radius),
        (180 + angleBezier).toRadian(),
        (90 - angleBezier * 2).toRadian(),
        false,
      );
      path.cubicTo(
        left + (p - a - b),
        top,
        left + (p - a),
        top,
        left + min(width / 2, p),
        top,
      );

      path.close();
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return SmoothRectangleBorder(radius: radius * t);
  }

  @override
  SmoothRectangleBorder copyWith({BorderSide? side}) {
    return SmoothRectangleBorder(side: side ?? BorderSide.none);
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}
