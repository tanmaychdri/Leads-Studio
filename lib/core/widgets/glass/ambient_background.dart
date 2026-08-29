import 'package:flutter/material.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class AmbientBackground extends StatelessWidget {
  final int pageIndex;

  const AmbientBackground({super.key, this.pageIndex = 0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    // Use screen size to position glows dynamically
    final size = MediaQuery.of(context).size;
    final double blueSize = 400.0;
    final double purpleSize = 500.0;
    
    // Define positions for 2 glows
    double blueTop;
    double blueLeft;
    
    double purpleTop;
    double purpleLeft;
    
    // Animate positions based on the current page index
    switch (pageIndex % 3) {
      case 0: // Dashboard
        blueTop = -100;
        blueLeft = -100;
        
        purpleTop = size.height - purpleSize + 100;
        purpleLeft = size.width - purpleSize + 100;
        break;
      case 1: // Leads
        blueTop = size.height - blueSize + 100;
        blueLeft = -100;
        
        purpleTop = -100;
        purpleLeft = size.width - purpleSize + 100;
        break;
      case 2: // Follow-ups
      default:
        blueTop = -100;
        blueLeft = size.width - blueSize + 100;
        
        purpleTop = size.height - purpleSize + 100;
        purpleLeft = -100;
        break;
    }

    final duration = const Duration(milliseconds: 1200);
    final curve = Curves.easeInOutQuad;

    // Helper to build an animated glow widget
    Widget buildGlow(Color color, double glowSize, double top, double left) {
      return AnimatedPositioned(
        duration: duration,
        curve: curve,
        top: top,
        left: left,
        child: Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          buildGlow(AppColors.glowBlue, blueSize, blueTop, blueLeft),
          buildGlow(AppColors.glowPurple, purpleSize, purpleTop, purpleLeft),
        ],
      ),
    );
  }
}