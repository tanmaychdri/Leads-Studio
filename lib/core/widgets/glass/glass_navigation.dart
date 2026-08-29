import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'dart:ui';
import 'package:leads_studio/app/theme/app_colors.dart';

class GlassNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GlassNavigationDestination> destinations;

  const GlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
      child: ClipRRect(
        borderRadius: GlassTheme.radiusLarge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: GlassTheme.blurHeavy, sigmaY: GlassTheme.blurHeavy),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: GlassTheme.getSurfaceColor(context, opacity: 0.2),
              borderRadius: GlassTheme.radiusLarge,
              border: Border.all(
                color: GlassTheme.getBorderColor(context, opacity: 0.3),
              ),
              boxShadow: GlassTheme.floatingShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final isSelected = index == selectedIndex;
                final dest = destinations[index];
                
                final targetColor = isSelected 
                    ? AppColors.primaryAccent 
                    : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54);
                
                return GestureDetector(
                  onTap: () => onDestinationSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(end: targetColor),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      builder: (context, color, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                              child: Icon(
                                isSelected ? dest.selectedIcon : dest.icon,
                                key: ValueKey<bool>(isSelected),
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dest.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: color,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassNavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const GlassNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}