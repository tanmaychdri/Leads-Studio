import 'package:flutter/material.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';

class GlassSnackBar {
  static void show(BuildContext context, String message, {bool isError = false, bool isSuccess = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color? customColor;
    Color? customBorderColor;
    IconData icon = Icons.info_outline;
    Color iconColor = isDark ? Colors.white70 : Colors.black54;

    if (isError) {
      customColor = Colors.redAccent.withValues(alpha: 0.15);
      customBorderColor = Colors.redAccent.withValues(alpha: 0.5);
      icon = Icons.error_outline;
      iconColor = Colors.redAccent;
    } else if (isSuccess) {
      customColor = Colors.green.withValues(alpha: 0.15);
      customBorderColor = Colors.green.withValues(alpha: 0.5);
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    }
    
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      content: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: true,
        opacity: (isError || isSuccess) ? 0.3 : 0.2,
        blur: GlassTheme.blurHeavy,
        color: customColor,
        borderColor: customBorderColor,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
