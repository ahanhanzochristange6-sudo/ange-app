import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  const GlassCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.cardBackground.withOpacity(0.6),
          border: Border.all(color: AppTheme.fireRed.withOpacity(0.3), width: 1.2),
          boxShadow: [
            BoxShadow(color: AppTheme.fireRed.withOpacity(0.15), blurRadius: 12, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: child,
          ),
        ),
      ),
    );
  }
}
