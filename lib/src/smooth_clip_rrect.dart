import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SmoothClipRRect extends StatelessWidget {
  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  ///
  /// If radiuses of X and Y from one corner are not equal, the smallest one will be used.
  final BorderRadius borderRadius;

  /// The smoothness of corners.
  ///
  /// The concept comes from a feature called "corner smoothing" of Figma.
  ///
  /// 0.0 - 1.0
  final double smoothness;

  /// The border outline's color and weight.
  ///
  /// If [side] is [BorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final BorderSide side;

  final Widget child;

  const SmoothClipRRect({
    Key? key,
    this.smoothness = 0.0,
    this.borderRadius = BorderRadius.zero,
    this.side = BorderSide.none,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shaper = SmoothRectangleBorder(
      smoothness: smoothness,
      borderRadius: borderRadius - BorderRadius.circular(side.width),
    );
    return CustomPaint(
      child: Padding(
        padding: EdgeInsets.all(max(0.0, side.width - 1)),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: shaper,
          ),
          child: child,
        ),
      ),
      foregroundPainter: _BorderPainter(side, borderRadius, shaper),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final BorderSide side;
  final BorderRadius borderRadius;
  final SmoothRectangleBorder shaper;

  _BorderPainter(this.side, this.borderRadius, this.shaper);
  @override
  void paint(Canvas canvas, Size size) {
    if (side != BorderSide.none &&
        side.style == BorderStyle.solid &&
        side.width > 0) {
      final Path path = shaper.getPath(
        borderRadius.toRRect(Offset.zero & size).deflate(side.width / 2),
      );
      final Paint paint = side.toPaint()..isAntiAlias = true;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderPainter old) {
    return old.side != side ||
        old.borderRadius != borderRadius ||
        old.shaper != shaper;
  }
}
