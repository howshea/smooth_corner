import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SmoothContainer extends Container {
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

  /// The border outline's color and weight.
  ///
  /// If [side] is [BorderSide.none], which is the default, an outline is not drawn.
  /// Otherwise the outline is centered over the shape's boundary.
  final BorderSide side;

  SmoothContainer({
    Key? key,
    this.smoothness = 0.6,
    this.borderRadius = BorderRadius.zero,
    this.side = BorderSide.none,
    Widget? child,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? foregroundDecoration,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
  }) : super(
          key: key,
          child: child,
          width: width,
          height: height,
          alignment: alignment,
          padding: padding ?? EdgeInsets.all(side.width),
          foregroundDecoration: foregroundDecoration,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              side: side,
              borderRadius: borderRadius,
              smoothness: smoothness,
            ),
            color: color,
          ),
        );
}
