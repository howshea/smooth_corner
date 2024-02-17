import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../smooth_corner.dart';

class SmoothOutlineInputBorder extends InputBorder {
  SmoothOutlineInputBorder({
    this.smoothness = 0.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    BorderSide borderSide = BorderSide.none,
  }) : super(borderSide: borderSide);

  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  ///
  /// If radius of X and Y from one corner are not equal, the smallest one will be used.
  final BorderRadiusGeometry borderRadius;

  /// The smoothness of corners.
  ///
  /// The concept comes from a feature called "corner smoothing" of Figma.
  ///
  /// 0.0 - 1.0
  final double smoothness;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is SmoothOutlineInputBorder) {
      return SmoothOutlineInputBorder(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        smoothness: lerpDouble(a.smoothness, smoothness, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is SmoothOutlineInputBorder) {
      return SmoothOutlineInputBorder(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        smoothness: lerpDouble(smoothness, b.smoothness, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  InputBorder copyWith(
      {BorderSide? borderSide,
      BorderRadiusGeometry? borderRadius,
      double? smoothness}) {
    return SmoothOutlineInputBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      smoothness: smoothness ?? this.smoothness,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      smoothness,
      borderRadius,
      borderSide,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SmoothOutlineInputBorder &&
        other.smoothness == smoothness &&
        other.borderRadius == borderRadius &&
        other.borderSide == borderSide;
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(borderRadius
        .resolve(textDirection)
        .toRRect(rect)
        .deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get preferPaintInterior => false;

  Path getPath(RRect rrect) {
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
  bool get isOutline => true;

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    assert(smoothness >= 0 && smoothness <= 1);
    if (rect.isEmpty) return;
    switch (borderSide.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Path path = getPath(borderRadius
            .resolve(textDirection)
            .toRRect(rect)
            .deflate(borderSide.width / 2));
        final Paint paint = borderSide.toPaint()..isAntiAlias = true;
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return SmoothOutlineInputBorder(
      borderRadius: borderRadius * t,
      borderSide: borderSide.scale(t),
    );
  }
}

extension _Math on double {
  double toRadian() => this * pi / 180;
}
