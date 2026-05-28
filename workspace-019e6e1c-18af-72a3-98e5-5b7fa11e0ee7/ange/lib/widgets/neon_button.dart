import 'package:flutter/material.dart';
import '../core/theme.dart';

class NeonButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final Color glowColor;
  const NeonButton({super.key, required this.onPressed, required this.child, this.width = double.infinity, this.height = 56, this.glowColor = AppTheme.fireOrange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: glowColor.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4)),
          BoxShadow(color: glowColor.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, 0)),
        ],
        gradient: const LinearGradient(colors: [AppTheme.fireRed, AppTheme.fireOrange]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          splashColor: Colors.white24,
          child: Center(child: child),
        ),
      ),
    );
  }
}
