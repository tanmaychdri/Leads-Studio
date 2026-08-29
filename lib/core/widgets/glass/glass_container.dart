import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final bool border;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = GlassTheme.blurMedium,
    this.opacity = 0.7,
    this.border = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? GlassTheme.radiusMedium;

    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: GlassTheme.getSurfaceColor(context, opacity: opacity),
        borderRadius: effectiveRadius,
        border: border ? Border.all(
          color: GlassTheme.getBorderColor(context),
          width: 1.0,
        ) : null,
        boxShadow: GlassTheme.subtleShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      container = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: container,
      );
    }

    if (blur > 0) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: container,
        ),
      );
    }

    return container;
  }
}