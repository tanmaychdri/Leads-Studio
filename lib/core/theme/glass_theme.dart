import 'package:flutter/material.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class GlassTheme {
  // Border Radii
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999));

  // Blur strengths
  static const double blurLight = 8.0;
  static const double blurMedium = 16.0;
  static const double blurHeavy = 24.0;

  // Glass Surface colors based on theme
  static Color getSurfaceColor(BuildContext context, {double opacity = 0.7}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return (isDark ? AppColors.glassSurfaceDark : AppColors.glassSurfaceLight)
        .withValues(alpha: opacity);
  }

  // Border colors based on theme
  static Color getBorderColor(BuildContext context, {double opacity = 0.2}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return (isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight)
        .withValues(alpha: opacity);
  }
  
  // Lightweight list item background (no blur, just translucent color for perf)
  static Color getListItemColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03);
  }

  // Shadows
  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}