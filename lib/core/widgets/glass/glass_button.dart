import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/app/theme/app_colors.dart';
import 'dart:ui';

class GlassButton extends StatefulWidget {
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
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    if (widget.isPrimary) {
      bgColor = AppColors.primary.withValues(alpha: widget.opacity);
    } else {
      bgColor = GlassTheme.getSurfaceColor(context, opacity: widget.opacity);
    }

    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onPressed != null ? (_) {
        _controller.reverse();
        widget.onPressed!();
      } : null,
      onTapCancel: widget.onPressed != null ? () => _controller.reverse() : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius: GlassTheme.radiusMedium,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
            child: Container(
              color: bgColor,
              child: Container(
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: GlassTheme.radiusMedium,
                  border: Border.all(
                    color: widget.isPrimary 
                        ? Colors.white.withValues(alpha: 0.2) 
                        : GlassTheme.getBorderColor(context, opacity: 0.3),
                    width: 1,
                  ),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.isPrimary 
                        ? Colors.white 
                        : (isDark ? Colors.white : AppColors.textPrimaryLight),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.isPrimary 
                          ? Colors.white 
                          : (isDark ? Colors.white : AppColors.textPrimaryLight),
                    ),
                    child: Center(child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}