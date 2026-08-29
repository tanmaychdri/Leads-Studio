import 'package:flutter/material.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'dart:ui';

class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onChanged;

  const GlassTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlassTheme.radiusSmall,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: GlassTheme.blurLight, sigmaY: GlassTheme.blurLight),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.getSurfaceColor(context, opacity: 0.5),
            borderRadius: GlassTheme.radiusSmall,
            border: Border.all(
              color: GlassTheme.getBorderColor(context, opacity: 0.3),
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            onChanged: onChanged,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // We remove the default borders since the container handles it
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}