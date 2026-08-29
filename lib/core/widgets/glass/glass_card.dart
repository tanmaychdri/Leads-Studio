import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final double opacity;
  final Color? colorOverride;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.blur = GlassTheme.blurMedium,
    this.opacity = 0.6,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorOverride ?? GlassTheme.getSurfaceColor(context, opacity: opacity),
        borderRadius: GlassTheme.radiusMedium,
        border: Border.all(
          color: GlassTheme.getBorderColor(context, opacity: 0.2),
          width: 1,
        ),
        boxShadow: GlassTheme.subtleShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: GlassTheme.radiusMedium,
        child: card,
      );
    }

    if (blur > 0) {
      return ClipRRect(
        borderRadius: GlassTheme.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: card,
        ),
      );
    }

    return card;
  }
}