import 'dart:math';
import 'package:flutter/material.dart';

enum CornerLocation { tl, tr, bl, br }

/// A rectangular border with variable smoothness transitions between
/// the straight sides and the rounded corners.
class SmoothRectangleBorder extends OutlinedBorder {
  SmoothRectangleBorder({
    this.smoothness = 0.0,
    this.borderRadius = BorderRadius.zero,
    BorderSide side = BorderSide.none,
  }) : super(side: side);

  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  ///
  /// If radiuses of X and Y from one corner are not equal, the smallest one will be used.
  final BorderRadiusGeometry borderRadius;

  /// The smoothness of corners.
  ///
  /// The concept comes from a feature called "corner smoothing" of Figma.
  ///
  /// 0.0 - 1.0
  final double smoothness;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(
        borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  }

  Path _getPath(RRect rrect) {
    var path = Path();
    if (smoothness == 0 || borderRadius == BorderRadius.zero) {
      path.addRRect(rrect);
    } else {
      final width = rrect.width;
      final height = rrect.height;
      final top = rrect.top;
      final left = rrect.left;
      final bottom = rrect.bottom;
      final right = rrect.right;

      var centerX = width / 2 + left;

      var tl = Corner(rrect, CornerLocation.tl, smoothness);
      var tr = Corner(rrect, CornerLocation.tr, smoothness);
      var br = Corner(rrect, CornerLocation.br, smoothness);
      var bl = Corner(rrect, CornerLocation.bl, smoothness);

      path.moveTo(centerX, top);

      // top right
      path
        ..lineTo(left + max(width / 2, width - tr.p), top)
        ..cubicTo(
          right - (tr.p - tr.a),
          top,
          right - (tr.p - tr.a - tr.b),
          top,
          right - (tr.p - tr.a - tr.b - tr.c),
          top + tr.d,
        )
        ..arcTo(
          Rect.fromCircle(
            center: Offset(right - tr.radius, top + tr.radius),
            radius: tr.radius,
          ),
          (270 + tr.angleBezier).toRadian(),
          (90 - 2 * tr.angleBezier).toRadian(),
          false,
        )
        ..cubicTo(
          right,
          top + (tr.p - tr.a - tr.b),
          right,
          top + (tr.p - tr.a),
          right,
          top + min(height / 2, tr.p),
        );

      //bottom right
      path
        ..lineTo(
          right,
          top + max(height / 2, height - br.p),
        )
        ..cubicTo(
          right,
          bottom - (br.p - br.a),
          right,
          bottom - (br.p - br.a - br.b),
          right - br.d,
          bottom - (br.p - br.a - br.b - br.c),
        )
        ..arcTo(
          Rect.fromCircle(
            center: Offset(right - br.radius, bottom - br.radius),
            radius: br.radius,
          ),
          br.angleBezier.toRadian(),
          (90 - br.angleBezier * 2).toRadian(),
          false,
        )
        ..cubicTo(
          right - (br.p - br.a - br.b),
          bottom,
          right - (br.p - br.a),
          bottom,
          left + max(width / 2, width - br.p),
          bottom,
        );

      //bottom left
      path
        ..lineTo(left + min(width / 2, bl.p), bottom)
        ..cubicTo(
          left + (bl.p - bl.a),
          bottom,
          left + (bl.p - bl.a - bl.b),
          bottom,
          left + (bl.p - bl.a - bl.b - bl.c),
          bottom - bl.d,
        )
        ..arcTo(
          Rect.fromCircle(
              center: Offset(left + bl.radius, bottom - bl.radius),
              radius: bl.radius),
          (90 + bl.angleBezier).toRadian(),
          (90 - bl.angleBezier * 2).toRadian(),
          false,
        )
        ..cubicTo(
          left,
          bottom - (bl.p - bl.a - bl.b),
          left,
          bottom - (bl.p - bl.a),
          left,
          top + max(height / 2, height - bl.p),
        );

      //top left
      path
        ..lineTo(left, top + min(height / 2, tl.p))
        ..cubicTo(
          left,
          top + (tl.p - tl.a),
          left,
          top + (tl.p - tl.a - tl.b),
          left + tl.d,
          top + (tl.p - tl.a - tl.b - tl.c),
        )
        ..arcTo(
          Rect.fromCircle(
              center: Offset(left + tl.radius, top + tl.radius),
              radius: tl.radius),
          (180 + tl.angleBezier).toRadian(),
          (90 - tl.angleBezier * 2).toRadian(),
          false,
        )
        ..cubicTo(
          left + (tl.p - tl.a - tl.b),
          top,
          left + (tl.p - tl.a),
          top,
          left + min(width / 2, tl.p),
          top,
        );

      path.close();
    }
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Path path = _getPath(borderRadius
            .resolve(textDirection)
            .toRRect(rect)
            .deflate(side.width / 2));
        final Paint paint = side.toPaint();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return SmoothRectangleBorder(
      borderRadius: borderRadius * t,
      side: side.scale(t),
    );
  }

  @override
  SmoothRectangleBorder copyWith(
      {BorderSide? side,
      BorderRadiusGeometry? borderRadius,
      double? smoothness}) {
    return SmoothRectangleBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      side: side ?? this.side,
      smoothness: smoothness ?? this.smoothness,
    );
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}

class Corner {
  late double angleBezier;
  late double angleCircle;
  late double a;
  late double b;
  late double c;
  late double d;
  late double p;
  late double radius;
  late double shortestSide;

  Corner(RRect rrect, CornerLocation location, double smoothness) {
    shortestSide = rrect.shortestSide;

    radius = _getRadius(rrect, location);

    p = min(shortestSide / 2, (1 + smoothness) * radius);

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
    c = longest * cos(angleBezier.toRadian());
    d = c * dToC;
    b = ((p - l) - (1 + dToC) * c) / 3;
    a = 2 * b;
  }

  double _getRadius(RRect rrect, CornerLocation location) {
    double radiusX, radiusY;
    switch (location) {
      case CornerLocation.tl:
        radiusX = rrect.tlRadiusX;
        radiusY = rrect.tlRadiusY;
        break;
      case CornerLocation.tr:
        radiusX = rrect.trRadiusX;
        radiusY = rrect.trRadiusY;
        break;
      case CornerLocation.bl:
        radiusX = rrect.blRadiusX;
        radiusY = rrect.blRadiusY;
        break;
      case CornerLocation.br:
        radiusX = rrect.brRadiusX;
        radiusY = rrect.brRadiusY;
        break;
    }
    var radius = min(radiusX, radiusY);
    return min(radius, shortestSide / 2);
  }
}
