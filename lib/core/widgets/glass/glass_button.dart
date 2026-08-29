import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/app/theme/app_colors.dart';
import 'dart:ui';

class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isPrimary;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    this.onPressed,
    required this.child,
    this.isPrimary = true,
    this.blur = GlassTheme.blurMedium,
    this.opacity = 0.8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    if (isPrimary) {
      bgColor = AppColors.primary.withValues(alpha: opacity);
    } else {
      bgColor = GlassTheme.getSurfaceColor(context, opacity: opacity);
    }

    return ClipRRect(
      borderRadius: GlassTheme.radiusMedium,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: bgColor,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: GlassTheme.radiusMedium,
                border: Border.all(
                  color: isPrimary 
                      ? Colors.white.withValues(alpha: 0.2) 
                      : GlassTheme.getBorderColor(context, opacity: 0.3),
                  width: 1,
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isPrimary 
                      ? Colors.white 
                      : (isDark ? Colors.white : AppColors.textPrimaryLight),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}